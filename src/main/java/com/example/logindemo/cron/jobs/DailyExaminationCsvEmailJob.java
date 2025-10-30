package com.example.logindemo.cron.jobs;

import com.example.logindemo.cron.annotation.CronJobDefinition;
import com.example.logindemo.cron.core.AbstractCronJob;
import com.example.logindemo.cron.core.CronJobContext;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.service.EmailService;
import com.example.logindemo.service.dto.EmailAttachment;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("dailyExaminationCsvEmailJob")
@CronJobDefinition(
        name = "Daily Examination CSV Report",
        cron = "0 0 8 * * ?",
        active = true,
        oneTime = false,
        maxRetries = 0,
        retryDelaySeconds = 60,
        concurrentAllowed = false,
        description = "Generates CSVs of examinations created yesterday, grouped by clinic, and emails them to configured recipients"
)
public class DailyExaminationCsvEmailJob extends AbstractCronJob {

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Autowired
    private EmailService emailService;

    @Value("${daily.report.recipients:}")
    private String reportRecipients;

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TS_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    @Transactional
    public void perform(CronJobContext context) throws Exception {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        LocalDateTime start = yesterday.atStartOfDay();
        LocalDateTime end = yesterday.atTime(LocalTime.MAX);

        log(context, "INFO", "Generating examination CSV report for " + yesterday);

        List<ToothClinicalExamination> exams = examinationRepository.findByCreatedAtBetween(start, end);
        if (exams == null) exams = Collections.emptyList();

        Map<String, List<ToothClinicalExamination>> byClinic = exams.stream()
                .collect(Collectors.groupingBy(e -> clinicKey(e.getExaminationClinic())));

        List<EmailAttachment> attachments = new ArrayList<>();
        for (Map.Entry<String, List<ToothClinicalExamination>> entry : byClinic.entrySet()) {
            String clinicKey = entry.getKey();
            List<ToothClinicalExamination> clinicExams = entry.getValue();

            String csv = buildClinicCsv(clinicKey, clinicExams);
            String safeClinic = sanitizeFilename(clinicKey);
            String filename = "examinations_" + safeClinic + "_" + DATE_FMT.format(yesterday) + ".csv";
            attachments.add(new EmailAttachment(filename, csv.getBytes(StandardCharsets.UTF_8), "text/csv"));
        }

        String subject = "Daily Examination CSV Report - " + DATE_FMT.format(yesterday);
        String body;
        if (exams.isEmpty()) {
            body = "No examinations were created on " + DATE_FMT.format(yesterday) + ".";
        } else {
            body = String.format(Locale.ENGLISH,
                    "Attached are CSV files per clinic for examinations created on %s. Total examinations: %d. Clinics: %d.",
                    DATE_FMT.format(yesterday), exams.size(), byClinic.size());
        }

        String configuredCsv = context.getJob() != null ? context.getJob().getRecipientsCsv() : null;
        String effectiveCsv = (configuredCsv != null && !configuredCsv.isBlank()) ? configuredCsv : reportRecipients;
        String[] recipients = parseRecipients(effectiveCsv);
        if (recipients.length == 0) {
            log(context, "ERROR", "No recipients configured (cron job recipientsCsv and daily.report.recipients are empty); skipping email send");
            return; // Don't throw; just log and finish
        }

        emailService.sendMessageWithAttachments(recipients, subject, body, attachments);
        if (configuredCsv != null && !configuredCsv.isBlank()) {
            log(context, "INFO", "Daily examination CSV report sent using cron job recipientsCsv: " + String.join(", ", recipients));
        } else {
            log(context, "INFO", "Daily examination CSV report sent using property daily.report.recipients: " + String.join(", ", recipients));
        }
    }

    private String clinicKey(ClinicModel clinic) {
        if (clinic == null) return "Unknown Clinic";
        String name = clinic.getClinicName();
        String id = clinic.getClinicId();
        if (name != null && !name.isBlank() && id != null && !id.isBlank()) {
            return name + " (" + id + ")";
        }
        if (name != null && !name.isBlank()) return name;
        if (id != null && !id.isBlank()) return id;
        return "Unknown Clinic";
    }

    private String buildClinicCsv(String clinicKey, List<ToothClinicalExamination> exams) {
        StringBuilder sb = new StringBuilder();
        sb.append("Clinic").append(',').append(csvEscape(clinicKey)).append('\n');
        sb.append("Examination ID,Created At,Examination Date,Clinic ID,Clinic Name,Patient ID,Patient Name,Procedure,Procedure Status,Treating Doctor,OPD Doctor,Payment Collected,Payment Remaining").append('\n');
        for (ToothClinicalExamination e : exams) {
            String createdAt = e.getCreatedAt() != null ? TS_FMT.format(e.getCreatedAt()) : "";
            String examDate = e.getExaminationDate() != null ? TS_FMT.format(e.getExaminationDate()) : "";
            String clinicId = e.getExaminationClinic() != null ? nvl(e.getExaminationClinic().getClinicId()) : "";
            String clinicName = e.getExaminationClinic() != null ? nvl(e.getExaminationClinic().getClinicName()) : "";
            String patientId = (e.getPatient() != null && e.getPatient().getId() != null) ? String.valueOf(e.getPatient().getId()) : "";
            String patientName = e.getPatient() != null ? (nvl(e.getPatient().getFirstName()) + " " + nvl(e.getPatient().getLastName())).trim() : "";
            String procedureName = e.getProcedure() != null ? nvl(e.getProcedure().getProcedureName()) : "";
            String status = e.getProcedureStatus() != null ? nvl(e.getProcedureStatus().toString()) : "";

            String treatingDoctor = e.getAssignedDoctor() != null
                    ? (nvl(e.getAssignedDoctor().getFirstName()) + " " + nvl(e.getAssignedDoctor().getLastName())).trim()
                    : "";
            String opdDoctor = e.getOpdDoctor() != null
                    ? (nvl(e.getOpdDoctor().getFirstName()) + " " + nvl(e.getOpdDoctor().getLastName())).trim()
                    : "";
            String paymentCollected = String.valueOf(e.getTotalPaidAmount() != null ? e.getTotalPaidAmount() : 0.0);
            String paymentRemaining = String.valueOf(e.getRemainingAmount() != null ? e.getRemainingAmount() : 0.0);

            sb.append(csvEscape(String.valueOf(e.getId()))).append(',')
              .append(csvEscape(createdAt)).append(',')
              .append(csvEscape(examDate)).append(',')
              .append(csvEscape(clinicId)).append(',')
              .append(csvEscape(clinicName)).append(',')
              .append(csvEscape(patientId)).append(',')
              .append(csvEscape(patientName)).append(',')
              .append(csvEscape(procedureName)).append(',')
              .append(csvEscape(status)).append(',')
              .append(csvEscape(treatingDoctor)).append(',')
              .append(csvEscape(opdDoctor)).append(',')
              .append(csvEscape(paymentCollected)).append(',')
              .append(csvEscape(paymentRemaining)).append('\n');
        }
        return sb.toString();
    }

    private String csvEscape(String v) {
        if (v == null) return "\"\"";
        String escaped = v.replace("\"", "\"\"").replace('\n', ' ').replace('\r', ' ');
        return "\"" + escaped + "\"";
    }

    private String sanitizeFilename(String v) {
        if (v == null || v.isBlank()) return "unknown";
        return v.replaceAll("[^A-Za-z0-9]+", "_").replaceAll("_+", "_").replaceAll("^_+|_+$", "").toLowerCase(Locale.ENGLISH);
    }

    private String nvl(String v) { return v == null ? "" : v; }

    private String[] parseRecipients(String prop) {
        if (prop == null || prop.trim().isEmpty()) return new String[0];
        return Arrays.stream(prop.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toArray(String[]::new);
    }
}
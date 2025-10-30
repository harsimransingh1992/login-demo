package com.example.logindemo.cron.jobs;

import com.example.logindemo.cron.annotation.CronJobDefinition;
import com.example.logindemo.cron.core.AbstractCronJob;
import com.example.logindemo.cron.core.CronJobContext;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.AppointmentRepository;
import com.example.logindemo.service.EmailService;
import com.example.logindemo.service.dto.EmailAttachment;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("doctorDailyExaminationExcelJob")
@CronJobDefinition(
        name = "Doctor Daily Examination Excel Report",
        cron = "0 0 8 * * ?",
        active = true,
        oneTime = false,
        maxRetries = 0,
        retryDelaySeconds = 60,
        concurrentAllowed = false,
        description = "Generates an Excel report of examinations from yesterday grouped by doctor and emails it to configured recipients"
)
public class DoctorDailyExaminationExcelJob extends AbstractCronJob {

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private AppointmentRepository appointmentRepository;

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

        log(context, "INFO", "Generating doctor examination Excel report for " + DATE_FMT.format(yesterday));

        List<ToothClinicalExamination> exams = examinationRepository.findWithDoctorByDateRange(start, end);
        if (exams == null) exams = Collections.emptyList();

        // Fetch appointments for the same day and group by doctor name
        List<Appointment> appts = appointmentRepository.findByAppointmentDateTimeBetween(start, end);
        if (appts == null) appts = Collections.emptyList();
        Map<String, Long> appointmentsByDoctor = appts.stream()
                .collect(Collectors.groupingBy(a -> {
                    User doc = a.getDoctor();
                    if (doc == null) return "Unknown Doctor";
                    String name = (nvl(doc.getFirstName()) + " " + nvl(doc.getLastName())).trim();
                    return name.isBlank() ? "Unknown Doctor" : name;
                }, Collectors.counting()));

        Map<String, List<ToothClinicalExamination>> byDoctor = exams.stream()
                .collect(Collectors.groupingBy(this::doctorKey));

        // Build workbook
        Workbook workbook = new XSSFWorkbook();
        CellStyle headerStyle = createHeaderStyle(workbook);

        // Summary sheet
        Sheet summary = workbook.createSheet("Summary");
        int sRowIdx = 0;
        Row sHeader = summary.createRow(sRowIdx++);
        createHeaderCells(sHeader, headerStyle, new String[]{"Doctor", "Total Examinations", "Appointments", "Clinics"});
        for (Map.Entry<String, List<ToothClinicalExamination>> entry : byDoctor.entrySet()) {
            String doctor = entry.getKey();
            List<ToothClinicalExamination> list = entry.getValue();
            String clinics = list.stream()
                    .map(e -> e.getExaminationClinic() != null ? nvl(e.getExaminationClinic().getClinicName()) : "")
                    .filter(v -> !v.isBlank())
                    .distinct()
                    .sorted()
                    .collect(Collectors.joining(", "));
            Row row = summary.createRow(sRowIdx++);
            int c = 0;
            row.createCell(c++).setCellValue(doctor);
            row.createCell(c++).setCellValue(list.size());
            row.createCell(c++).setCellValue(appointmentsByDoctor.getOrDefault(doctor, 0L));
            row.createCell(c++).setCellValue(clinics);
        }
        autosize(summary, 4);

        // Per-doctor sheets
        for (Map.Entry<String, List<ToothClinicalExamination>> entry : byDoctor.entrySet()) {
            String doctor = entry.getKey();
            List<ToothClinicalExamination> list = entry.getValue();
            Sheet sheet = workbook.createSheet(sanitizeSheetName(doctor));
            int rIdx = 0;
            Row header = sheet.createRow(rIdx++);
            createHeaderCells(header, headerStyle, new String[]{
                    "Examination ID", "Created At", "Examination Date", "Clinic ID", "Clinic Name",
                    "Patient ID", "Patient Name", "Procedure", "Procedure Status",
                    "Treating Doctor", "OPD Doctor", "Payment Collected", "Payment Remaining"
            });

            for (ToothClinicalExamination e : list) {
                Row row = sheet.createRow(rIdx++);
                int c = 0;
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

                row.createCell(c++).setCellValue(String.valueOf(e.getId()));
                row.createCell(c++).setCellValue(createdAt);
                row.createCell(c++).setCellValue(examDate);
                row.createCell(c++).setCellValue(clinicId);
                row.createCell(c++).setCellValue(clinicName);
                row.createCell(c++).setCellValue(patientId);
                row.createCell(c++).setCellValue(patientName);
                row.createCell(c++).setCellValue(procedureName);
                row.createCell(c++).setCellValue(status);
                row.createCell(c++).setCellValue(treatingDoctor);
                row.createCell(c++).setCellValue(opdDoctor);
                row.createCell(c++).setCellValue(paymentCollected);
                row.createCell(c++).setCellValue(paymentRemaining);
            }
            autosize(sheet, 13);
        }

        // Write workbook to bytes
        byte[] excelBytes;
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            workbook.write(baos);
            excelBytes = baos.toByteArray();
        }

        String subject = "Doctor Daily Examination Excel Report - " + DATE_FMT.format(yesterday);
        String body;
        if (exams.isEmpty()) {
            body = "No examinations with doctor assigned were found on " + DATE_FMT.format(yesterday) + ".";
        } else {
            body = String.format(Locale.ENGLISH,
                    "Attached are per-clinic Excel reports grouped by doctor for examinations on %s. Total examinations: %d.",
                    DATE_FMT.format(yesterday), exams.size());
        }

        String configuredCsv = context.getJob() != null ? context.getJob().getRecipientsCsv() : null;
        String effectiveCsv = (configuredCsv != null && !configuredCsv.isBlank()) ? configuredCsv : reportRecipients;
        String[] recipients = parseRecipients(effectiveCsv);
        if (recipients.length == 0) {
            log(context, "ERROR", "No recipients configured (cron job recipientsCsv and daily.report.recipients are empty); skipping email send");
            return;
        }

        List<EmailAttachment> attachments = new ArrayList<>();
        Map<String, List<ToothClinicalExamination>> byClinic = exams.stream()
                .collect(Collectors.groupingBy(this::clinicKey));
        for (Map.Entry<String, List<ToothClinicalExamination>> clinicEntry : byClinic.entrySet()) {
            String clinicName = clinicEntry.getKey();
            List<ToothClinicalExamination> clinicExams = clinicEntry.getValue();

            // Group by doctor within clinic
            Map<String, List<ToothClinicalExamination>> clinicByDoctor = clinicExams.stream()
                    .collect(Collectors.groupingBy(this::doctorKey));

            // Build workbook per clinic
            Workbook clinicWb = new XSSFWorkbook();
            CellStyle headerStyle2 = createHeaderStyle(clinicWb);

            // Summary sheet for clinic
            Sheet summary2 = clinicWb.createSheet("Summary");
            int sRowIdx2 = 0;
            Row sHeader2 = summary2.createRow(sRowIdx2++);
            createHeaderCells(sHeader2, headerStyle2, new String[]{"Doctor", "Total Examinations", "Appointments"});
            // Fetch clinic-specific appointments for the same day and group by doctor
            Long clinicDbId = null;
            if (!clinicExams.isEmpty() && clinicExams.get(0).getExaminationClinic() != null) {
                clinicDbId = clinicExams.get(0).getExaminationClinic().getId();
            }
            List<Appointment> clinicAppts = (clinicDbId != null)
                    ? appointmentRepository.findByClinicIdAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(clinicDbId, start, end)
                    : Collections.emptyList();
            Map<String, Long> clinicAppointmentsByDoctor = clinicAppts.stream()
                    .collect(Collectors.groupingBy(a -> {
                        User doc = a.getDoctor();
                        if (doc == null) return "Unknown Doctor";
                        String name = (nvl(doc.getFirstName()) + " " + nvl(doc.getLastName())).trim();
                        return name.isBlank() ? "Unknown Doctor" : name;
                    }, Collectors.counting()));
            for (Map.Entry<String, List<ToothClinicalExamination>> entry : clinicByDoctor.entrySet()) {
                String doctor = entry.getKey();
                List<ToothClinicalExamination> list = entry.getValue();
                Row row = summary2.createRow(sRowIdx2++);
                int c = 0;
                row.createCell(c++).setCellValue(doctor);
                row.createCell(c++).setCellValue(list.size());
                row.createCell(c++).setCellValue(clinicAppointmentsByDoctor.getOrDefault(doctor, 0L));
            }
            autosize(summary2, 3);

            // Per-doctor sheets within the clinic
            for (Map.Entry<String, List<ToothClinicalExamination>> entry : clinicByDoctor.entrySet()) {
                String doctor = entry.getKey();
                List<ToothClinicalExamination> list = entry.getValue();
                Sheet sheet = clinicWb.createSheet(sanitizeSheetName(doctor));
                int rIdx = 0;
                Row header = sheet.createRow(rIdx++);
                createHeaderCells(header, headerStyle2, new String[]{
                        "Examination ID", "Created At", "Examination Date", "Clinic ID", "Clinic Name",
                        "Patient ID", "Patient Name", "Procedure", "Procedure Status",
                        "Treating Doctor", "OPD Doctor", "Payment Collected", "Payment Remaining"
                });

                for (ToothClinicalExamination e : list) {
                    Row row = sheet.createRow(rIdx++);
                    int c = 0;
                    String createdAt = e.getCreatedAt() != null ? TS_FMT.format(e.getCreatedAt()) : "";
                    String examDate = e.getExaminationDate() != null ? TS_FMT.format(e.getExaminationDate()) : "";
                    String clinicId = e.getExaminationClinic() != null ? nvl(e.getExaminationClinic().getClinicId()) : "";
                    String cName = e.getExaminationClinic() != null ? nvl(e.getExaminationClinic().getClinicName()) : "";
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

                    row.createCell(c++).setCellValue(String.valueOf(e.getId()));
                    row.createCell(c++).setCellValue(createdAt);
                    row.createCell(c++).setCellValue(examDate);
                    row.createCell(c++).setCellValue(clinicId);
                    row.createCell(c++).setCellValue(cName);
                    row.createCell(c++).setCellValue(patientId);
                    row.createCell(c++).setCellValue(patientName);
                    row.createCell(c++).setCellValue(procedureName);
                    row.createCell(c++).setCellValue(status);
                    row.createCell(c++).setCellValue(treatingDoctor);
                    row.createCell(c++).setCellValue(opdDoctor);
                    row.createCell(c++).setCellValue(paymentCollected);
                    row.createCell(c++).setCellValue(paymentRemaining);
                }
                autosize(sheet, 13);
            }

            // Write clinic workbook to bytes and attach
            byte[] clinicBytes;
            try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                clinicWb.write(baos);
                clinicBytes = baos.toByteArray();
            }

            String fileClinicPart = sanitizeSheetName(clinicName).replace(' ', '_');
            attachments.add(new EmailAttachment(
                    "doctor_examinations_" + DATE_FMT.format(yesterday) + "_" + fileClinicPart + ".xlsx",
                    clinicBytes,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            ));
        }

        emailService.sendMessageWithAttachments(recipients, subject, body, attachments);
        if (configuredCsv != null && !configuredCsv.isBlank()) {
            log(context, "INFO", "Doctor examination Excel report sent using cron job recipientsCsv: " + String.join(", ", recipients));
        } else {
            log(context, "INFO", "Doctor examination Excel report sent using property daily.report.recipients: " + String.join(", ", recipients));
        }
    }

    private String clinicKey(ToothClinicalExamination e) {
        String name = (e.getExaminationClinic() != null) ? nvl(e.getExaminationClinic().getClinicName()) : "";
        if (name.isBlank()) {
            String id = (e.getExaminationClinic() != null) ? nvl(e.getExaminationClinic().getClinicId()) : "";
            name = id;
        }
        return name.isBlank() ? "Unknown Clinic" : name;
    }

    private String doctorKey(ToothClinicalExamination e) {
        User doc = e.getAssignedDoctor() != null ? e.getAssignedDoctor() : e.getOpdDoctor();
        if (doc == null) return "Unknown Doctor";
        String name = (nvl(doc.getFirstName()) + " " + nvl(doc.getLastName())).trim();
        return name.isBlank() ? "Unknown Doctor" : name;
    }

    private CellStyle createHeaderStyle(Workbook wb) {
        Font font = wb.createFont();
        font.setBold(true);
        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        return style;
    }

    private void createHeaderCells(Row row, CellStyle style, String[] titles) {
        int c = 0;
        for (String t : titles) {
            Cell cell = row.createCell(c++);
            cell.setCellValue(t);
            cell.setCellStyle(style);
        }
    }

    private void autosize(Sheet sheet, int columns) {
        for (int i = 0; i < columns; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    private String sanitizeSheetName(String v) {
        if (v == null || v.isBlank()) return "Unknown";
        String cleaned = v.replaceAll("[\\\\/*?\n\r\\[\\]]", " ");
        cleaned = cleaned.replaceAll("\\s+", " ").trim();
        if (cleaned.length() > 31) cleaned = cleaned.substring(0, 31);
        return cleaned;
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
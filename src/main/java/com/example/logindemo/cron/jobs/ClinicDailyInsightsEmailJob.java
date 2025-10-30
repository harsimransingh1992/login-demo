package com.example.logindemo.cron.jobs;

import com.example.logindemo.cron.annotation.CronJobDefinition;
import com.example.logindemo.cron.core.AbstractCronJob;
import com.example.logindemo.cron.core.CronJobContext;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.TransactionType;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.PaymentEntryRepository;
import com.example.logindemo.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@Component("clinicDailyInsightsEmailJob")
@CronJobDefinition(
        name = "ClinicDailyInsightsEmailJob",
        description = "Sends a plain-text email with daily insights per clinic: registrations, collections, refunds, and net.",
        cron = "0 0 8 * * ?", // every day at 02:15 AM
        active = true,
        oneTime = false,
        maxRetries = 1,
        retryDelaySeconds = 60,
        concurrentAllowed = false
)
public class ClinicDailyInsightsEmailJob extends AbstractCronJob {

    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private PaymentEntryRepository paymentEntryRepository;

    @Autowired
    private EmailService emailService;

    @Value("${daily.report.recipients:}")
    private String reportRecipients;

    @Override
    public void onStart(CronJobContext context) {
        log(context, "INFO", "Clinic daily insights job starting");
    }

    @Override
    @Transactional
    public void perform(CronJobContext context) throws Exception {
        LocalDate reportDate = LocalDate.now().minusDays(1); // previous day
        LocalDateTime startOfDay = reportDate.atStartOfDay();
        LocalDateTime endOfDay = reportDate.plusDays(1).atStartOfDay();

        log(context, "INFO", "Computing insights for date: " + reportDate);

        // Load clinics (sorted for stable output)
        List<ClinicModel> clinics = clinicRepository.findAll().stream()
                .sorted(Comparator.comparing(ClinicModel::getClinicName, Comparator.nullsLast(String::compareToIgnoreCase)))
                .collect(Collectors.toList());

        // Patient registrations per clinic in date range
        Date start = Date.from(startOfDay.atZone(ZoneId.systemDefault()).toInstant());
        Date end = Date.from(endOfDay.atZone(ZoneId.systemDefault()).toInstant());
        List<Object[]> registrationsRaw = patientRepository.countRegisteredByClinicAndDate(start, end);
        Map<Long, Long> registrationsByClinicId = new HashMap<>();
        for (Object[] row : registrationsRaw) {
            if (row != null && row.length >= 2 && row[0] != null && row[1] != null) {
                Long clinicId = (Long) row[0];
                Long count = (Long) row[1];
                registrationsByClinicId.put(clinicId, count);
            }
        }

        // Payments and refunds per clinic in date range (fetch-join to avoid lazy issues)
        List<PaymentEntry> paymentEntries = paymentEntryRepository.findAllWithExaminationClinicByPaymentDateBetween(startOfDay, endOfDay);
        Map<Long, List<PaymentEntry>> paymentsByClinicId = paymentEntries.stream()
                .filter(p -> p.getExamination() != null && p.getExamination().getExaminationClinic() != null)
                .collect(Collectors.groupingBy(p -> p.getExamination().getExaminationClinic().getId()));

        // Aggregate per clinic
        StringBuilder body = new StringBuilder();
        body.append("Daily Clinic Insights for ").append(reportDate).append("\n");
        body.append("Generated at: ").append(LocalDateTime.now()).append("\n\n");

        body.append("Clinic-wise Summary\n");
        body.append("===================\n");

        long totalRegistrations = 0L;
        double totalCaptured = 0.0;
        double totalRefunded = 0.0;
        int totalTransactions = 0;

        for (ClinicModel clinic : clinics) {
            Long id = clinic.getId();
            String name = clinic.getClinicName();
            String code = clinic.getClinicId();

            long registrations = registrationsByClinicId.getOrDefault(id, 0L);
            List<PaymentEntry> clinicPayments = paymentsByClinicId.getOrDefault(id, Collections.emptyList());

            double captured = clinicPayments.stream()
                    .filter(p -> p.getTransactionType() == TransactionType.CAPTURE)
                    .mapToDouble(p -> p.getAmount() != null ? p.getAmount() : 0.0)
                    .sum();

            double refunded = clinicPayments.stream()
                    .filter(p -> p.getTransactionType() == TransactionType.REFUND)
                    .mapToDouble(p -> p.getAmount() != null ? p.getAmount() : 0.0)
                    .sum();

            int transactions = (int) clinicPayments.size();
            double net = captured - refunded;

            totalRegistrations += registrations;
            totalCaptured += captured;
            totalRefunded += refunded;
            totalTransactions += transactions;

            body.append("Clinic: ")
                .append(name != null ? name : "-")
                .append(" (ID: ").append(code != null ? code : id).append(")\n")
                .append("Registrations: ").append(registrations).append("\n")
                .append("Collected (Captured): ").append(Math.round(captured)).append("\n")
                .append("Refunded: ").append(Math.round(refunded)).append("\n")
                .append("Net Collections: ").append(Math.round(net)).append("\n")
                .append("Transactions: ").append(transactions).append("\n\n");
        }

        body.append("Totals\n");
        body.append("======\n");
        body.append("Total Registrations: ").append(totalRegistrations).append("\n");
        body.append("Total Collected (Captured): ").append(Math.round(totalCaptured)).append("\n");
        body.append("Total Refunded: ").append(Math.round(totalRefunded)).append("\n");
        body.append("Total Net Collections: ").append(Math.round(totalCaptured - totalRefunded)).append("\n");
        body.append("Total Transactions: ").append(totalTransactions).append("\n");

        String subject = "Clinic Insights: " + reportDate;

        String configuredCsv = context.getJob() != null ? context.getJob().getRecipientsCsv() : null;
        String effectiveCsv = (configuredCsv != null && !configuredCsv.isBlank()) ? configuredCsv : reportRecipients;
        String[] recipients = parseRecipients(effectiveCsv);
        if (recipients.length == 0) {
            log(context, "ERROR", "No recipients configured (cron job recipientsCsv and insights.report.recipients are empty); skipping email send");
            return;
        }

        emailService.sendMessageWithAttachments(recipients, subject, body.toString(), null);
        if (configuredCsv != null && !configuredCsv.isBlank()) {
            log(context, "INFO", "Clinic insights report sent using cron job recipientsCsv: " + String.join(", ", recipients));
        } else {
            log(context, "INFO", "Clinic insights report sent using property insights.report.recipients: " + String.join(", ", recipients));
        }
    }

    @Override
    public void onFinish(CronJobContext context) {
        log(context, "INFO", "Clinic daily insights job finished successfully");
    }

    @Override
    public void onError(CronJobContext context, Exception e) {
        log(context, "ERROR", "Clinic daily insights job failed: " + e.getMessage());
    }

    private String[] parseRecipients(String csv) {
        if (csv == null || csv.isBlank()) return new String[0];
        return Arrays.stream(csv.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toArray(String[]::new);
    }
}
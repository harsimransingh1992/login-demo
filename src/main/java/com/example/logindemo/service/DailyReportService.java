package com.example.logindemo.service;

import com.example.logindemo.service.report.provider.PaymentsProvider;
import com.example.logindemo.service.report.provider.RegistrationsProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class DailyReportService {
    @Autowired
    private RegistrationsProvider registrationsProvider;

    @Autowired
    private PaymentsProvider paymentsProvider;

    /**
     * Generate daily patient registration report for all clinics
     * @return formatted report string with patient registration numbers
     */
    public String generateDailyPatientRegistrationReport() {
        try {
            LocalDate yesterday = LocalDate.now().minusDays(1);
            log.info("Generating daily report (JSON-based) for date: {}", yesterday);

            Map<String, Object> params = Map.of("date", yesterday);
            Map<String, Object> registrationsJson = registrationsProvider.getData(params);
            Map<String, Object> paymentsJson = paymentsProvider.getData(Map.of("date", yesterday, "includeRefunds", Boolean.TRUE));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> regClinics = (List<Map<String, Object>>) registrationsJson.get("clinics");
            Map<String, Object> regTotals = (Map<String, Object>) registrationsJson.get("totals");

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> payClinics = (List<Map<String, Object>>) paymentsJson.get("clinics");
            Map<String, Object> payTotals = (Map<String, Object>) paymentsJson.get("totals");

            // Build the report in the same plain text format
            StringBuilder report = new StringBuilder();
            report.append("DAILY PATIENT REGISTRATION REPORT\n");
            report.append("Date: ").append(yesterday).append("\n");
            report.append("=====================================\n\n");

            // Registrations per clinic
            List<Map<String, Object>> sortedRegClinics = regClinics.stream()
                    .sorted(Comparator.comparing(c -> String.valueOf(c.getOrDefault("name", "")), String.CASE_INSENSITIVE_ORDER))
                    .toList();

            int clinicsWithRegistrations = 0;
            for (Map<String, Object> clinic : sortedRegClinics) {
                long count = toLong(clinic.get("registrations"));
                if (count > 0) clinicsWithRegistrations++;
                report.append("Clinic: ")
                      .append(String.valueOf(clinic.getOrDefault("name", "-")))
                      .append(" (ID: ")
                      .append(String.valueOf(clinic.getOrDefault("code", clinic.get("id"))))
                      .append(")\n");
                report.append("New Patient Registrations: ").append(count).append("\n\n");
            }

            // Summary section
            report.append("=====================================\n");
            report.append("SUMMARY\n");
            report.append("=====================================\n");
            report.append("Total Clinics: ").append(sortedRegClinics.size()).append("\n");
            report.append("Clinics with New Registrations: ").append(clinicsWithRegistrations).append("\n");
            report.append("Total New Patient Registrations: ").append(toLong(regTotals.get("registrations"))).append("\n");

            // Payment collections section
            report.append("\n");
            report.append("=====================================\n");
            report.append("PAYMENT COLLECTIONS\n");
            report.append("=====================================\n");

            List<Map<String, Object>> sortedPayClinics = payClinics.stream()
                    .sorted(Comparator.comparing(c -> String.valueOf(c.getOrDefault("name", "")), String.CASE_INSENSITIVE_ORDER))
                    .toList();

            for (Map<String, Object> clinic : sortedPayClinics) {
                double captured = toDouble(clinic.get("captured"));
                double refunded = toDouble(clinic.get("refunded"));
                double net = toDouble(clinic.get("net"));
                int transactions = toInt(clinic.get("transactions"));

                report.append("Clinic: ")
                      .append(String.valueOf(clinic.getOrDefault("name", "-")))
                      .append(" (ID: ")
                      .append(String.valueOf(clinic.getOrDefault("code", clinic.get("id"))))
                      .append(")\n")
                      .append("Collected (Captured): ").append(Math.round(captured)).append("\n")
                      .append("Refunded: ").append(Math.round(refunded)).append("\n")
                      .append("Net Collections: ").append(Math.round(net)).append("\n")
                      .append("Transactions: ").append(transactions).append("\n\n");
            }

            report.append("TOTAL COLLECTIONS SUMMARY\n");
            report.append("Total Captured: ").append(Math.round(toDouble(payTotals.get("captured")))).append("\n");
            report.append("Total Refunded: ").append(Math.round(toDouble(payTotals.get("refunded")))).append("\n");
            report.append("Net Collections: ").append(Math.round(toDouble(payTotals.get("net")))).append("\n");
            report.append("Total Transactions: ").append(toInt(payTotals.get("transactions"))).append("\n");

            log.info("Daily report generated successfully (JSON-based). Total registrations: {}", toLong(regTotals.get("registrations")));
            return report.toString();

        } catch (Exception e) {
            log.error("Error generating daily patient registration report (JSON-based)", e);
            return "Error generating daily report: " + e.getMessage();
        }
    }

    /**
     * Get total patient registrations for yesterday across all clinics
     * @return total count
     */
    public long getTotalRegistrationsYesterday() {
        try {
            LocalDate yesterday = LocalDate.now().minusDays(1);
            Map<String, Object> json = registrationsProvider.getData(Map.of("date", yesterday));
            Map<String, Object> totals = (Map<String, Object>) json.get("totals");
            return toLong(totals.get("registrations"));
        } catch (Exception e) {
            log.error("Error getting total registrations for yesterday (JSON-based)", e);
            return 0;
        }
    }

    private double toDouble(Object v) {
        if (v == null) return 0.0;
        if (v instanceof Number) return ((Number) v).doubleValue();
        try { return Double.parseDouble(String.valueOf(v)); } catch (Exception e) { return 0.0; }
    }

    private int toInt(Object v) {
        if (v == null) return 0;
        if (v instanceof Number) return ((Number) v).intValue();
        try { return Integer.parseInt(String.valueOf(v)); } catch (Exception e) { return 0; }
    }

    private long toLong(Object v) {
        if (v == null) return 0L;
        if (v instanceof Number) return ((Number) v).longValue();
        try { return Long.parseLong(String.valueOf(v)); } catch (Exception e) { return 0L; }
    }
}
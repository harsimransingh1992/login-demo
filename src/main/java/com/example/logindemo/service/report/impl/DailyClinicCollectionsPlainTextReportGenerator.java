package com.example.logindemo.service.report.impl;

import com.example.logindemo.service.report.ReportGenerator;
import com.example.logindemo.service.report.provider.PaymentsProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Component("dailyClinicCollectionsPlainTextReport")
public class DailyClinicCollectionsPlainTextReportGenerator implements ReportGenerator {

    @Autowired
    private PaymentsProvider paymentsProvider;

    @Override
    public String generateReport(Map<String, Object> parameters) {
        LocalDate reportDate = parameters.containsKey("date")
                ? (LocalDate) parameters.get("date")
                : LocalDate.now().minusDays(1);

        Map<String, Object> json = paymentsProvider.getData(parameters);

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> clinics = (List<Map<String, Object>>) json.get("clinics");

        Map<String, Object> totals = (Map<String, Object>) json.get("totals");

        StringBuilder sb = new StringBuilder();
        sb.append("Daily Clinic Collections Report\n");
        sb.append("Date: ").append(reportDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"))).append("\n\n");

        // Sort clinics by name for consistent display
        List<Map<String, Object>> sortedClinics = clinics.stream()
                .sorted(Comparator.comparing(c -> String.valueOf(c.getOrDefault("name", "")), String.CASE_INSENSITIVE_ORDER))
                .toList();

        for (Map<String, Object> clinic : sortedClinics) {
            String name = String.valueOf(clinic.getOrDefault("name", "-"));
            Object codeOrId = clinic.get("code") != null ? clinic.get("code") : clinic.get("id");
            double captured = toDouble(clinic.get("captured"));
            double refunded = toDouble(clinic.get("refunded"));
            double net = toDouble(clinic.get("net"));
            int transactions = clinic.get("transactions") != null ? Integer.parseInt(String.valueOf(clinic.get("transactions"))) : 0;

            sb.append("Clinic: ").append(name)
              .append(" (ID: ").append(String.valueOf(codeOrId)).append(")\n")
              .append("  Captured: ").append(String.format("%.2f", captured)).append("\n")
              .append("  Refunded: ").append(String.format("%.2f", refunded)).append("\n")
              .append("  Net: ").append(String.format("%.2f", net)).append("\n")
              .append("  Transactions: ").append(transactions).append("\n\n");
        }

        sb.append("Summary\n");
        sb.append("  Total Captured: ").append(String.format("%.2f", toDouble(totals.get("captured")))).append("\n");
        sb.append("  Total Refunded: ").append(String.format("%.2f", toDouble(totals.get("refunded")))).append("\n");
        sb.append("  Net Collections: ").append(String.format("%.2f", toDouble(totals.get("net")))).append("\n");
        sb.append("  Total Transactions: ").append(String.valueOf(totals.getOrDefault("transactions", 0))).append("\n");

        return sb.toString();
    }

    @Override
    public String getReportName() {
        return "Daily Clinic Collections Report (Plain Text)";
    }

    @Override
    public String getReportDescription() {
        return "Plain text summary of daily payments per clinic";
    }

    @Override
    public String[] getSupportedFormats() {
        return new String[]{"TEXT"};
    }

    @Override
    public Map<String, Object> getDefaultParameters() {
        return Map.of(
                "date", LocalDate.now().minusDays(1),
                "includeRefunds", Boolean.TRUE
        );
    }

    private double toDouble(Object v) {
        if (v == null) return 0.0;
        if (v instanceof Number) return ((Number) v).doubleValue();
        try { return Double.parseDouble(String.valueOf(v)); } catch (Exception e) { return 0.0; }
    }
}
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

/**
 * Daily Clinic Collections Report Generator
 * Generates a daily summary of payments collected per clinic
 */
@Component("dailyClinicCollectionsReport")
public class DailyClinicCollectionsReportGenerator implements ReportGenerator {

    @Autowired
    private PaymentsProvider paymentsProvider;

    @Override
    public String generateReport(Map<String, Object> parameters) {
        try {
            LocalDate reportDate = parameters.containsKey("date")
                    ? (LocalDate) parameters.get("date")
                    : LocalDate.now().minusDays(1);

            Map<String, Object> json = paymentsProvider.getData(parameters);

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> clinics = (List<Map<String, Object>>) json.get("clinics");
            Map<String, Object> totals = (Map<String, Object>) json.get("totals");

            StringBuilder report = new StringBuilder();
            report.append("<h2>Daily Clinic Collections Report</h2>");
            report.append("<h3>Date: ").append(reportDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"))).append("</h3>");

            // Sort clinics by name for consistent display
            List<Map<String, Object>> sortedClinics = clinics.stream()
                    .sorted(Comparator.comparing(c -> String.valueOf(c.getOrDefault("name", "")), String.CASE_INSENSITIVE_ORDER))
                    .toList();

            report.append("<table border='1' cellspacing='0' cellpadding='6' style='border-collapse: collapse; width: 100%;'>");
            report.append("<thead><tr>")
                  .append("<th>Clinic Name</th>")
                  .append("<th>Clinic ID</th>")
                  .append("<th>Captured Amount</th>")
                  .append("<th>Refund Amount</th>")
                  .append("<th>Net Collections</th>")
                  .append("<th>Transactions</th>")
                  .append("</tr></thead><tbody>");

            for (Map<String, Object> clinic : sortedClinics) {
                String name = String.valueOf(clinic.getOrDefault("name", "-"));
                Object codeOrId = clinic.get("code") != null ? clinic.get("code") : clinic.get("id");
                double captured = toDouble(clinic.get("captured"));
                double refunded = toDouble(clinic.get("refunded"));
                double net = toDouble(clinic.get("net"));
                int transactions = clinic.get("transactions") != null ? Integer.parseInt(String.valueOf(clinic.get("transactions"))) : 0;

                report.append("<tr>")
                      .append("<td>").append(name).append("</td>")
                      .append("<td>").append(String.valueOf(codeOrId)).append("</td>")
                      .append("<td>").append(String.format("%.2f", captured)).append("</td>")
                      .append("<td>").append(String.format("%.2f", refunded)).append("</td>")
                      .append("<td>").append(String.format("%.2f", net)).append("</td>")
                      .append("<td>").append(transactions).append("</td>")
                      .append("</tr>");
            }

            report.append("</tbody></table>");

            report.append("<div class='summary'>");
            report.append("<h4>Summary</h4>");
            report.append("<ul>");
            report.append("<li>Total Captured: ").append(String.format("%.2f", toDouble(totals.get("captured")))).append("</li>");
            report.append("<li>Total Refunded: ").append(String.format("%.2f", toDouble(totals.get("refunded")))).append("</li>");
            report.append("<li>Net Collections: ").append(String.format("%.2f", toDouble(totals.get("net")))).append("</li>");
            report.append("<li>Total Transactions: ").append(String.valueOf(totals.getOrDefault("transactions", 0))).append("</li>");
            report.append("</ul>");
            report.append("</div>");

            return report.toString();
        } catch (Exception e) {
            return "<div class='error'>Error generating daily clinic collections report: " + e.getMessage() + "</div>";
        }
    }

    @Override
    public String getReportName() {
        return "Daily Clinic Collections Report";
    }

    @Override
    public String getReportDescription() {
        return "Daily summary of payments collected (captures and refunds) per clinic";
    }

    @Override
    public String[] getSupportedFormats() {
        return new String[]{"HTML", "CSV"};
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
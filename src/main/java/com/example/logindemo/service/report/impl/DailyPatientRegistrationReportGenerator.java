package com.example.logindemo.service.report.impl;

import com.example.logindemo.service.report.ReportGenerator;
import com.example.logindemo.service.report.provider.RegistrationsProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

/**
 * Daily Patient Registration Report Generator
 * Spring bean that generates daily patient registration reports
 */
@Component("dailyPatientRegistrationReport")
public class DailyPatientRegistrationReportGenerator implements ReportGenerator {
    
    @Autowired
    private RegistrationsProvider registrationsProvider;
    
    @Override
    public String generateReport(Map<String, Object> parameters) {
        try {
            // Get date parameter or use yesterday as default
            LocalDate reportDate = parameters.containsKey("date") 
                ? (LocalDate) parameters.get("date") 
                : LocalDate.now().minusDays(1);
            
            Map<String, Object> json = registrationsProvider.getData(Map.of("date", reportDate));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> clinics = (List<Map<String, Object>>) json.get("clinics");
            Map<String, Object> totals = (Map<String, Object>) json.get("totals");

            StringBuilder reportContent = new StringBuilder();
            reportContent.append("<h2>Daily Patient Registration Report</h2>");
            reportContent.append("<h3>Date: ").append(reportDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"))).append("</h3>");

            reportContent.append("<div class='metric'>");
            reportContent.append("<h4>Total New Registrations: ").append(String.valueOf(totals.getOrDefault("registrations", 0))).append("</h4>");
            reportContent.append("</div>");

            List<Map<String, Object>> sortedClinics = clinics.stream()
                    .sorted(Comparator.comparing(c -> String.valueOf(c.getOrDefault("name", "")), String.CASE_INSENSITIVE_ORDER))
                    .toList();

            reportContent.append("<table border='1' cellspacing='0' cellpadding='6' style='border-collapse: collapse; width: 100%;'>");
            reportContent.append("<thead><tr>")
                    .append("<th>Clinic</th>")
                    .append("<th>Clinic ID</th>")
                    .append("<th>New Registrations</th>")
                    .append("</tr></thead><tbody>");

            for (Map<String, Object> clinic : sortedClinics) {
                reportContent.append("<tr>")
                        .append("<td>").append(String.valueOf(clinic.getOrDefault("name", "-"))).append("</td>")
                        .append("<td>").append(String.valueOf(clinic.getOrDefault("code", clinic.get("id")))).append("</td>")
                        .append("<td>").append(String.valueOf(clinic.getOrDefault("registrations", 0))).append("</td>")
                        .append("</tr>");
            }

            reportContent.append("</tbody></table>");

            reportContent.append("<div class='summary'>");
            reportContent.append("<h4>Summary:</h4>");
            reportContent.append("<ul>");
            reportContent.append("<li>Total Registrations: ").append(String.valueOf(totals.getOrDefault("registrations", 0))).append("</li>");
            reportContent.append("<li>Report Generated: ").append(java.time.LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm"))).append("</li>");
            reportContent.append("</ul>");
            reportContent.append("</div>");

            return reportContent.toString();
            
        } catch (Exception e) {
            return "<div class='error'>Error generating daily patient registration report: " + e.getMessage() + "</div>";
        }
    }
    
    @Override
    public String getReportName() {
        return "Daily Patient Registration Report";
    }
    
    @Override
    public String getReportDescription() {
        return "Daily summary of new patient registrations including total count and patient details";
    }
    
    @Override
    public String[] getSupportedFormats() {
        return new String[]{"HTML", "PDF", "CSV"};
    }
    
    @Override
    public boolean validateParameters(Map<String, Object> parameters) {
        // Validate date parameter if provided
        if (parameters.containsKey("date")) {
            Object dateParam = parameters.get("date");
            return dateParam instanceof LocalDate;
        }
        return true;
    }
    
    @Override
    public Map<String, Object> getDefaultParameters() {
        return Map.of("date", LocalDate.now().minusDays(1));
    }
}
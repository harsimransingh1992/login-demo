package com.example.logindemo.service.report.impl;

import com.example.logindemo.service.DailyReportService;
import com.example.logindemo.service.report.ReportGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

/**
 * Daily Patient Registration Report Generator
 * Spring bean that generates daily patient registration reports
 */
@Component("dailyPatientRegistrationReport")
public class DailyPatientRegistrationReportGenerator implements ReportGenerator {
    
    @Autowired
    private DailyReportService dailyReportService;
    
    @Override
    public String generateReport(Map<String, Object> parameters) {
        try {
            // Get date parameter or use yesterday as default
            LocalDate reportDate = parameters.containsKey("date") 
                ? (LocalDate) parameters.get("date") 
                : LocalDate.now().minusDays(1);
            
            // Generate the report content
            StringBuilder reportContent = new StringBuilder();
            reportContent.append("<h2>Daily Patient Registration Report</h2>");
            reportContent.append("<h3>Date: ").append(reportDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"))).append("</h3>");
            
            // Get registration statistics
            long totalRegistrations = dailyReportService.getTotalRegistrationsYesterday();
            reportContent.append("<div class='metric'>");
            reportContent.append("<h4>Total New Registrations: ").append(totalRegistrations).append("</h4>");
            reportContent.append("</div>");
            
            // Add detailed patient list if available
            reportContent.append("<div class='patient-list'>");
            reportContent.append("<h4>New Patient Details:</h4>");
            // Note: You may need to add a method to get detailed patient list
            reportContent.append("<p>Detailed patient information would be listed here.</p>");
            reportContent.append("</div>");
            
            // Add summary statistics
            reportContent.append("<div class='summary'>");
            reportContent.append("<h4>Summary:</h4>");
            reportContent.append("<ul>");
            reportContent.append("<li>Total Registrations: ").append(totalRegistrations).append("</li>");
            reportContent.append("<li>Report Generated: ").append(LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm"))).append("</li>");
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
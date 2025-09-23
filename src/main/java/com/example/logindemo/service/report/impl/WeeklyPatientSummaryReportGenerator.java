package com.example.logindemo.service.report.impl;

import com.example.logindemo.service.AdminReportService;
import com.example.logindemo.service.report.ReportGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

/**
 * Weekly Patient Summary Report Generator
 * Spring bean that generates weekly patient summary reports
 */
@Component("weeklyPatientSummaryReport")
public class WeeklyPatientSummaryReportGenerator implements ReportGenerator {
    
    @Autowired
    private AdminReportService adminReportService;
    
    @Override
    public String generateReport(Map<String, Object> parameters) {
        try {
            // Get date range parameters or use last week as default
            LocalDateTime endDate = parameters.containsKey("endDate") 
                ? (LocalDateTime) parameters.get("endDate") 
                : LocalDateTime.now();
            
            LocalDateTime startDate = parameters.containsKey("startDate") 
                ? (LocalDateTime) parameters.get("startDate") 
                : endDate.minusWeeks(1);
            
            // Generate the report content
            StringBuilder reportContent = new StringBuilder();
            reportContent.append("<h2>Weekly Patient Summary Report</h2>");
            reportContent.append("<h3>Period: ")
                        .append(startDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")))
                        .append(" to ")
                        .append(endDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")))
                        .append("</h3>");
            
            // Get key metrics
            long totalProcedures = adminReportService.getTotalProcedures(startDate, endDate);
            double totalRevenue = adminReportService.getTotalRevenue(startDate, endDate);
            double avgProcedureTime = adminReportService.getAverageProcedureTime(startDate, endDate);
            double successRate = adminReportService.getSuccessRate(startDate, endDate);
            
            // Add metrics section
            reportContent.append("<div class='metrics-section'>");
            reportContent.append("<h4>Key Performance Indicators</h4>");
            reportContent.append("<div class='metrics-grid'>");
            reportContent.append("<div class='metric-card'>");
            reportContent.append("<h5>Total Procedures</h5>");
            reportContent.append("<span class='metric-value'>").append(totalProcedures).append("</span>");
            reportContent.append("</div>");
            
            reportContent.append("<div class='metric-card'>");
            reportContent.append("<h5>Total Revenue</h5>");
            reportContent.append("<span class='metric-value'>₹").append(String.format("%.2f", totalRevenue)).append("</span>");
            reportContent.append("</div>");
            
            reportContent.append("<div class='metric-card'>");
            reportContent.append("<h5>Average Procedure Time</h5>");
            reportContent.append("<span class='metric-value'>").append(String.format("%.1f", avgProcedureTime)).append(" min</span>");
            reportContent.append("</div>");
            
            reportContent.append("<div class='metric-card'>");
            reportContent.append("<h5>Success Rate</h5>");
            reportContent.append("<span class='metric-value'>").append(String.format("%.1f", successRate)).append("%</span>");
            reportContent.append("</div>");
            reportContent.append("</div>");
            reportContent.append("</div>");
            
            // Add procedure distribution
            reportContent.append("<div class='distribution-section'>");
            reportContent.append("<h4>Procedure Distribution</h4>");
            var procedureDistribution = adminReportService.getProcedureDistribution(startDate, endDate);
            reportContent.append("<ul>");
            procedureDistribution.forEach((procedure, count) -> {
                reportContent.append("<li>").append(procedure).append(": ").append(count).append("</li>");
            });
            reportContent.append("</ul>");
            reportContent.append("</div>");
            
            // Add summary
            reportContent.append("<div class='summary'>");
            reportContent.append("<h4>Weekly Summary:</h4>");
            reportContent.append("<ul>");
            reportContent.append("<li>Total Procedures Completed: ").append(totalProcedures).append("</li>");
            reportContent.append("<li>Revenue Generated: ₹").append(String.format("%.2f", totalRevenue)).append("</li>");
            reportContent.append("<li>Overall Success Rate: ").append(String.format("%.1f", successRate)).append("%</li>");
            reportContent.append("<li>Report Generated: ").append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm"))).append("</li>");
            reportContent.append("</ul>");
            reportContent.append("</div>");
            
            return reportContent.toString();
            
        } catch (Exception e) {
            return "<div class='error'>Error generating weekly patient summary report: " + e.getMessage() + "</div>";
        }
    }
    
    @Override
    public String getReportName() {
        return "Weekly Patient Summary Report";
    }
    
    @Override
    public String getReportDescription() {
        return "Comprehensive weekly summary including procedures, revenue, success rates, and performance metrics";
    }
    
    @Override
    public String[] getSupportedFormats() {
        return new String[]{"HTML", "PDF", "CSV", "EXCEL"};
    }
    
    @Override
    public boolean validateParameters(Map<String, Object> parameters) {
        // Validate date parameters if provided
        if (parameters.containsKey("startDate") && parameters.containsKey("endDate")) {
            Object startParam = parameters.get("startDate");
            Object endParam = parameters.get("endDate");
            
            if (!(startParam instanceof LocalDateTime) || !(endParam instanceof LocalDateTime)) {
                return false;
            }
            
            LocalDateTime start = (LocalDateTime) startParam;
            LocalDateTime end = (LocalDateTime) endParam;
            
            return start.isBefore(end);
        }
        return true;
    }
    
    @Override
    public Map<String, Object> getDefaultParameters() {
        LocalDateTime now = LocalDateTime.now();
        return Map.of(
            "startDate", now.minusWeeks(1),
            "endDate", now
        );
    }
}
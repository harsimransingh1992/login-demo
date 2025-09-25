package com.example.logindemo.service.report.impl;

import com.example.logindemo.service.DailyReportService;
import com.example.logindemo.service.report.ReportGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Plain Text Daily Patient Registration Report Generator
 * Spring bean that generates daily patient registration reports in plain text format
 * This generator uses the existing DailyReportService to produce clean text output
 * suitable for email delivery
 */
@Component("dailyPatientRegistrationPlainTextReport")
public class DailyPatientRegistrationPlainTextReportGenerator implements ReportGenerator {
    
    @Autowired
    private DailyReportService dailyReportService;

    @Override
    public String generateReport(Map<String, Object> parameters) {
        try {
            // Use the existing DailyReportService which generates clean plain text
            return dailyReportService.generateDailyPatientRegistrationReport();
            
        } catch (Exception e) {
            return "Error generating daily patient registration report: " + e.getMessage();
        }
    }

    @Override
    public String getReportName() {
        return "Daily Patient Registration Report (Plain Text)";
    }
    
    @Override
    public String getReportDescription() {
        return "Daily summary of new patient registrations in plain text format, suitable for email delivery";
    }
    
    @Override
    public String[] getSupportedFormats() {
        return new String[]{"TEXT", "EMAIL"};
    }
}
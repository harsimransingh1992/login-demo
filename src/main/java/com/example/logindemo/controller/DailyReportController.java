package com.example.logindemo.controller;

import com.example.logindemo.scheduler.DailyReportScheduler;
import com.example.logindemo.service.DailyReportService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/daily-report")
@Slf4j
public class DailyReportController {

    @Autowired
    private DailyReportService dailyReportService;

    @Autowired
    private DailyReportScheduler dailyReportScheduler;

    /**
     * Manually trigger daily report generation and sending (for testing)
     * Only accessible by ADMIN users
     */
    @GetMapping("/trigger")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> triggerDailyReport() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            log.info("Manual daily report trigger requested");
            
            // Trigger the scheduled task manually
            dailyReportScheduler.triggerManualReport();
            
            response.put("success", true);
            response.put("message", "Daily report has been triggered successfully");
            response.put("timestamp", System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error triggering manual daily report", e);
            
            response.put("success", false);
            response.put("message", "Failed to trigger daily report: " + e.getMessage());
            response.put("timestamp", System.currentTimeMillis());
            
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * Get daily report content without sending email (for preview)
     * Only accessible by ADMIN users
     */
    @GetMapping("/preview")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> previewDailyReport() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            log.info("Daily report preview requested");
            
            // Generate report content
            String reportContent = dailyReportService.generateDailyPatientRegistrationReport();
            long totalRegistrations = dailyReportService.getTotalRegistrationsYesterday();
            
            response.put("success", true);
            response.put("reportContent", reportContent);
            response.put("totalRegistrations", totalRegistrations);
            response.put("timestamp", System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error generating daily report preview", e);
            
            response.put("success", false);
            response.put("message", "Failed to generate report preview: " + e.getMessage());
            response.put("timestamp", System.currentTimeMillis());
            
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
package com.example.logindemo.controller;

import com.example.logindemo.model.ReportTrigger;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.service.ReportTriggerService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.DailyReportService;
import com.example.logindemo.service.EmailService;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin/reports")
@Slf4j
public class AdminReportDashboardController {

    @Autowired
    private ReportTriggerService reportTriggerService;

    @Autowired
    private UserService userService;
    
    @Autowired
    private DailyReportService dailyReportService;
    
    @Autowired
    private EmailService emailService;
    
    @Autowired
    private com.example.logindemo.service.report.ReportExecutionService reportExecutionService;

    /**
     * Display the admin report dashboard page
     */
    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('ADMIN')")
    public String showReportDashboard(Model model) {
        try {
            // Get current user
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            Optional<User> currentUser = userService.findByUsername(currentUsername);
            
            if (currentUser.isEmpty() || currentUser.get().getRole() != UserRole.ADMIN) {
                log.warn("Unauthorized access attempt to report dashboard by user: {}", currentUsername);
                return "redirect:/access-denied";
            }

            // Get all report triggers
            List<ReportTrigger> reportTriggers = reportTriggerService.getAllReportTriggers();
            
            // Convert LocalDateTime fields to Date for JSP compatibility
            // Use IST timezone explicitly for consistent display
            ZoneId istZone = ZoneId.of("Asia/Kolkata");
            for (ReportTrigger trigger : reportTriggers) {
                if (trigger.getNextExecution() != null) {
                    Date nextExecutionDate = Date.from(trigger.getNextExecution().atZone(istZone).toInstant());
                    trigger.setNextExecutionDate(nextExecutionDate);
                }
                if (trigger.getLastExecuted() != null) {
                    Date lastExecutedDate = Date.from(trigger.getLastExecuted().atZone(istZone).toInstant());
                    trigger.setLastExecutedDate(lastExecutedDate);
                }
            }
            
            model.addAttribute("reportTriggers", reportTriggers);
            
            // Get execution statistics
            ReportTriggerService.ReportExecutionStats stats = reportTriggerService.getExecutionStats();
            model.addAttribute("executionStats", stats);
            
            // Add current user info
            model.addAttribute("currentUser", currentUser.get());
            
            log.info("Admin {} accessed report dashboard with {} triggers", currentUsername, reportTriggers.size());
            return "admin/report-dashboard";
            
        } catch (Exception e) {
            log.error("Error loading report dashboard: {}", e.getMessage(), e);
            model.addAttribute("error", "Error loading dashboard: " + e.getMessage());
            return "admin/report-dashboard";
        }
    }

    /**
     * Get all report triggers as JSON
     */
    @GetMapping("/api/triggers")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<List<ReportTrigger>> getAllTriggers() {
        try {
            List<ReportTrigger> triggers = reportTriggerService.getAllReportTriggers();
            return ResponseEntity.ok(triggers);
        } catch (Exception e) {
            log.error("Error fetching report triggers: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Get a specific report trigger by ID
     */
    @GetMapping("/api/triggers/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<ReportTrigger> getTriggerById(@PathVariable Long id) {
        try {
            Optional<ReportTrigger> trigger = reportTriggerService.getReportTriggerById(id);
            if (trigger.isPresent()) {
                return ResponseEntity.ok(trigger.get());
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            log.error("Error fetching report trigger {}: {}", id, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Create a new report trigger
     */
    @PostMapping("/api/triggers")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createTrigger(@RequestBody ReportTrigger reportTrigger) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get current user for audit
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            Optional<User> currentUser = userService.findByUsername(currentUsername);
            
            if (currentUser.isEmpty()) {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            // Validate cron expression
            if (!reportTriggerService.isValidCronExpression(reportTrigger.getCronExpression())) {
                response.put("success", false);
                response.put("message", "Invalid cron expression: " + reportTrigger.getCronExpression());
                return ResponseEntity.badRequest().body(response);
            }

            // Validate recipients
            if (!reportTriggerService.areValidEmailRecipients(reportTrigger.getRecipients())) {
                response.put("success", false);
                response.put("message", "Invalid email recipients");
                return ResponseEntity.badRequest().body(response);
            }

            // Set audit fields
            reportTrigger.setCreatedBy(currentUser.get());
            reportTrigger.setUpdatedBy(currentUser.get());
            reportTrigger.setCreatedAt(LocalDateTime.now());
            reportTrigger.setUpdatedAt(LocalDateTime.now());

            // Create the trigger
            ReportTrigger savedTrigger = reportTriggerService.createReportTrigger(reportTrigger, currentUser.get());
            
            response.put("success", true);
            response.put("message", "Report trigger created successfully");
            response.put("trigger", savedTrigger);
            
            log.info("Admin {} created new report trigger: {}", currentUsername, savedTrigger.getReportDisplayName());
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error creating report trigger: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Error creating trigger: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Update an existing report trigger
     */
    @PutMapping("/api/triggers/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateTrigger(@PathVariable Long id, @RequestBody ReportTrigger reportTrigger) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get current user for audit
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            Optional<User> currentUser = userService.findByUsername(currentUsername);
            
            if (currentUser.isEmpty()) {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            // Validate cron expression
            if (!reportTriggerService.isValidCronExpression(reportTrigger.getCronExpression())) {
                response.put("success", false);
                response.put("message", "Invalid cron expression: " + reportTrigger.getCronExpression());
                return ResponseEntity.badRequest().body(response);
            }

            // Validate recipients
            if (!reportTriggerService.areValidEmailRecipients(reportTrigger.getRecipients())) {
                response.put("success", false);
                response.put("message", "Invalid email recipients");
                return ResponseEntity.badRequest().body(response);
            }

            // Set audit fields
            reportTrigger.setId(id);
            reportTrigger.setUpdatedBy(currentUser.get());
            reportTrigger.setUpdatedAt(LocalDateTime.now());

            // Update the trigger
            ReportTrigger updatedTrigger = reportTriggerService.updateReportTrigger(id, reportTrigger, currentUser.get());
            
            response.put("success", true);
            response.put("message", "Report trigger updated successfully");
            response.put("trigger", updatedTrigger);
            
            log.info("Admin {} updated report trigger {}: {}", currentUsername, id, updatedTrigger.getReportDisplayName());
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error updating report trigger {}: {}", id, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Error updating trigger: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Delete a report trigger
     */
    @DeleteMapping("/api/triggers/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteTrigger(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            
            reportTriggerService.deleteReportTrigger(id);
            
            response.put("success", true);
            response.put("message", "Report trigger deleted successfully");
            
            log.info("Admin {} deleted report trigger {}", currentUsername, id);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error deleting report trigger {}: {}", id, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Error deleting trigger: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Toggle enable/disable status of a report trigger
     */
    @PostMapping("/api/triggers/{id}/toggle")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleTrigger(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            Optional<User> currentUser = userService.findByUsername(currentUsername);
            
            if (currentUser.isEmpty()) {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            Optional<ReportTrigger> triggerOpt = reportTriggerService.getReportTriggerById(id);
            if (triggerOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Report trigger not found");
                return ResponseEntity.notFound().build();
            }

            ReportTrigger trigger = triggerOpt.get();
            trigger.setEnabled(!trigger.isActive());
            trigger.setUpdatedBy(currentUser.get());
            trigger.setUpdatedAt(LocalDateTime.now());
            
            ReportTrigger updatedTrigger = reportTriggerService.updateReportTrigger(id, trigger, currentUser.get());
            
            response.put("success", true);
            response.put("message", "Report trigger " + (updatedTrigger.isActive() ? "enabled" : "disabled") + " successfully");
            response.put("trigger", updatedTrigger);
            
            log.info("Admin {} {} report trigger {}: {}", currentUsername, 
                    updatedTrigger.isActive() ? "enabled" : "disabled", id, updatedTrigger.getReportDisplayName());
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error toggling report trigger {}: {}", id, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Error toggling trigger: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Validate cron expression
     */
    @PostMapping("/api/validate-cron")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> validateCronExpression(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String cronExpression = request.get("cronExpression");
            boolean isValid = reportTriggerService.isValidCronExpression(cronExpression);
            
            response.put("valid", isValid);
            
            if (isValid) {
                // Calculate next execution time
                LocalDateTime nextExecution = reportTriggerService.calculateNextExecution(cronExpression);
                response.put("nextExecution", nextExecution);
                response.put("message", "Valid cron expression");
            } else {
                response.put("message", "Invalid cron expression");
            }
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error validating cron expression: {}", e.getMessage(), e);
            response.put("valid", false);
            response.put("message", "Error validating cron expression: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * Get execution statistics
     */
    @GetMapping("/api/stats")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<ReportTriggerService.ReportExecutionStats> getExecutionStats() {
        try {
            ReportTriggerService.ReportExecutionStats stats = reportTriggerService.getExecutionStats();
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            log.error("Error fetching execution statistics: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Manually trigger a report
     */
    @PostMapping("/api/triggers/{id}/execute")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> manuallyExecuteTrigger(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            log.info("Manual trigger requested by admin {} for report trigger ID: {}", currentUsername, id);
            
            Optional<ReportTrigger> triggerOpt = reportTriggerService.getReportTriggerById(id);
            if (triggerOpt.isEmpty()) {
                log.warn("Report trigger not found with ID: {}", id);
                response.put("success", false);
                response.put("message", "Report trigger not found");
                return ResponseEntity.notFound().build();
            }

            ReportTrigger trigger = triggerOpt.get();
            log.info("Found report trigger: {} (Bean: {}, Recipients: {})", 
                    trigger.getReportDisplayName(), trigger.getReportGeneratorBean(), trigger.getRecipients());
            
            if (!trigger.isActive()) {
                log.warn("Report trigger '{}' is disabled. Cannot execute.", trigger.getReportDisplayName());
                response.put("success", false);
                response.put("message", "Report trigger is disabled");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Update execution status to running
            log.info("Setting report trigger {} status to RUNNING", trigger.getReportDisplayName());
            reportTriggerService.updateExecutionStatus(id, 
                ReportTrigger.ExecutionStatus.RUNNING, 
                LocalDateTime.now(), 
                reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                null);

            // Generate the report based on trigger bean
            log.info("Generating report content for bean: {}", trigger.getReportGeneratorBean());
            String reportContent = generateReportByType(trigger.getReportGeneratorBean());
            log.info("Report content generated successfully. Content length: {} characters", reportContent.length());
            
            // Get total registrations for subject line
            long totalRegistrations = dailyReportService.getTotalRegistrationsYesterday();
            log.info("Total registrations yesterday: {}", totalRegistrations);

            // Prepare email details
            String subject = String.format("%s - %d New Registrations", 
                                          trigger.getReportDisplayName(), totalRegistrations);
            log.info("Email subject prepared: {}", subject);
            
            // Split recipients by comma if multiple
            String[] recipients = trigger.getRecipients().split(",");
            log.info("Sending report to {} recipients: {}", recipients.length, trigger.getRecipients());
            
            // Send email to each recipient
            int successCount = 0;
            int failureCount = 0;
            StringBuilder errorMessages = new StringBuilder();
            
            for (String recipient : recipients) {
                String trimmedRecipient = recipient.trim();
                if (!trimmedRecipient.isEmpty()) {
                    try {
                        log.info("Attempting to send email to: {}", trimmedRecipient);
                        emailService.sendDailyReport(trimmedRecipient, subject, reportContent);
                        log.info("Successfully sent report '{}' to: {}", trigger.getReportDisplayName(), trimmedRecipient);
                        successCount++;
                    } catch (Exception emailError) {
                        log.error("Failed to send email to {}: {}", trimmedRecipient, emailError.getMessage(), emailError);
                        failureCount++;
                        if (errorMessages.length() > 0) {
                            errorMessages.append("; ");
                        }
                        errorMessages.append("Failed to send to ").append(trimmedRecipient).append(": ").append(emailError.getMessage());
                    }
                } else {
                    log.warn("Skipping empty recipient");
                }
            }

            // Update execution status based on results
            if (failureCount == 0) {
                log.info("All emails sent successfully. Setting status to SUCCESS");
                reportTriggerService.updateExecutionStatus(id, 
                    ReportTrigger.ExecutionStatus.SUCCESS, 
                    LocalDateTime.now(), 
                    reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                    null);
                
                response.put("success", true);
                response.put("message", String.format("Report triggered successfully. Sent to %d recipients.", successCount));
            } else if (successCount > 0) {
                log.warn("Partial success: {} sent, {} failed", successCount, failureCount);
                reportTriggerService.updateExecutionStatus(id, 
                    ReportTrigger.ExecutionStatus.FAILED, 
                    LocalDateTime.now(), 
                    reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                    String.format("Partial failure: %d sent, %d failed. Errors: %s", successCount, failureCount, errorMessages.toString()));
                
                response.put("success", false);
                response.put("message", String.format("Partial success: %d sent, %d failed. Check logs for details.", successCount, failureCount));
            } else {
                log.error("All email sends failed");
                reportTriggerService.updateExecutionStatus(id, 
                    ReportTrigger.ExecutionStatus.FAILED, 
                    LocalDateTime.now(), 
                    reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                    "All email sends failed: " + errorMessages.toString());
                
                response.put("success", false);
                response.put("message", "All email sends failed. Check logs for details.");
            }
            
            log.info("Manual trigger completed for report '{}'. Success: {}, Failure: {}", 
                    trigger.getReportDisplayName(), successCount, failureCount);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error manually executing report trigger {}: {}", id, e.getMessage(), e);
            
            // Try to update status to failed if possible
            try {
                reportTriggerService.updateExecutionStatus(id, 
                    ReportTrigger.ExecutionStatus.FAILED, 
                    LocalDateTime.now(), 
                    null, 
                    "Manual execution failed: " + e.getMessage());
            } catch (Exception statusUpdateError) {
                log.error("Failed to update execution status after error: {}", statusUpdateError.getMessage());
            }
            
            response.put("success", false);
            response.put("message", "Error executing trigger: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Generate report content based on report type
     */
    private String generateReportByType(String reportType) {
        log.info("Generating report for type: {}", reportType);
        
        try {
            switch (reportType.toUpperCase()) {
                case "DAILY_PATIENT_REGISTRATION":
                    log.info("Generating daily patient registration report");
                    return dailyReportService.generateDailyPatientRegistrationReport();
                    
                case "WEEKLY_SUMMARY":
                    log.info("Generating weekly summary report");
                    // Add weekly report generation logic here
                    return "Weekly Summary Report - Feature coming soon";
                    
                case "MONTHLY_ANALYTICS":
                    log.info("Generating monthly analytics report");
                    // Add monthly analytics report generation logic here
                    return "Monthly Analytics Report - Feature coming soon";
                    
                default:
                    log.warn("Unknown report type: {}. Defaulting to daily patient registration", reportType);
                    return dailyReportService.generateDailyPatientRegistrationReport();
            }
        } catch (Exception e) {
            log.error("Error generating report for type {}: {}", reportType, e.getMessage(), e);
            throw new RuntimeException("Failed to generate report: " + e.getMessage(), e);
        }
    }
    
    /**
     * Get available report generators for the UI dropdown
     */
    @GetMapping("/api/generators")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<List<String>> getAvailableReportGenerators() {
        try {
            List<String> generators = reportExecutionService.getAllReportGeneratorBeanNames();
            return ResponseEntity.ok(generators);
        } catch (Exception e) {
            log.error("Error fetching available report generators: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
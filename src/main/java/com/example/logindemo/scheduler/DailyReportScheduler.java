package com.example.logindemo.scheduler;

import com.example.logindemo.model.ReportTrigger;
import com.example.logindemo.service.DailyReportService;
import com.example.logindemo.service.EmailService;
import com.example.logindemo.service.ReportTriggerService;
import com.example.logindemo.service.report.ReportExecutionService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;

@Component
@Slf4j
public class DailyReportScheduler {

    @Autowired
    private DailyReportService dailyReportService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private ReportTriggerService reportTriggerService;

    @Autowired
    private ReportExecutionService reportExecutionService;

    @Autowired
    private TaskScheduler taskScheduler;
    
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${daily.report.recipients:admin@peridesk.com}")
    private String defaultReportRecipients;

    @Value("${daily.report.enabled:true}")
    private boolean defaultReportEnabled;

    // Map to store scheduled tasks
    private final Map<Long, ScheduledFuture<?>> scheduledTasks = new ConcurrentHashMap<>();

    @PostConstruct
    public void initializeScheduledTasks() {
        log.info("Initializing dynamic report scheduling...");
        scheduleAllActiveTriggers();
    }

    @PreDestroy
    public void shutdownScheduledTasks() {
        log.info("Shutting down all scheduled tasks...");
        scheduledTasks.values().forEach(task -> task.cancel(false));
        scheduledTasks.clear();
    }

    /**
     * Schedule all active report triggers from the database
     */
    public void scheduleAllActiveTriggers() {
        try {
            List<ReportTrigger> activeTriggers = reportTriggerService.getEnabledReportTriggers();
            
            for (ReportTrigger trigger : activeTriggers) {
                scheduleReportTrigger(trigger);
            }
            
            log.info("Scheduled {} active report triggers", activeTriggers.size());
        } catch (Exception e) {
            log.error("Failed to initialize scheduled tasks", e);
        }
    }

    /**
     * Schedule a specific report trigger
     */
    public void scheduleReportTrigger(ReportTrigger trigger) {
        try {
            // Cancel existing task if any
            cancelScheduledTask(trigger.getId());
            
            // Normalize cron expression to handle both 5-field and 6-field formats
            String normalizedCron = normalizeCronExpression(trigger.getCronExpression());
            
            // Create new scheduled task
            ScheduledFuture<?> scheduledTask = taskScheduler.schedule(
                () -> executeReportTrigger(trigger),
                new CronTrigger(normalizedCron)
            );
            
            scheduledTasks.put(trigger.getId(), scheduledTask);
            log.info("Scheduled report trigger '{}' with cron expression: {} (normalized: {})", 
                    trigger.getReportDisplayName(), trigger.getCronExpression(), normalizedCron);
        } catch (Exception e) {
            log.error("Failed to schedule report trigger: {}", trigger.getReportDisplayName(), e);
        }
    }
    
    /**
     * Normalize cron expression to 6-field format (seconds minutes hours day-of-month month day-of-week)
     * If 5 fields are provided, prepend '0' for seconds
     */
    private String normalizeCronExpression(String cronExpression) {
        if (cronExpression == null || cronExpression.trim().isEmpty()) {
            return cronExpression;
        }
        
        String[] fields = cronExpression.trim().split("\\s+");
        
        if (fields.length == 5) {
            // Convert 5-field to 6-field by prepending '0' for seconds
            return "0 " + cronExpression.trim();
        } else if (fields.length == 6) {
            // Already in correct format
            return cronExpression.trim();
        } else {
            // Invalid number of fields, return as-is to let CronTrigger handle the error
            return cronExpression.trim();
        }
    }

    /**
     * Cancel a scheduled task
     */
    public void cancelScheduledTask(Long triggerId) {
        ScheduledFuture<?> existingTask = scheduledTasks.remove(triggerId);
        if (existingTask != null) {
            existingTask.cancel(false);
            log.info("Cancelled scheduled task for trigger ID: {}", triggerId);
        }
    }

    /**
     * Execute a report trigger
     */
    private void executeReportTrigger(ReportTrigger trigger) {
        if (!trigger.isActive()) {
            log.info("Report trigger '{}' is disabled. Skipping execution.", trigger.getReportDisplayName());
            return;
        }

        try {
            log.info("Executing report trigger '{}' at {}", 
                    trigger.getReportDisplayName(), 
                    LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));

            // Update execution status to running
            reportTriggerService.updateExecutionStatus(trigger.getId(), 
                ReportTrigger.ExecutionStatus.RUNNING, 
                LocalDateTime.now(), 
                reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                null);

            // Generate the report using the new bean-based approach
            Map<String, Object> parameters = parseReportParameters(trigger.getReportParameters());
            String reportContent = reportExecutionService.executeReport(trigger.getReportGeneratorBean(), parameters);
            
            // Get total registrations for subject line
            long totalRegistrations = dailyReportService.getTotalRegistrationsYesterday();

            // Prepare email details
            String subject = String.format("%s - %d New Registrations", 
                                          trigger.getReportDisplayName(), totalRegistrations);
            
            // Split recipients by comma if multiple
            String[] recipients = trigger.getRecipients().split(",");
            
            // Send email to each recipient
            for (String recipient : recipients) {
                String trimmedRecipient = recipient.trim();
                if (!trimmedRecipient.isEmpty()) {
                    emailService.sendDailyReport(trimmedRecipient, subject, reportContent);
                    log.info("Report '{}' sent to: {}", trigger.getReportDisplayName(), trimmedRecipient);
                }
            }

            // Update execution status to success
            reportTriggerService.updateExecutionStatus(trigger.getId(), 
                ReportTrigger.ExecutionStatus.SUCCESS, 
                LocalDateTime.now(), 
                reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                null);

            log.info("Report trigger '{}' executed successfully for {} recipients", 
                    trigger.getReportDisplayName(), recipients.length);

        } catch (Exception e) {
            log.error("Failed to execute report trigger: {}", trigger.getReportDisplayName(), e);
            
            // Update execution status to failed
            reportTriggerService.updateExecutionStatus(trigger.getId(), 
                ReportTrigger.ExecutionStatus.FAILED, 
                LocalDateTime.now(), 
                reportTriggerService.calculateNextExecution(trigger.getCronExpression()), 
                e.getMessage());
            
            // Send error notification to admin
            sendErrorNotification(trigger, e);
        }
    }

    /**
     * Parse JSON report parameters into a Map
     */
    private Map<String, Object> parseReportParameters(String parametersJson) {
        if (parametersJson == null || parametersJson.trim().isEmpty()) {
            return Map.of(); // Return empty map if no parameters
        }
        
        try {
            return objectMapper.readValue(parametersJson, new TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            log.warn("Failed to parse report parameters JSON: {}. Using empty parameters.", parametersJson, e);
            return Map.of();
        }
    }

    /**
     * Generate report content based on report type
     */
    private String generateReportByType(String reportType) {
        switch (reportType.toLowerCase()) {
            case "daily_patient_registration":
                return dailyReportService.generateDailyPatientRegistrationReport();
            case "weekly_summary":
                // TODO: Implement weekly summary report
                return "Weekly summary report - Implementation pending";
            case "monthly_analytics":
                // TODO: Implement monthly analytics report
                return "Monthly analytics report - Implementation pending";
            default:
                return dailyReportService.generateDailyPatientRegistrationReport();
        }
    }

    /**
     * Send error notification to admin
     */
    private void sendErrorNotification(ReportTrigger trigger, Exception e) {
        try {
            String errorSubject = String.format("ERROR: Report Trigger '%s' Failed", trigger.getReportDisplayName());
            String errorMessage = String.format(
                "Report trigger '%s' failed to execute at %s.\n\nError: %s\n\nTrigger Details:\n- Cron Expression: %s\n- Recipients: %s", 
                trigger.getReportDisplayName(),
                LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME),
                e.getMessage(),
                trigger.getCronExpression(),
                trigger.getRecipients()
            );
            
            emailService.sendDailyReport("admin@peridesk.com", errorSubject, errorMessage);
        } catch (Exception emailError) {
            log.error("Failed to send error notification email", emailError);
        }
    }

    /**
     * Legacy method for backward compatibility - now uses default trigger
     * This method can be called via a controller endpoint for testing
     */
    public void triggerManualReport() {
        log.info("Manual report trigger initiated (legacy method)");
        
        if (!defaultReportEnabled) {
            log.info("Default daily report is disabled. Skipping report generation.");
            return;
        }

        try {
            // Generate the report
            String reportContent = dailyReportService.generateDailyPatientRegistrationReport();
            
            // Get total registrations for subject line
            long totalRegistrations = dailyReportService.getTotalRegistrationsYesterday();

            // Prepare email details
            String subject = String.format("Manual Daily Patient Registration Report - %d New Registrations", 
                                          totalRegistrations);
            
            // Split recipients by comma if multiple
            String[] recipients = defaultReportRecipients.split(",");
            
            // Send email to each recipient
            for (String recipient : recipients) {
                String trimmedRecipient = recipient.trim();
                if (!trimmedRecipient.isEmpty()) {
                    emailService.sendDailyReport(trimmedRecipient, subject, reportContent);
                    log.info("Manual daily report sent to: {}", trimmedRecipient);
                }
            }

            log.info("Manual daily patient registration report sent successfully to {} recipients", 
                    recipients.length);

        } catch (Exception e) {
            log.error("Failed to send manual daily patient registration report", e);
        }
    }

    /**
     * Refresh all scheduled tasks (useful when triggers are updated)
     */
    public void refreshScheduledTasks() {
        log.info("Refreshing all scheduled tasks...");
        shutdownScheduledTasks();
        scheduleAllActiveTriggers();
    }
}
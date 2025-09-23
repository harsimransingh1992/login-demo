package com.example.logindemo.service;

import com.example.logindemo.model.ReportTrigger;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.ReportTriggerRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.support.CronExpression;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

@Slf4j
@Service
@Transactional
public class ReportTriggerServiceImpl implements ReportTriggerService {
    
    private final ReportTriggerRepository reportTriggerRepository;
    
    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );
    
    @Autowired
    public ReportTriggerServiceImpl(ReportTriggerRepository reportTriggerRepository) {
        this.reportTriggerRepository = reportTriggerRepository;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReportTrigger> getAllReportTriggers() {
        return reportTriggerRepository.findAll();
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReportTrigger> getEnabledReportTriggers() {
        return reportTriggerRepository.findByEnabledTrueOrderByReportNameAsc();
    }
    
    @Override
    @Transactional(readOnly = true)
    public Optional<ReportTrigger> getReportTriggerById(Long id) {
        return reportTriggerRepository.findById(id);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Optional<ReportTrigger> getReportTriggerByName(String reportName) {
        return reportTriggerRepository.findByReportName(reportName);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReportTrigger> getReportTriggersByGeneratorBean(String reportGeneratorBean) {
        return reportTriggerRepository.findByReportGeneratorBeanOrderByReportNameAsc(reportGeneratorBean);
    }
    
    @Override
    public ReportTrigger createReportTrigger(ReportTrigger reportTrigger, User createdBy) {
        log.info("Creating new report trigger: {}", reportTrigger.getReportName());
        
        // Validate the report trigger
        validateReportTrigger(reportTrigger, null);
        
        // Set audit fields
        reportTrigger.setCreatedBy(createdBy);
        reportTrigger.setUpdatedBy(createdBy);
        
        // Calculate next execution time
        if (reportTrigger.isActive() && isValidCronExpression(reportTrigger.getCronExpression())) {
            reportTrigger.setNextExecution(calculateNextExecution(reportTrigger.getCronExpression()));
        }
        
        ReportTrigger saved = reportTriggerRepository.save(reportTrigger);
        log.info("Successfully created report trigger with ID: {}", saved.getId());
        return saved;
    }
    
    @Override
    public ReportTrigger updateReportTrigger(Long id, ReportTrigger reportTrigger, User updatedBy) {
        log.info("Updating report trigger with ID: {}", id);
        
        ReportTrigger existing = reportTriggerRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Report trigger not found with ID: " + id));
        
        // Validate the updated report trigger
        validateReportTrigger(reportTrigger, id);
        
        // Update fields
        existing.setReportName(reportTrigger.getReportName());
        existing.setReportDisplayName(reportTrigger.getReportDisplayName());
        existing.setReportGeneratorBean(reportTrigger.getReportGeneratorBean());
        existing.setCronExpression(reportTrigger.getCronExpression());
        existing.setRecipients(reportTrigger.getRecipients());
        existing.setEnabled(reportTrigger.getEnabled());
        existing.setDescription(reportTrigger.getDescription());
        existing.setSubject(reportTrigger.getSubject());
        existing.setEmailTemplate(reportTrigger.getEmailTemplate());
        existing.setUpdatedBy(updatedBy);
        
        // Recalculate next execution time if cron expression changed
        if (existing.isActive() && isValidCronExpression(existing.getCronExpression())) {
            existing.setNextExecution(calculateNextExecution(existing.getCronExpression()));
        } else if (!existing.isActive()) {
            existing.setNextExecution(null);
        }
        
        ReportTrigger updated = reportTriggerRepository.save(existing);
        log.info("Successfully updated report trigger with ID: {}", updated.getId());
        return updated;
    }
    
    @Override
    public void deleteReportTrigger(Long id) {
        log.info("Deleting report trigger with ID: {}", id);
        
        if (!reportTriggerRepository.existsById(id)) {
            throw new RuntimeException("Report trigger not found with ID: " + id);
        }
        
        reportTriggerRepository.deleteById(id);
        log.info("Successfully deleted report trigger with ID: {}", id);
    }
    
    @Override
    public ReportTrigger toggleReportTrigger(Long id, boolean enabled, User updatedBy) {
        log.info("Toggling report trigger {} to enabled: {}", id, enabled);
        
        ReportTrigger reportTrigger = reportTriggerRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Report trigger not found with ID: " + id));
        
        reportTrigger.setEnabled(enabled);
        reportTrigger.setUpdatedBy(updatedBy);
        
        // Update next execution time based on enabled status
        if (enabled && isValidCronExpression(reportTrigger.getCronExpression())) {
            reportTrigger.setNextExecution(calculateNextExecution(reportTrigger.getCronExpression()));
        } else if (!enabled) {
            reportTrigger.setNextExecution(null);
        }
        
        return reportTriggerRepository.save(reportTrigger);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReportTrigger> getTriggersReadyForExecution() {
        return reportTriggerRepository.findTriggersReadyForExecution(LocalDateTime.now());
    }
    
    @Override
    public void updateExecutionStatus(Long id, ReportTrigger.ExecutionStatus status, 
                                    LocalDateTime lastExecuted, LocalDateTime nextExecution, String error) {
        log.info("Updating execution status for report trigger {}: {}", id, status);
        
        ReportTrigger reportTrigger = reportTriggerRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Report trigger not found with ID: " + id));
        
        reportTrigger.setLastExecutionStatus(status);
        reportTrigger.setLastExecuted(lastExecuted);
        reportTrigger.setNextExecution(nextExecution);
        reportTrigger.setLastExecutionError(error);
        
        reportTriggerRepository.save(reportTrigger);
    }
    
    @Override
    public boolean isValidCronExpression(String cronExpression) {
        if (cronExpression == null || cronExpression.trim().isEmpty()) {
            return false;
        }
        
        try {
            String normalizedCron = normalizeCronExpression(cronExpression.trim());
            CronExpression.parse(normalizedCron);
            return true;
        } catch (Exception e) {
            log.warn("Invalid cron expression: {}", cronExpression, e);
            return false;
        }
    }
    
    /**
     * Normalize cron expression to 6-field format (seconds minutes hours day-of-month month day-of-week)
     * If 5 fields are provided, prepend '0' for seconds
     */
    private String normalizeCronExpression(String cronExpression) {
        String[] fields = cronExpression.split("\\s+");
        
        if (fields.length == 5) {
            // Convert 5-field to 6-field by prepending '0' for seconds
            return "0 " + cronExpression;
        } else if (fields.length == 6) {
            // Already in correct format
            return cronExpression;
        } else {
            // Invalid number of fields, return as-is to let CronExpression.parse() handle the error
            return cronExpression;
        }
    }
    
    @Override
    public LocalDateTime calculateNextExecution(String cronExpression) {
        if (!isValidCronExpression(cronExpression)) {
            return null;
        }
        
        try {
            String normalizedCron = normalizeCronExpression(cronExpression.trim());
            CronExpression cron = CronExpression.parse(normalizedCron);
            // Use IST timezone for consistent calculation
            return cron.next(LocalDateTime.now(java.time.ZoneId.of("Asia/Kolkata")));
        } catch (Exception e) {
            log.error("Error calculating next execution for cron: {}", cronExpression, e);
            return null;
        }
    }
    
    @Override
    public boolean areValidEmailRecipients(String recipients) {
        if (recipients == null || recipients.trim().isEmpty()) {
            return false;
        }
        
        String[] emails = recipients.split(",");
        for (String email : emails) {
            String trimmedEmail = email.trim();
            if (trimmedEmail.isEmpty() || !EMAIL_PATTERN.matcher(trimmedEmail).matches()) {
                return false;
            }
        }
        return true;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReportTrigger> getFailedReportTriggers() {
        return reportTriggerRepository.findByLastExecutionStatusAndEnabledTrueOrderByLastExecutedDesc(
            ReportTrigger.ExecutionStatus.FAILED);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReportTrigger> getStaleReportTriggers(int hoursThreshold) {
        LocalDateTime cutoffTime = LocalDateTime.now().minusHours(hoursThreshold);
        return reportTriggerRepository.findStaleReportTriggers(cutoffTime);
    }
    
    @Override
    @Transactional(readOnly = true)
    public boolean reportNameExists(String reportName) {
        return reportTriggerRepository.existsByReportNameIgnoreCase(reportName);
    }
    
    @Override
    @Transactional(readOnly = true)
    public boolean reportNameExistsExcluding(String reportName, Long excludeId) {
        return reportTriggerRepository.existsByReportNameIgnoreCaseAndIdNot(reportName, excludeId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public ReportExecutionStats getExecutionStats() {
        long totalTriggers = reportTriggerRepository.count();
        long enabledTriggers = reportTriggerRepository.countByEnabledTrue();
        
        List<ReportTrigger> allTriggers = reportTriggerRepository.findAll();
        long successfulExecutions = allTriggers.stream()
            .mapToLong(rt -> rt.getLastExecutionStatus() == ReportTrigger.ExecutionStatus.SUCCESS ? 1 : 0)
            .sum();
        long failedExecutions = allTriggers.stream()
            .mapToLong(rt -> rt.getLastExecutionStatus() == ReportTrigger.ExecutionStatus.FAILED ? 1 : 0)
            .sum();
        long pendingExecutions = allTriggers.stream()
            .mapToLong(rt -> rt.getLastExecutionStatus() == ReportTrigger.ExecutionStatus.PENDING || 
                           rt.getLastExecutionStatus() == null ? 1 : 0)
            .sum();
        
        return new ReportExecutionStats(totalTriggers, enabledTriggers, 
                                      successfulExecutions, failedExecutions, pendingExecutions);
    }
    
    private void validateReportTrigger(ReportTrigger reportTrigger, Long excludeId) {
        // Validate required fields
        if (reportTrigger.getReportName() == null || reportTrigger.getReportName().trim().isEmpty()) {
            throw new IllegalArgumentException("Report name is required");
        }
        
        if (reportTrigger.getReportDisplayName() == null || reportTrigger.getReportDisplayName().trim().isEmpty()) {
            throw new IllegalArgumentException("Report display name is required");
        }
        
        if (reportTrigger.getReportGeneratorBean() == null || reportTrigger.getReportGeneratorBean().trim().isEmpty()) {
            throw new IllegalArgumentException("Report generator bean is required");
        }
        
        if (reportTrigger.getCronExpression() == null || reportTrigger.getCronExpression().trim().isEmpty()) {
            throw new IllegalArgumentException("Cron expression is required");
        }
        
        if (reportTrigger.getRecipients() == null || reportTrigger.getRecipients().trim().isEmpty()) {
            throw new IllegalArgumentException("Recipients are required");
        }
        
        // Validate cron expression
        if (!isValidCronExpression(reportTrigger.getCronExpression())) {
            throw new IllegalArgumentException("Invalid cron expression: " + reportTrigger.getCronExpression());
        }
        
        // Validate email recipients
        if (!areValidEmailRecipients(reportTrigger.getRecipients())) {
            throw new IllegalArgumentException("Invalid email recipients: " + reportTrigger.getRecipients());
        }
        
        // Check for duplicate report names
        if (excludeId == null) {
            if (reportNameExists(reportTrigger.getReportName())) {
                throw new IllegalArgumentException("Report name already exists: " + reportTrigger.getReportName());
            }
        } else {
            if (reportNameExistsExcluding(reportTrigger.getReportName(), excludeId)) {
                throw new IllegalArgumentException("Report name already exists: " + reportTrigger.getReportName());
            }
        }
    }
}
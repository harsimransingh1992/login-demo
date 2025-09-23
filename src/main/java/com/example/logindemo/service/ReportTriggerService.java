package com.example.logindemo.service;

import com.example.logindemo.model.ReportTrigger;
import com.example.logindemo.model.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ReportTriggerService {
    
    /**
     * Get all report triggers
     */
    List<ReportTrigger> getAllReportTriggers();
    
    /**
     * Get all enabled report triggers
     */
    List<ReportTrigger> getEnabledReportTriggers();
    
    /**
     * Get report trigger by ID
     */
    Optional<ReportTrigger> getReportTriggerById(Long id);
    
    /**
     * Get report trigger by name
     */
    Optional<ReportTrigger> getReportTriggerByName(String reportName);
    
    /**
     * Get report triggers by generator bean name
     */
    List<ReportTrigger> getReportTriggersByGeneratorBean(String reportGeneratorBean);
    
    /**
     * Create a new report trigger
     */
    ReportTrigger createReportTrigger(ReportTrigger reportTrigger, User createdBy);
    
    /**
     * Update an existing report trigger
     */
    ReportTrigger updateReportTrigger(Long id, ReportTrigger reportTrigger, User updatedBy);
    
    /**
     * Delete a report trigger
     */
    void deleteReportTrigger(Long id);
    
    /**
     * Enable/disable a report trigger
     */
    ReportTrigger toggleReportTrigger(Long id, boolean enabled, User updatedBy);
    
    /**
     * Get report triggers that are ready for execution
     */
    List<ReportTrigger> getTriggersReadyForExecution();
    
    /**
     * Update execution status and next execution time
     */
    void updateExecutionStatus(Long id, ReportTrigger.ExecutionStatus status, 
                              LocalDateTime lastExecuted, LocalDateTime nextExecution, String error);
    
    /**
     * Validate cron expression
     */
    boolean isValidCronExpression(String cronExpression);
    
    /**
     * Calculate next execution time based on cron expression
     */
    LocalDateTime calculateNextExecution(String cronExpression);
    
    /**
     * Validate email recipients
     */
    boolean areValidEmailRecipients(String recipients);
    
    /**
     * Get report triggers with failed executions
     */
    List<ReportTrigger> getFailedReportTriggers();
    
    /**
     * Get stale report triggers (haven't executed in specified hours)
     */
    List<ReportTrigger> getStaleReportTriggers(int hoursThreshold);
    
    /**
     * Check if report name already exists
     */
    boolean reportNameExists(String reportName);
    
    /**
     * Check if report name exists excluding a specific ID (for updates)
     */
    boolean reportNameExistsExcluding(String reportName, Long excludeId);
    
    /**
     * Get execution statistics
     */
    ReportExecutionStats getExecutionStats();
    
    /**
     * Inner class for execution statistics
     */
    class ReportExecutionStats {
        private long totalTriggers;
        private long enabledTriggers;
        private long successfulExecutions;
        private long failedExecutions;
        private long pendingExecutions;
        
        // Constructors, getters, and setters
        public ReportExecutionStats() {}
        
        public ReportExecutionStats(long totalTriggers, long enabledTriggers, 
                                  long successfulExecutions, long failedExecutions, long pendingExecutions) {
            this.totalTriggers = totalTriggers;
            this.enabledTriggers = enabledTriggers;
            this.successfulExecutions = successfulExecutions;
            this.failedExecutions = failedExecutions;
            this.pendingExecutions = pendingExecutions;
        }
        
        // Getters and setters
        public long getTotalTriggers() { return totalTriggers; }
        public void setTotalTriggers(long totalTriggers) { this.totalTriggers = totalTriggers; }
        
        public long getEnabledTriggers() { return enabledTriggers; }
        public void setEnabledTriggers(long enabledTriggers) { this.enabledTriggers = enabledTriggers; }
        
        public long getSuccessfulExecutions() { return successfulExecutions; }
        public void setSuccessfulExecutions(long successfulExecutions) { this.successfulExecutions = successfulExecutions; }
        
        public long getFailedExecutions() { return failedExecutions; }
        public void setFailedExecutions(long failedExecutions) { this.failedExecutions = failedExecutions; }
        
        public long getPendingExecutions() { return pendingExecutions; }
        public void setPendingExecutions(long pendingExecutions) { this.pendingExecutions = pendingExecutions; }
    }
}
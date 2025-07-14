package com.example.logindemo.service;

import com.example.logindemo.model.FollowUpRecord;
import com.example.logindemo.model.FollowUpStatus;
import com.example.logindemo.model.ToothClinicalExamination;

import java.time.LocalDateTime;
import java.util.List;

public interface FollowUpService {
    
    /**
     * Create a new follow-up record for an examination
     */
    FollowUpRecord createFollowUp(ToothClinicalExamination examination, LocalDateTime scheduledDate, 
                                 String followUpNotes, Long doctorId);
    
    /**
     * Get all follow-up records for an examination
     */
    List<FollowUpRecord> getFollowUpsForExamination(ToothClinicalExamination examination);
    
    /**
     * Get the latest follow-up record for an examination
     */
    FollowUpRecord getLatestFollowUp(ToothClinicalExamination examination);
    
    /**
     * Mark a follow-up as completed
     */
    FollowUpRecord completeFollowUp(Long followUpId, String clinicalNotes);
    
    /**
     * Mark a follow-up as cancelled
     */
    FollowUpRecord cancelFollowUp(Long followUpId, String reason);
    
    /**
     * Mark a follow-up as no-show
     */
    FollowUpRecord markFollowUpAsNoShow(Long followUpId);
    
    /**
     * Reschedule a follow-up: cancels the previous follow-up and appointment, creates a new follow-up record.
     */
    FollowUpRecord rescheduleFollowUp(Long followUpId, LocalDateTime newScheduledDate, String rescheduleNotes, Long doctorId);
    
    /**
     * Get follow-ups scheduled for today
     */
    List<FollowUpRecord> getTodayScheduledFollowUps();
    
    /**
     * Get overdue follow-ups
     */
    List<FollowUpRecord> getOverdueFollowUps();
    
    /**
     * Get follow-ups for a specific doctor
     */
    List<FollowUpRecord> getFollowUpsForDoctor(Long doctorId);
    
    /**
     * Get follow-up statistics for an examination
     */
    FollowUpStatistics getFollowUpStatistics(ToothClinicalExamination examination);
    
    /**
     * Check if an examination has any pending follow-ups
     */
    boolean hasPendingFollowUps(ToothClinicalExamination examination);
    
    /**
     * Get the next sequence number for an examination
     */
    Integer getNextSequenceNumber(ToothClinicalExamination examination);
    
    /**
     * Update an existing follow-up record
     */
    FollowUpRecord updateFollowUpRecord(FollowUpRecord followUpRecord);
    
    /**
     * Inner class for follow-up statistics
     */
    class FollowUpStatistics {
        private final int totalFollowUps;
        private final int completedFollowUps;
        private final int scheduledFollowUps;
        private final int cancelledFollowUps;
        private final int noShowFollowUps;
        
        public FollowUpStatistics(int totalFollowUps, int completedFollowUps, int scheduledFollowUps, 
                                int cancelledFollowUps, int noShowFollowUps) {
            this.totalFollowUps = totalFollowUps;
            this.completedFollowUps = completedFollowUps;
            this.scheduledFollowUps = scheduledFollowUps;
            this.cancelledFollowUps = cancelledFollowUps;
            this.noShowFollowUps = noShowFollowUps;
        }
        
        // Getters
        public int getTotalFollowUps() { return totalFollowUps; }
        public int getCompletedFollowUps() { return completedFollowUps; }
        public int getScheduledFollowUps() { return scheduledFollowUps; }
        public int getCancelledFollowUps() { return cancelledFollowUps; }
        public int getNoShowFollowUps() { return noShowFollowUps; }
        
        public double getCompletionRate() {
            return totalFollowUps > 0 ? (double) completedFollowUps / totalFollowUps * 100 : 0.0;
        }
    }
} 
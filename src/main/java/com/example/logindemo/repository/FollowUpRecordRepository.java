package com.example.logindemo.repository;

import com.example.logindemo.model.FollowUpRecord;
import com.example.logindemo.model.FollowUpStatus;
import com.example.logindemo.model.ToothClinicalExamination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface FollowUpRecordRepository extends JpaRepository<FollowUpRecord, Long> {
    
    /**
     * Find all follow-up records for a specific examination
     */
    List<FollowUpRecord> findByExaminationOrderBySequenceNumberAsc(ToothClinicalExamination examination);
    
    /**
     * Find the latest follow-up record for an examination
     */
    Optional<FollowUpRecord> findByExaminationAndIsLatestTrue(ToothClinicalExamination examination);
    
    /**
     * Find all scheduled follow-ups for a specific date range
     */
    List<FollowUpRecord> findByScheduledDateBetweenAndStatus(LocalDateTime startDate, LocalDateTime endDate, FollowUpStatus status);
    
    /**
     * Find all follow-ups for a specific doctor
     */
    List<FollowUpRecord> findByAssignedDoctorIdOrderByScheduledDateAsc(Long doctorId);
    
    /**
     * Count total follow-ups for an examination
     */
    long countByExamination(ToothClinicalExamination examination);
    
    /**
     * Count completed follow-ups for an examination
     */
    long countByExaminationAndStatus(ToothClinicalExamination examination, FollowUpStatus status);
    
    /**
     * Find follow-ups scheduled for today
     */
    @Query("SELECT f FROM FollowUpRecord f WHERE DATE(f.scheduledDate) = CURRENT_DATE AND f.status = 'SCHEDULED'")
    List<FollowUpRecord> findTodayScheduledFollowUps();
    
    /**
     * Find overdue follow-ups (scheduled date has passed but not completed)
     */
    @Query("SELECT f FROM FollowUpRecord f WHERE f.scheduledDate < CURRENT_TIMESTAMP AND f.status = 'SCHEDULED'")
    List<FollowUpRecord> findOverdueFollowUps();
    
    /**
     * Find the next sequence number for an examination
     */
    @Query("SELECT COALESCE(MAX(f.sequenceNumber), 0) + 1 FROM FollowUpRecord f WHERE f.examination = :examination")
    Integer getNextSequenceNumber(@Param("examination") ToothClinicalExamination examination);
} 
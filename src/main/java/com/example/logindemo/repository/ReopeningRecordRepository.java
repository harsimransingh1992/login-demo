package com.example.logindemo.repository;

import com.example.logindemo.model.ReopeningRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReopeningRecordRepository extends JpaRepository<ReopeningRecord, Long> {
    
    /**
     * Find all reopening records for a specific examination
     */
    List<ReopeningRecord> findByExamination_IdOrderByReopenedAtDesc(Long examinationId);
    
    /**
     * Find all reopening records by a specific doctor
     */
    List<ReopeningRecord> findByReopenedByDoctor_IdOrderByReopenedAtDesc(Long doctorId);
    
    /**
     * Find all reopening records for a specific clinic
     */
    List<ReopeningRecord> findByClinic_IdOrderByReopenedAtDesc(Long clinicId);
    
    /**
     * Count reopening records for a specific examination
     */
    long countByExamination_Id(Long examinationId);
    
    /**
     * Find reopening records within a date range
     */
    @Query("SELECT r FROM ReopeningRecord r WHERE r.reopenedAt BETWEEN :startDate AND :endDate ORDER BY r.reopenedAt DESC")
    List<ReopeningRecord> findByReopenedAtBetween(@Param("startDate") java.time.LocalDateTime startDate, 
                                                  @Param("endDate") java.time.LocalDateTime endDate);
}
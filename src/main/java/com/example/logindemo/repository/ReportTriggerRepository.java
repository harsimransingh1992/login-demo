package com.example.logindemo.repository;

import com.example.logindemo.model.ReportTrigger;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReportTriggerRepository extends JpaRepository<ReportTrigger, Long> {
    
    /**
     * Find all enabled report triggers
     */
    List<ReportTrigger> findByEnabledTrueOrderByReportNameAsc();
    
    /**
     * Find report trigger by name
     */
    Optional<ReportTrigger> findByReportName(String reportName);
    
    /**
     * Find report triggers by generator bean name
     */
    List<ReportTrigger> findByReportGeneratorBeanOrderByReportNameAsc(String reportGeneratorBean);
    
    /**
     * Find enabled report triggers by generator bean name
     */
    List<ReportTrigger> findByReportGeneratorBeanAndEnabledTrueOrderByReportNameAsc(String reportGeneratorBean);
    
    /**
     * Find report triggers that need to be executed
     * (enabled and next execution time is due)
     */
    @Query("SELECT rt FROM ReportTrigger rt WHERE rt.enabled = true AND " +
           "(rt.nextExecution IS NULL OR rt.nextExecution <= :currentTime)")
    List<ReportTrigger> findTriggersReadyForExecution(@Param("currentTime") LocalDateTime currentTime);
    
    /**
     * Find report triggers created by a specific user
     */
    List<ReportTrigger> findByCreatedByOrderByCreatedAtDesc(com.example.logindemo.model.User createdBy);
    
    /**
     * Find report triggers with specific execution status
     */
    List<ReportTrigger> findByLastExecutionStatusOrderByLastExecutedDesc(ReportTrigger.ExecutionStatus status);
    
    /**
     * Find report triggers that failed in their last execution
     */
    List<ReportTrigger> findByLastExecutionStatusAndEnabledTrueOrderByLastExecutedDesc(
        ReportTrigger.ExecutionStatus status);
    
    /**
     * Count enabled report triggers
     */
    long countByEnabledTrue();
    
    /**
     * Count report triggers by generator bean name
     */
    long countByReportGeneratorBean(String reportGeneratorBean);
    
    /**
     * Find report triggers that haven't been executed in a specific time period
     */
    @Query("SELECT rt FROM ReportTrigger rt WHERE rt.enabled = true AND " +
           "(rt.lastExecuted IS NULL OR rt.lastExecuted < :cutoffTime)")
    List<ReportTrigger> findStaleReportTriggers(@Param("cutoffTime") LocalDateTime cutoffTime);
    
    /**
     * Check if a report name already exists (case-insensitive)
     */
    @Query("SELECT COUNT(rt) > 0 FROM ReportTrigger rt WHERE LOWER(rt.reportName) = LOWER(:reportName)")
    boolean existsByReportNameIgnoreCase(@Param("reportName") String reportName);
    
    /**
     * Check if a report name already exists excluding a specific ID (for updates)
     */
    @Query("SELECT COUNT(rt) > 0 FROM ReportTrigger rt WHERE LOWER(rt.reportName) = LOWER(:reportName) AND rt.id != :excludeId")
    boolean existsByReportNameIgnoreCaseAndIdNot(@Param("reportName") String reportName, @Param("excludeId") Long excludeId);
}
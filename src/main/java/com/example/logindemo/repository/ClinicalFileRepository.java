package com.example.logindemo.repository;

import com.example.logindemo.model.ClinicalFile;
import com.example.logindemo.model.ClinicalFileStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ClinicalFileRepository extends JpaRepository<ClinicalFile, Long> {
    
    /**
     * Find all clinical files for a specific patient.
     */
    List<ClinicalFile> findByPatientIdOrderByCreatedAtDesc(Long patientId);
    
    /**
     * Find all clinical files for a specific clinic.
     */
    List<ClinicalFile> findByClinic_ClinicIdOrderByCreatedAtDesc(String clinicId);
    
    /**
     * Find clinical files by status.
     */
    List<ClinicalFile> findByStatusOrderByCreatedAtDesc(ClinicalFileStatus status);
    
    /**
     * Find clinical files by status and clinic.
     */
    List<ClinicalFile> findByStatusAndClinic_ClinicIdOrderByCreatedAtDesc(ClinicalFileStatus status, String clinicId);
    
    /**
     * Find clinical file by file number.
     */
    Optional<ClinicalFile> findByFileNumber(String fileNumber);
    
    /**
     * Find clinical files created between dates.
     */
    List<ClinicalFile> findByCreatedAtBetweenOrderByCreatedAtDesc(LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Find clinical files created between dates for a specific clinic.
     */
    List<ClinicalFile> findByCreatedAtBetweenAndClinic_ClinicIdOrderByCreatedAtDesc(
        LocalDateTime startDate, LocalDateTime endDate, String clinicId);
    
    /**
     * Count clinical files by status for a specific clinic.
     */
    long countByStatusAndClinic_ClinicId(ClinicalFileStatus status, String clinicId);
    
    /**
     * Find clinical files with pending payments.
     */
    @Query("SELECT cf FROM ClinicalFile cf WHERE cf.clinic.clinicId = :clinicId AND cf.status = 'ACTIVE' " +
           "AND EXISTS (SELECT 1 FROM cf.examinations e WHERE e.totalProcedureAmount > " +
           "(SELECT COALESCE(SUM(pe.amount), 0) FROM PaymentEntry pe WHERE pe.examination = e))")
    List<ClinicalFile> findActiveFilesWithPendingPayments(String clinicId);
    
    /**
     * Find clinical files that can be closed (all examinations are closed).
     */
    @Query("SELECT cf FROM ClinicalFile cf WHERE cf.status = 'ACTIVE' AND cf.clinic.clinicId = :clinicId " +
           "AND NOT EXISTS (SELECT 1 FROM cf.examinations e WHERE e.procedureStatus != 'CLOSED')")
    List<ClinicalFile> findFilesReadyToClose(String clinicId);
}

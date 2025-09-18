package com.example.logindemo.service;

import com.example.logindemo.dto.ClinicalFileDTO;
import com.example.logindemo.model.ClinicalFileStatus;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ClinicalFileService {
    
    /**
     * Get all clinical files for a patient.
     */
    List<ClinicalFileDTO> getClinicalFilesByPatientId(Long patientId);
    
    /**
     * Get all clinical files for a clinic.
     */
    List<ClinicalFileDTO> getClinicalFilesByClinicId(String clinicId);
    
    /**
     * Get clinical file by ID.
     */
    Optional<ClinicalFileDTO> getClinicalFileById(Long id);
    
    /**
     * Get clinical file by file number.
     */
    Optional<ClinicalFileDTO> getClinicalFileByFileNumber(String fileNumber);
    
    /**
     * Create a new clinical file.
     */
    ClinicalFileDTO createClinicalFile(ClinicalFileDTO clinicalFileDTO);
    
    /**
     * Update an existing clinical file.
     */
    ClinicalFileDTO updateClinicalFile(Long id, ClinicalFileDTO clinicalFileDTO);
    
    /**
     * Delete a clinical file.
     */
    void deleteClinicalFile(Long id);
    
    /**
     * Close a clinical file.
     */
    ClinicalFileDTO closeClinicalFile(Long id);
    
    /**
     * Reopen a clinical file.
     */
    ClinicalFileDTO reopenClinicalFile(Long id);
    
    /**
     * Get clinical files by status.
     */
    List<ClinicalFileDTO> getClinicalFilesByStatus(ClinicalFileStatus status);
    
    /**
     * Get clinical files by status and clinic.
     */
    List<ClinicalFileDTO> getClinicalFilesByStatusAndClinic(ClinicalFileStatus status, String clinicId);
    
    /**
     * Get clinical files created between dates.
     */
    List<ClinicalFileDTO> getClinicalFilesByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Get clinical files created between dates for a specific clinic.
     */
    List<ClinicalFileDTO> getClinicalFilesByDateRangeAndClinic(LocalDateTime startDate, LocalDateTime endDate, String clinicId);
    
    /**
     * Get clinical files with pending payments.
     */
    List<ClinicalFileDTO> getActiveFilesWithPendingPayments(String clinicId);
    
    /**
     * Get clinical files ready to close.
     */
    List<ClinicalFileDTO> getFilesReadyToClose(String clinicId);
    
    /**
     * Generate a unique file number.
     */
    String generateFileNumber(String clinicId);
    
    /**
     * Add examination to clinical file.
     */
    ClinicalFileDTO addExaminationToFile(Long fileId, Long examinationId);
    
    /**
     * Remove examination from clinical file.
     */
    ClinicalFileDTO removeExaminationFromFile(Long fileId, Long examinationId);
}

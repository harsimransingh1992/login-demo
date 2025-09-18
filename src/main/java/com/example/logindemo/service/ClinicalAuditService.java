package com.example.logindemo.service;

import com.example.logindemo.dto.ClinicalAuditDTO;
import com.example.logindemo.model.ClinicalAudit;

import java.util.List;

/**
 * Service interface for ClinicalAudit operations
 */
public interface ClinicalAuditService {
    
    /**
     * Create a new audit record
     */
    ClinicalAuditDTO createAudit(ClinicalAuditDTO auditDTO);
    
    /**
     * Get all audits for a clinical file
     */
    List<ClinicalAuditDTO> getAuditsByClinicalFileId(Long clinicalFileId);
    
    /**
     * Get all audits for an examination
     */
    List<ClinicalAuditDTO> getAuditsByExaminationId(Long examinationId);
    
    /**
     * Get the latest audit for a clinical file
     */
    ClinicalAuditDTO getLatestAuditByClinicalFileId(Long clinicalFileId);
    
    /**
     * Update audit status
     */
    ClinicalAuditDTO updateAuditStatus(Long auditId, ClinicalAudit.AuditStatus status);
    
    /**
     * Add audit notes
     */
    ClinicalAuditDTO addAuditNotes(Long auditId, String notes);
    
    /**
     * Add recommendations
     */
    ClinicalAuditDTO addRecommendations(Long auditId, String recommendations);
    
    /**
     * Get audit by ID
     */
    ClinicalAuditDTO getAuditById(Long auditId);
}

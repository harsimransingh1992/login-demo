package com.example.logindemo.service.impl;

import com.example.logindemo.dto.ClinicalAuditDTO;
import com.example.logindemo.model.ClinicalAudit;
import com.example.logindemo.model.ClinicalFile;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.ClinicalAuditRepository;
import com.example.logindemo.repository.ClinicalFileRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.ClinicalAuditService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Service implementation for ClinicalAudit operations
 */
@Service
public class ClinicalAuditServiceImpl implements ClinicalAuditService {
    
    @Autowired
    private ClinicalAuditRepository clinicalAuditRepository;
    
    @Autowired
    private ClinicalFileRepository clinicalFileRepository;
    
    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Override
    public ClinicalAuditDTO createAudit(ClinicalAuditDTO auditDTO) {
        ClinicalAudit audit = new ClinicalAudit();
        
        // Set basic fields
        audit.setAuditType(auditDTO.getAuditType());
        audit.setQualityRating(auditDTO.getQualityRating());
        audit.setAuditStatus(auditDTO.getAuditStatus());
        audit.setAuditNotes(auditDTO.getAuditNotes());
        audit.setRecommendations(auditDTO.getRecommendations());
        
        // Set relationships
        if (auditDTO.getClinicalFileId() != null) {
            ClinicalFile clinicalFile = clinicalFileRepository.findById(auditDTO.getClinicalFileId()).orElse(null);
            audit.setClinicalFile(clinicalFile);
        }
        
        if (auditDTO.getExaminationId() != null) {
            ToothClinicalExamination examination = examinationRepository.findById(auditDTO.getExaminationId()).orElse(null);
            audit.setExamination(examination);
        }
        
        if (auditDTO.getAuditorId() != null) {
            User auditor = userRepository.findById(auditDTO.getAuditorId()).orElse(null);
            audit.setAuditor(auditor);
        }
        
        ClinicalAudit savedAudit = clinicalAuditRepository.save(audit);
        return mapToDTO(savedAudit);
    }
    
    @Override
    public List<ClinicalAuditDTO> getAuditsByClinicalFileId(Long clinicalFileId) {
        List<ClinicalAudit> audits = clinicalAuditRepository.findByClinicalFileIdOrderByAuditDateDesc(clinicalFileId);
        return audits.stream().map(this::mapToDTO).collect(Collectors.toList());
    }
    
    @Override
    public List<ClinicalAuditDTO> getAuditsByExaminationId(Long examinationId) {
        List<ClinicalAudit> audits = clinicalAuditRepository.findByExaminationIdOrderByAuditDateDesc(examinationId);
        return audits.stream().map(this::mapToDTO).collect(Collectors.toList());
    }
    
    @Override
    public ClinicalAuditDTO getLatestAuditByClinicalFileId(Long clinicalFileId) {
        List<ClinicalAudit> audits = clinicalAuditRepository.findLatestAuditByClinicalFileId(clinicalFileId);
        if (audits.isEmpty()) {
            return null;
        }
        return mapToDTO(audits.get(0));
    }
    
    @Override
    public ClinicalAuditDTO updateAuditStatus(Long auditId, ClinicalAudit.AuditStatus status) {
        ClinicalAudit audit = clinicalAuditRepository.findById(auditId).orElse(null);
        if (audit != null) {
            audit.setAuditStatus(status);
            ClinicalAudit savedAudit = clinicalAuditRepository.save(audit);
            return mapToDTO(savedAudit);
        }
        return null;
    }
    
    @Override
    public ClinicalAuditDTO addAuditNotes(Long auditId, String notes) {
        ClinicalAudit audit = clinicalAuditRepository.findById(auditId).orElse(null);
        if (audit != null) {
            audit.setAuditNotes(notes);
            ClinicalAudit savedAudit = clinicalAuditRepository.save(audit);
            return mapToDTO(savedAudit);
        }
        return null;
    }
    
    @Override
    public ClinicalAuditDTO addRecommendations(Long auditId, String recommendations) {
        ClinicalAudit audit = clinicalAuditRepository.findById(auditId).orElse(null);
        if (audit != null) {
            audit.setRecommendations(recommendations);
            ClinicalAudit savedAudit = clinicalAuditRepository.save(audit);
            return mapToDTO(savedAudit);
        }
        return null;
    }
    
    @Override
    public ClinicalAuditDTO getAuditById(Long auditId) {
        ClinicalAudit audit = clinicalAuditRepository.findById(auditId).orElse(null);
        return audit != null ? mapToDTO(audit) : null;
    }
    
    /**
     * Map ClinicalAudit entity to DTO
     */
    private ClinicalAuditDTO mapToDTO(ClinicalAudit audit) {
        ClinicalAuditDTO dto = new ClinicalAuditDTO();
        
        dto.setId(audit.getId());
        dto.setAuditType(audit.getAuditType());
        dto.setQualityRating(audit.getQualityRating());
        dto.setAuditStatus(audit.getAuditStatus());
        dto.setAuditNotes(audit.getAuditNotes());
        dto.setRecommendations(audit.getRecommendations());
        dto.setAuditDate(audit.getAuditDate());
        
        // Set formatted date
        if (audit.getAuditDate() != null) {
            dto.setAuditDateFormatted(audit.getAuditDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        }
        
        // Set IDs
        if (audit.getClinicalFile() != null) {
            dto.setClinicalFileId(audit.getClinicalFile().getId());
        }
        if (audit.getExamination() != null) {
            dto.setExaminationId(audit.getExamination().getId());
        }
        if (audit.getAuditor() != null) {
            dto.setAuditorId(audit.getAuditor().getId());
            dto.setAuditorName(audit.getAuditor().getFirstName() + " " + audit.getAuditor().getLastName());
        }
        
        // Set display names
        if (audit.getAuditType() != null) {
            dto.setAuditTypeDisplay(audit.getAuditType().getDisplayName());
        }
        if (audit.getQualityRating() != null) {
            dto.setQualityRatingDisplay(audit.getQualityRating().getDisplayName());
        }
        if (audit.getAuditStatus() != null) {
            dto.setAuditStatusDisplay(audit.getAuditStatus().getDisplayName());
        }
        
        return dto;
    }
}

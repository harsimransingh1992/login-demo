package com.example.logindemo.dto;

import com.example.logindemo.model.ClinicalAudit;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * DTO for ClinicalAudit entity with minimal details for efficient data transfer
 */
@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ClinicalAuditDTO {
    
    private Long id;
    private Long clinicalFileId;
    private Long examinationId;
    private Long auditorId;
    
    // Auditor information for display
    private String auditorName;
    
    private ClinicalAudit.AuditType auditType;
    private ClinicalAudit.QualityRating qualityRating;
    private ClinicalAudit.AuditStatus auditStatus;
    
    private String auditNotes;
    private String recommendations;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private LocalDateTime auditDate;
    
    // Formatted date for display
    private String auditDateFormatted;
    
    // Display names for enums
    private String auditTypeDisplay;
    private String qualityRatingDisplay;
    private String auditStatusDisplay;
}

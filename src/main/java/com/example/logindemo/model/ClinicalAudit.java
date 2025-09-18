package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing clinical audit records for senior doctor reviews.
 * This tracks audit activities on clinical files and examinations.
 */
@Setter
@Getter
@Entity
@Table(name = "clinical_audit")
public class ClinicalAudit {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    /**
     * The clinical file being audited
     */
    @ManyToOne
    @JoinColumn(name = "clinical_file_id")
    private ClinicalFile clinicalFile;
    
    /**
     * The specific examination being audited (optional)
     */
    @ManyToOne
    @JoinColumn(name = "examination_id")
    private ToothClinicalExamination examination;
    
    /**
     * The senior doctor who performed the audit
     */
    @ManyToOne
    @JoinColumn(name = "auditor_id")
    private User auditor;
    
    /**
     * Type of audit action performed
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "audit_type")
    private AuditType auditType;
    
    /**
     * Quality assessment rating
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "quality_rating")
    private QualityRating qualityRating;
    
    /**
     * Brief audit notes
     */
    @Column(name = "audit_notes", columnDefinition = "TEXT")
    private String auditNotes;
    
    /**
     * Recommendations from the auditor
     */
    @Column(name = "recommendations", columnDefinition = "TEXT")
    private String recommendations;
    
    /**
     * Audit timestamp
     */
    @Column(name = "audit_date")
    private LocalDateTime auditDate = LocalDateTime.now();
    
    /**
     * Status of the audit
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "audit_status")
    private AuditStatus auditStatus = AuditStatus.PENDING;
    
    /**
     * Enum for audit types
     */
    public enum AuditType {
        INITIAL_REVIEW("Initial Review"),
        QUALITY_ASSESSMENT("Quality Assessment"),
        APPROVAL("Approval"),
        REVISION_REQUEST("Revision Request"),
        FINAL_APPROVAL("Final Approval");
        
        private final String displayName;
        
        AuditType(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
    
    /**
     * Enum for quality ratings
     */
    public enum QualityRating {
        EXCELLENT("Excellent - All standards met"),
        GOOD("Good - Minor improvements needed"),
        FAIR("Fair - Some concerns identified"),
        POOR("Poor - Significant issues found");
        
        private final String displayName;
        
        QualityRating(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
    
    /**
     * Enum for audit status
     */
    public enum AuditStatus {
        PENDING("Pending"),
        IN_PROGRESS("In Progress"),
        APPROVED("Approved"),
        REVISION_REQUESTED("Revision Requested"),
        COMPLETED("Completed");
        
        private final String displayName;
        
        AuditStatus(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
}

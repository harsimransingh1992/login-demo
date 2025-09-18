package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity representing a clinical file that groups multiple tooth examinations.
 * This provides a higher-level organization for dental case management.
 */
@Setter
@Getter
@Entity
@Table(name = "clinical_file")
public class ClinicalFile {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    /**
     * The patient this clinical file belongs to.
     */
    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
    
    /**
     * The clinic where this file was created.
     */
    @ManyToOne
    @JoinColumn(name = "clinic_id", nullable = false)
    private ClinicModel clinic;
    
    /**
     * File number/identifier for easy reference.
     */
    @Column(name = "file_number", unique = true)
    private String fileNumber;
    
    /**
     * Title or description of the clinical file.
     */
    @Column(name = "title", length = 500)
    private String title;
    
    /**
     * Current status of the clinical file.
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ClinicalFileStatus status = ClinicalFileStatus.ACTIVE;
    
    /**
     * Date when the file was created.
     */
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
    
    /**
     * Date when the file was last updated.
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();
    
    /**
     * Date when the file was closed/completed.
     */
    @Column(name = "closed_at")
    private LocalDateTime closedAt;
    
    /**
     * Notes and comments for this clinical file.
     */
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    /**
     * The list of tooth examinations in this clinical file.
     */
    @OneToMany(mappedBy = "clinicalFile", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("createdAt ASC")
    private List<ToothClinicalExamination> examinations = new ArrayList<>();
    
    /**
     * Add an examination to this clinical file.
     */
    public void addExamination(ToothClinicalExamination examination) {
        examinations.add(examination);
        examination.setClinicalFile(this);
    }
    
    /**
     * Remove an examination from this clinical file.
     */
    public void removeExamination(ToothClinicalExamination examination) {
        examinations.remove(examination);
        examination.setClinicalFile(null);
    }
    
    /**
     * Get the total number of examinations in this file.
     */
    public int getExaminationCount() {
        return examinations != null ? examinations.size() : 0;
    }
    
    /**
     * Get the total amount for all procedures in this file.
     */
    public Double getTotalAmount() {
        if (examinations == null || examinations.isEmpty()) {
            return 0.0;
        }
        return examinations.stream()
            .mapToDouble(exam -> exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0)
            .sum();
    }
    
    /**
     * Get the total amount paid across all examinations in this file.
     */
    public Double getTotalPaidAmount() {
        if (examinations == null || examinations.isEmpty()) {
            return 0.0;
        }
        return examinations.stream()
            .mapToDouble(exam -> exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0)
            .sum();
    }
    
    /**
     * Get the remaining amount to be paid for this file.
     */
    public Double getRemainingAmount() {
        return getTotalAmount() - getTotalPaidAmount();
    }
    
    /**
     * Check if this file has any pending payments.
     */
    public boolean hasPendingPayments() {
        return getRemainingAmount() > 0;
    }
    
    /**
     * Get the overall status of all examinations in this file.
     */
    public String getOverallStatus() {
        if (examinations == null || examinations.isEmpty()) {
            return "NO_EXAMINATIONS";
        }
        
        long openCount = examinations.stream()
            .filter(exam -> exam.getProcedureStatus() == ProcedureStatus.OPEN)
            .count();
        long inProgressCount = examinations.stream()
            .filter(exam -> exam.getProcedureStatus() == ProcedureStatus.IN_PROGRESS)
            .count();
        long completedCount = examinations.stream()
            .filter(exam -> exam.getProcedureStatus() == ProcedureStatus.COMPLETED)
            .count();
        long closedCount = examinations.stream()
            .filter(exam -> exam.getProcedureStatus() == ProcedureStatus.CLOSED)
            .count();
        
        if (closedCount == examinations.size()) {
            return "COMPLETED";
        } else if (inProgressCount > 0) {
            return "IN_PROGRESS";
        } else if (openCount > 0) {
            return "OPEN";
        } else {
            return "MIXED";
        }
    }
    
    /**
     * Close this clinical file.
     */
    public void close() {
        this.status = ClinicalFileStatus.CLOSED;
        this.closedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    /**
     * Reopen this clinical file.
     */
    public void reopen() {
        this.status = ClinicalFileStatus.ACTIVE;
        this.closedAt = null;
        this.updatedAt = LocalDateTime.now();
    }
    
    /**
     * Check if this file can be closed.
     */
    public boolean canBeClosed() {
        return status == ClinicalFileStatus.ACTIVE && 
               examinations != null && 
               !examinations.isEmpty() &&
               examinations.stream().allMatch(exam -> exam.getProcedureStatus() == ProcedureStatus.CLOSED);
    }
}

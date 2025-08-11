package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a record of case reopening in the dental management system.
 * Tracks who reopened the case, when, why, and other relevant details.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "reopening_records")
public class ReopeningRecord {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    /**
     * The examination that was reopened
     */
    @ManyToOne
    @JoinColumn(name = "examination_id", nullable = false)
    private ToothClinicalExamination examination;
    
    /**
     * The doctor who reopened the case
     */
    @ManyToOne
    @JoinColumn(name = "reopened_by_doctor_id", nullable = false)
    private User reopenedByDoctor;
    
    /**
     * The clinic where the reopening occurred
     */
    @ManyToOne
    @JoinColumn(name = "clinic_id", nullable = false)
    private ClinicModel clinic;
    
    /**
     * When the case was reopened
     */
    @Column(name = "reopened_at", nullable = false)
    private LocalDateTime reopenedAt = LocalDateTime.now();
    
    /**
     * Reason for reopening the case
     */
    @Column(name = "reopening_reason", columnDefinition = "TEXT")
    private String reopeningReason;
    
    /**
     * Additional notes about the reopening
     */
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    /**
     * The previous status before reopening
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "previous_status")
    private ProcedureStatus previousStatus;
    
    /**
     * The new status after reopening
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "new_status")
    private ProcedureStatus newStatus = ProcedureStatus.REOPEN;
    
    /**
     * Patient's condition at the time of reopening
     */
    @Column(name = "patient_condition", columnDefinition = "TEXT")
    private String patientCondition;
    
    /**
     * Treatment plan for the reopened case
     */
    @Column(name = "treatment_plan", columnDefinition = "TEXT")
    private String treatmentPlan;
    
    /**
     * Whether this reopening was approved by a senior doctor
     */
    @Column(name = "approved_by_senior")
    private Boolean approvedBySenior = false;
    
    /**
     * Senior doctor who approved the reopening (if applicable)
     */
    @ManyToOne
    @JoinColumn(name = "approved_by_doctor_id")
    private User approvedByDoctor;
    
    /**
     * Approval date (if applicable)
     */
    @Column(name = "approval_date")
    private LocalDateTime approvalDate;
    
    /**
     * Sequence number of this reopening (1st, 2nd, 3rd, etc.)
     */
    @Column(name = "reopening_sequence")
    private Integer reopeningSequence;
    
    /**
     * Constructor for creating a new reopening record
     */
    public ReopeningRecord(ToothClinicalExamination examination, User reopenedByDoctor, 
                          ClinicModel clinic, String reopeningReason, ProcedureStatus previousStatus) {
        this.examination = examination;
        this.reopenedByDoctor = reopenedByDoctor;
        this.clinic = clinic;
        this.reopeningReason = reopeningReason;
        this.previousStatus = previousStatus;
        this.reopenedAt = LocalDateTime.now();
    }
}
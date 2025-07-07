package com.example.logindemo.model;

import javax.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "procedure_lifecycle_transitions")
@Getter
@Setter
public class ProcedureLifecycleTransition {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "examination_id", nullable = false)
    private ToothClinicalExamination examination;
    
    @Column(name = "stage_name", nullable = false)
    private String stageName;
    
    @Column(name = "stage_description", nullable = false)
    private String stageDescription;
    
    @Column(name = "transition_time", nullable = false)
    private LocalDateTime transitionTime;
    
    @Column(nullable = false)
    private boolean completed;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transitioned_by")
    private User transitionedBy;
    
    @Column(name = "stage_details", columnDefinition = "TEXT")
    private String stageDetails; // Store stage details as JSON
    
    // Stage types based on the existing lifecycle
    public static final String STAGE_EXAMINATION_CREATED = "Examination Created";
    public static final String STAGE_PROCEDURE_OPENED = "Procedure Opened";
    public static final String STAGE_PAYMENT_VERIFICATION = "Payment Verification";
    public static final String STAGE_PROCEDURE_STARTED = "Procedure Started";
    public static final String STAGE_PROCEDURE_COMPLETED = "Procedure Completed";
    public static final String STAGE_FOLLOW_UP = "Follow-up";
} 
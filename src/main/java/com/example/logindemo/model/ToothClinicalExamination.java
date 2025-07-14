package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

/**
 * Entity representing a tooth clinical examination record in the dental management system.
 * This entity maps to the 'toothclinicalexamination' table in the database.
 */
@Setter
@Getter
@Entity
@Table(name = "toothclinicalexamination")
public class ToothClinicalExamination {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * The tooth number being examined.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ToothNumber toothNumber;

    /**
     * The surface of the tooth being examined.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ToothSurface toothSurface;

    /**
     * The condition of the tooth.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ToothCondition toothCondition;

    /**
     * The mobility level of the tooth.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ToothMobility toothMobility;

    /**
     * The pocket depth measurement.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private PocketDepth pocketDepth;

    /**
     * Whether the tooth bleeds on probing.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private BleedingOnProbing bleedingOnProbing;

    /**
     * The plaque score of the tooth.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private PlaqueScore plaqueScore;

    /**
     * The gingival recession level.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private GingivalRecession gingivalRecession;

    /**
     * The vitality status of the tooth.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ToothVitality toothVitality;

    /**
     * The furcation involvement level.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private FurcationInvolvement furcationInvolvement;

    /**
     * The periapical condition of the tooth.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private PeriapicalCondition periapicalCondition;

    /**
     * The sensitivity level of the tooth.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ToothSensitivity toothSensitivity;

    /**
     * The existing restoration on the tooth, if any.
     * Stored as a string representation of the enum in the database.
     */
    @Enumerated(EnumType.STRING)
    private ExistingRestoration existingRestoration;

    /**
     * The date and time when the examination was created.
     * Stored as a timestamp in the database.
     */
    @Column(nullable = false)
    private LocalDateTime examinationDate = LocalDateTime.now();

    /**
     * Clinical notes for the examination.
     * Stored as text in the database.
     */
    @Column
    private String examinationNotes;

    /**
     * Chief complaints reported by the patient.
     * Stored as text in the database.
     */
    @Column(name = "chief_complaints", columnDefinition = "TEXT")
    private String chiefComplaints;

    /**
     * Treatment or procedure advised by the doctor.
     * Stored as text in the database.
     */
    @Column(name = "advised", columnDefinition = "TEXT")
    private String advised;

    /**
     * Path to the uploaded upper denture picture.
     * Stored as a string in the database.
     */
    @Column(name = "upper_denture_picture_path")
    private String upperDenturePicturePath;

    /**
     * Path to the uploaded lower denture picture.
     * Stored as a string in the database.
     */
    @Column(name = "lower_denture_picture_path")
    private String lowerDenturePicturePath;

    /**
     * Path to the uploaded X-ray picture when case is closed.
     * Stored as a string in the database.
     */
    @Column(name = "xray_picture_path")
    private String xrayPicturePath;

    /**
     * The doctor assigned to this examination.
     * This is a reference to a User entity with DOCTOR role.
     * 
     * Database column: assigned_user_id
     * This column stores the foreign key to the user table.
     * 
     * Note: Previously, this was linked to a dedicated DoctorDetail entity,
     * but after refactoring, it now references the User entity directly where the user
     * has a DOCTOR role.
     */
    @ManyToOne
    @JoinColumn(name = "assigned_user_id")
    private User assignedDoctor;

    /**
     * The doctor who performed the initial OPD examination.
     * This is different from the assigned doctor who will perform the treatment.
     * Stored as a foreign key to the user table in the database.
     */
    @ManyToOne
    @JoinColumn(name = "opd_doctor_id")
    private User opdDoctor;

    /**
     * The patient that this examination belongs to.
     * Stored as a foreign key to the patient table in the database.
     */
    @ManyToOne
    private Patient patient;

    /**
     * The planned date and time for treatment.
     * Stored as a timestamp in the database.
     */
    @Column
    private LocalDateTime treatmentStartingDate;

    /**
     * The clinic where the examination was performed.
     * Stored as a foreign key to the clinics table in the database.
     */
    @ManyToOne
    @JoinColumn(name = "clinic_id")
    private ClinicModel examinationClinic;

    /**
     * The procedure associated with this examination.
     * Represents a many-to-one relationship with the ProcedurePrice entity.
     * Stored as a foreign key in the database.
     */
    @ManyToOne
    @JoinColumn(name = "procedure_id")
    private ProcedurePrice procedure;

    /**
     * The creation timestamp of the examination
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    
    /**
     * The last update timestamp of the examination
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();
    
    /**
     * The time when the procedure started
     */
    @Column(name = "procedure_start_time")
    private LocalDateTime procedureStartTime;
    
    /**
     * The time when the procedure ended
     */
    @Column(name = "procedure_end_time")
    private LocalDateTime procedureEndTime;
    
    /**
     * The status of the procedure in the workflow
     * Represents the current stage in the JIRA-like workflow
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "procedure_status")
    private ProcedureStatus procedureStatus = ProcedureStatus.OPEN;
    
    /**
     * The date scheduled for follow-up
     */
    @Column(name = "follow_up_date")
    private LocalDateTime followUpDate;
    
    /**
     * The total amount of the procedure that needs to be paid.
     * This is stored separately from the procedure price to allow for adjustments.
     */
    @Column(name = "total_procedure_amount")
    private Double totalProcedureAmount;
    
    /**
     * The list of payment entries (partial or full payments) for this examination.
     */
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<PaymentEntry> paymentEntries;

    /**
     * The list of follow-up records for this examination.
     */
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("sequenceNumber ASC")
    private List<FollowUpRecord> followUpRecords;

    /**
     * Gets the total amount paid so far by summing up all payment entries.
     * @return the total amount paid
     */
    public Double getTotalPaidAmount() {
        if (paymentEntries == null || paymentEntries.isEmpty()) return 0.0;
        return paymentEntries.stream()
            .mapToDouble(e -> e.getAmount() != null ? e.getAmount() : 0.0)
            .sum();
    }

    /**
     * Gets the remaining amount to be paid.
     * @return the remaining amount
     */
    public Double getRemainingAmount() {
        return totalProcedureAmount - getTotalPaidAmount();
    }

    /**
     * Updates the payment details for this examination
     * @param paymentMode The mode of payment
     * @param amount The amount collected
     * @param notes Additional payment notes
     */
    public void updatePaymentDetails(PaymentMode paymentMode, Double amount, String notes) {
        // This method is removed as per the instructions
    }

    /**
     * Gets the doctor assigned to this examination.
     * This is provided as a getter method with a simpler name for compatibility.
     * 
     * @return the assigned doctor
     */
    public User getDoctor() {
        return this.assignedDoctor;
    }

    /**
     * Gets the latest follow-up record for this examination.
     * @return the latest follow-up record or null if none exists
     */
    public FollowUpRecord getLatestFollowUp() {
        if (followUpRecords == null || followUpRecords.isEmpty()) {
            return null;
        }
        return followUpRecords.stream()
            .filter(followUp -> followUp.getIsLatest())
            .findFirst()
            .orElse(followUpRecords.get(followUpRecords.size() - 1)); // Fallback to last in list
    }

    /**
     * Gets the next sequence number for a new follow-up.
     * @return the next sequence number
     */
    public Integer getNextFollowUpSequenceNumber() {
        if (followUpRecords == null || followUpRecords.isEmpty()) {
            return 1;
        }
        return followUpRecords.size() + 1;
    }

    /**
     * Adds a new follow-up record to this examination.
     * @param followUpRecord the follow-up record to add
     */
    public void addFollowUpRecord(FollowUpRecord followUpRecord) {
        if (followUpRecords == null) {
            followUpRecords = new ArrayList<>();
        }
        
        // Set sequence number if not already set
        if (followUpRecord.getSequenceNumber() == null) {
            followUpRecord.setSequenceNumber(getNextFollowUpSequenceNumber());
        }
        
        // Mark all existing follow-ups as not latest
        followUpRecords.forEach(followUp -> followUp.setIsLatest(false));
        
        // Add new follow-up and mark as latest
        followUpRecord.setIsLatest(true);
        followUpRecords.add(followUpRecord);
    }

    /**
     * Gets the total number of follow-ups for this examination.
     * @return the total number of follow-ups
     */
    public int getTotalFollowUps() {
        return followUpRecords != null ? followUpRecords.size() : 0;
    }

    /**
     * Gets the number of completed follow-ups for this examination.
     * @return the number of completed follow-ups
     */
    public long getCompletedFollowUps() {
        if (followUpRecords == null) return 0;
        return followUpRecords.stream()
            .filter(followUp -> followUp.getStatus() == FollowUpStatus.COMPLETED)
            .count();
    }

    public void setPaymentAmount(Double price) {
    }
}

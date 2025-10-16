package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

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
    @Column(name = "examination_notes", columnDefinition = "TEXT")
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
     * List of X-ray images associated with this examination.
     */
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<MediaFile> xrayImages = new ArrayList<>();

    /**
     * Path to the uploaded X-ray picture when case is closed.
     * Stored as a string in the database.
     * @deprecated Use xrayImages instead.
     */
    @Deprecated
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
     * The clinical file this examination belongs to.
     * This allows grouping multiple examinations into a single clinical case.
     */
    @ManyToOne
    @JoinColumn(name = "clinical_file_id")
    private ClinicalFile clinicalFile;

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
     * Snapshot of the base price at the time the procedure was associated
     * This remains constant for discount calculations and inspection.
     */
    @Column(name = "base_price_at_association")
    private Double basePriceAtAssociation;

    /**
     * Optional percentage discount applied to this examination's total amount.
     * Represented as a value between 0 and 100.
     * If null or 0, no discount is applied.
     */
    @Column(name = "discount_percentage")
    private Double discountPercentage;

    /**
     * Optional reason for the applied discount, used for audit trail.
     */
    @Column(name = "discount_reason", length = 500)
    private String discountReason;

    /**
     * Standardized discount reason as enum for audit and consistency.
     * Keeps backward compatibility by coexisting with the string reason field.
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "discount_reason_enum")
    private DiscountReason discountReasonEnum;
    
    /**
     * The list of payment entries (partial or full payments) for this examination.
     */
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<PaymentEntry> paymentEntries;

    /**
     * Relational discount entries applied to this examination.
     */
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = false, fetch = FetchType.LAZY)
    @OrderBy("appliedAt ASC")
    private List<DiscountEntry> discountEntries = new ArrayList<>();

    /**
     * The list of follow-up records for this examination.
     */
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("sequenceNumber ASC")
    private List<FollowUpRecord> followUpRecords;
    
    // Reopening records
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("reopenedAt DESC")
    private List<ReopeningRecord> reopeningRecords = new ArrayList<>();
    
    /**
     * Gets the total amount paid so far by summing up all capture (payment) entries.
     * @return the total amount paid
     */
    public Double getTotalPaidAmount() {
        if (paymentEntries == null || paymentEntries.isEmpty()) return 0.0;
        return paymentEntries.stream()
            .filter(entry -> entry.getTransactionType() == TransactionType.CAPTURE)
            .mapToDouble(e -> e.getAmount() != null ? e.getAmount() : 0.0)
            .sum();
    }

    /**
     * Gets the remaining amount to be paid.
     * @return the remaining amount
     */
    public Double getRemainingAmount() {
        return getEffectiveTotalProcedureAmount() - getTotalPaidAmount();
    }

    /**
     * Computes the effective total amount after applying discount.
     * If no discount is set, returns the original totalProcedureAmount.
     * Ensures non-negative and supports full waiver when discountPercentage is 100.
     *
     * @return effective total amount after discount
     */
    public Double getEffectiveTotalProcedureAmount() {
        // If there are active relational discounts, prefer the stored net total if present
        // to avoid double-discounting. If not present, compute from available base.
        if (discountEntries != null && !getActiveDiscountEntries().isEmpty()) {
            if (totalProcedureAmount != null) {
                return Math.max(totalProcedureAmount, 0.0);
            }
            double base = 0.0;
            if (procedure != null && procedure.getPrice() != null) {
                base = procedure.getPrice();
            }
            double dp = getAggregatedDiscountPercentage();
            double effective = base * (1 - (dp / 100.0));
            return effective < 0 ? 0.0 : effective;
        }
        // No active relational discounts: fall back to legacy fields or return total as-is
        double base = totalProcedureAmount != null ? totalProcedureAmount : 0.0;
        double dp = 0.0;
        if (discountPercentage != null) {
            dp = discountPercentage;
        } else if (discountReasonEnum != null) {
            dp = discountReasonEnum == DiscountReason.OTHER ? 0.0 : discountReasonEnum.resolvePercentage();
        }
        double effective = base * (1 - (dp / 100.0));
        return effective < 0 ? 0.0 : effective;
    }

    /**
     * Indicates whether the treatment is fully waived (effective amount is zero).
     * @return true when fully waived
     */
    public boolean isFullyWaived() {
        return getEffectiveTotalProcedureAmount() <= 0.0;
    }

    /**
     * Validates if a proposed payment amount can be accepted against the remaining
     * amount after discount.
     *
     * @param amount the proposed payment amount
     * @return true if amount does not exceed the discounted remaining amount
     */
    public boolean canAcceptPaymentAmount(Double amount) {
        if (amount == null || amount < 0) return false;
        return amount <= (getRemainingAmount() + 1e-6);
    }

    /**
     * Get active discount entries only.
     */
    public List<DiscountEntry> getActiveDiscountEntries() {
        if (discountEntries == null) return java.util.Collections.emptyList();
        return discountEntries.stream()
                .filter(e -> Boolean.TRUE.equals(e.getActive()))
                .collect(Collectors.toList());
    }

    /**
     * Sum active discount percentages and clamp to [0, 100].
     */
    public double getAggregatedDiscountPercentage() {
        List<DiscountEntry> active = getActiveDiscountEntries();
        if (active.isEmpty()) return 0.0;
        double sum = active.stream()
                .mapToDouble(e -> e.getEffectivePercentage())
                .sum();
        if (sum < 0.0) return 0.0;
        return Math.min(sum, 100.0);
    }

    /**
     * Update legacy discount fields from active relational entries to keep UI compatibility.
     */
    public void updateLegacyDiscountFieldsFromEntries() {
        List<DiscountEntry> active = getActiveDiscountEntries();
        if (active.isEmpty()) {
            this.setDiscountPercentage(null);
            this.setDiscountReasonEnum(null);
            this.setDiscountReason(null);
            return;
        }
        if (active.size() == 1) {
            DiscountEntry e = active.get(0);
            this.setDiscountPercentage(e.getEffectivePercentage());
            this.setDiscountReasonEnum(e.getReasonEnum());
            String label = (e.getNote() != null && !e.getNote().trim().isEmpty())
                    ? e.getNote().trim()
                    : (e.getReasonEnum() != null ? e.getReasonEnum().getLabel() : null);
            this.setDiscountReason(label);
        } else {
            this.setDiscountPercentage(getAggregatedDiscountPercentage());
            this.setDiscountReasonEnum(null);
            this.setDiscountReason("Multiple discounts");
        }
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
        this.totalProcedureAmount = price;
    }
    
    /**
     * Get the total number of times this case has been reopened
     */
    public int getReopenCount() {
        return reopeningRecords != null ? reopeningRecords.size() : 0;
    }
    
    /**
     * Get the latest reopening record
     */
    public ReopeningRecord getLatestReopening() {
        if (reopeningRecords == null || reopeningRecords.isEmpty()) {
            return null;
        }
        return reopeningRecords.get(0); // Ordered by reopenedAt DESC
    }
    
    /**
     * Check if the case can be reopened (currently closed)
     */
    public boolean canBeReopened() {
        return procedureStatus == ProcedureStatus.CLOSED;
    }
    
    /**
     * Add a new reopening record
     */
    public void addReopeningRecord(ReopeningRecord reopeningRecord) {
        if (reopeningRecords == null) {
            reopeningRecords = new ArrayList<>();
        }
        reopeningRecord.setReopeningSequence(getReopenCount() + 1);
        reopeningRecords.add(reopeningRecord);
    }

    /**
     * Gets the total amount refunded so far by summing up all refund entries.
     * @return the total amount refunded
     */
    public Double getTotalRefundedAmount() {
        if (paymentEntries == null) return 0.0;
        return paymentEntries.stream()
            .filter(entry -> entry.getTransactionType() == TransactionType.REFUND)
            .mapToDouble(entry -> Math.abs(entry.getAmount()))
            .sum();
    }

    /**
     * Gets the net amount paid (total paid minus total refunded).
     * @return the net amount paid
     */
    public Double getNetPaidAmount() {
        return getTotalPaidAmount() - getTotalRefundedAmount();
    }

    /**
     * Gets all refund entries for this examination.
     * @return list of refund entries
     */
    public List<PaymentEntry> getRefundEntries() {
        if (paymentEntries == null) return new ArrayList<>();
        return paymentEntries.stream()
            .filter(entry -> entry.getTransactionType() == TransactionType.REFUND)
            .collect(Collectors.toList());
    }

    /**
     * Checks if this examination can be refunded.
     * @return true if refund is possible
     */
    public boolean canBeRefunded() {
        return getTotalPaidAmount() > 0 && 
               procedureStatus != ProcedureStatus.CANCELLED &&
               getNetPaidAmount() > 0;
    }

    /**
     * Gets the maximum refundable amount (net paid amount).
     * @return the maximum amount that can be refunded
     */
    public Double getMaxRefundableAmount() {
        return getNetPaidAmount();
    }
}

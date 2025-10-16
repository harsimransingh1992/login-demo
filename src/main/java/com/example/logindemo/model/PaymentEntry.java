package com.example.logindemo.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a payment entry in the dental management system.
 * This entity maps to the 'payment_entry' table in the database.
 * It allows tracking of partial payments for a clinical examination.
 */
@Setter
@Getter
@Entity
@Table(name = "payment_entry")
public class PaymentEntry {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * The amount paid in this entry
     */
    @Column(name = "amount", nullable = false)
    private Double amount;

    /**
     * The mode of payment (CASH, CARD, UPI, etc.)
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_mode", nullable = false)
    private PaymentMode paymentMode;

    /**
     * Additional payment notes
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_notes")
    private PaymentNotes paymentNotes;

    /**
     * The type of transaction (CAPTURE, REFUND, etc.)
     * Following banking/payment processor patterns like CyberSource
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", nullable = false)
    private TransactionType transactionType = TransactionType.CAPTURE;

    /**
     * The date and time when the payment was made
     */
    @Column(name = "payment_date", nullable = false)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Kolkata")
    private LocalDateTime paymentDate = LocalDateTime.now();

    /**
     * The clinical examination this payment is associated with
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "examination_id", nullable = false)
    private ToothClinicalExamination examination;

    /**
     * The user who recorded this payment
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recorded_by", nullable = false)
    private User recordedBy;

    /**
     * The creation timestamp of the payment entry
     */
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    /**
     * The last update timestamp of the payment entry
     */
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    /**
     * Any additional notes or remarks for this payment entry
     */
    @Column(name = "remarks", length = 500)
    private String remarks;

    /**
     * The transaction reference number if applicable
     */
    @Column(name = "transaction_reference", length = 100)
    private String transactionReference;

    /**
     * The type of refund (FULL or PARTIAL) if this is a refund entry
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "refund_type")
    private RefundType refundType;

    /**
     * Reference to the original payment entry being refunded
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "original_payment_id")
    private PaymentEntry originalPayment;

    /**
     * The reason for the refund
     */
    @Column(name = "refund_reason", length = 500)
    private String refundReason;

    /**
     * The user who approved this refund
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "refund_approved_by")
    private User refundApprovedBy;

    /**
     * The date and time when the refund was approved
     */
    @Column(name = "refund_approval_date")
    private LocalDateTime refundApprovalDate;

    /**
     * Percentage discount applied for this payment (if any).
     * Stored for audit; typically null if no discount.
     */
    @Column(name = "applied_discount_percentage")
    private Double appliedDiscountPercentage;

    /**
     * Reason for applying the discount (audit trail).
     */
    @Column(name = "discount_reason", length = 500)
    private String discountReason;

    /**
     * Standardized applied discount reason for audit and consistency.
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "applied_discount_reason")
    private DiscountReason appliedDiscountReason;

    /**
     * User who approved/applied the discount (audit trail).
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "discount_applied_by")
    private User discountAppliedBy;

    /**
     * Helper method to check if this entry is a refund
     */
    public boolean isRefund() {
        return transactionType == TransactionType.REFUND;
    }

    /**
     * Helper method to check if this entry is a capture (payment)
     */
    public boolean isCapture() {
        return transactionType == TransactionType.CAPTURE;
    }

    /**
     * Helper method to check if this is a full refund
     */
    public boolean isFullRefund() {
        return isRefund() && refundType == RefundType.FULL;
    }

    /**
     * Helper method to check if this is a partial refund
     */
    public boolean isPartialRefund() {
        return isRefund() && refundType == RefundType.PARTIAL;
    }

    /**
     * Creates a new payment entry with the specified details
     */
    public static PaymentEntry createPaymentEntry(
            Double amount,
            PaymentMode paymentMode,
            PaymentNotes paymentNotes,
            TransactionType transactionType,
            ToothClinicalExamination examination,
            User recordedBy,
            String remarks,
            String transactionReference) {
        
        PaymentEntry entry = new PaymentEntry();
        entry.setAmount(amount);
        entry.setPaymentMode(paymentMode);
        entry.setPaymentNotes(paymentNotes);
        entry.setTransactionType(transactionType);
        entry.setExamination(examination);
        entry.setRecordedBy(recordedBy);
        entry.setRemarks(remarks);
        entry.setTransactionReference(transactionReference);
        return entry;
    }

    /**
     * Creates a new capture (payment) entry
     */
    public static PaymentEntry createCaptureEntry(
            Double amount,
            PaymentMode paymentMode,
            ToothClinicalExamination examination,
            User recordedBy,
            String remarks,
            String transactionReference) {
        
        return createPaymentEntry(amount, paymentMode, PaymentNotes.FULL_PAYMENT, 
                TransactionType.CAPTURE, examination, recordedBy, remarks, transactionReference);
    }

    /**
     * Calculates the discounted amount given a base amount and a discount percentage.
     * Ensures the result is non-negative and supports full waiver when discountPercentage is 100.
     */
    public static Double calculateDiscountedAmount(Double baseAmount, Double discountPercentage) {
        double base = baseAmount != null ? baseAmount : 0.0;
        double dp = discountPercentage != null ? discountPercentage : 0.0;
        double effective = base * (1 - (dp / 100.0));
        return effective < 0 ? 0.0 : effective;
    }

    /**
     * Creates a new capture (payment) entry by applying a discount percentage to the base amount
     * before processing the payment, and records audit information about the discount.
     */
    public static PaymentEntry createCaptureEntry(
            Double baseAmount,
            PaymentMode paymentMode,
            ToothClinicalExamination examination,
            User recordedBy,
            String remarks,
            String transactionReference,
            Double appliedDiscountPercentage,
            String discountReason,
            User discountAppliedBy) {
        
        Double amount = calculateDiscountedAmount(baseAmount, appliedDiscountPercentage);
        PaymentEntry entry = createPaymentEntry(amount, paymentMode, PaymentNotes.FULL_PAYMENT,
                TransactionType.CAPTURE, examination, recordedBy, remarks, transactionReference);
        entry.setAppliedDiscountPercentage(appliedDiscountPercentage);
        entry.setDiscountReason(discountReason);
        entry.setDiscountAppliedBy(discountAppliedBy);
        if (appliedDiscountPercentage != null && appliedDiscountPercentage > 0.0) {
            entry.setAppliedDiscountReason(DiscountReason.OTHER);
        }
        return entry;
    }

    /**
     * Creates a new capture (payment) entry using a standardized discount reason.
     * If the reason is OTHER, an optional custom percentage can be supplied; otherwise
     * percentages are resolved from configuration defaults.
     */
    public static PaymentEntry createCaptureEntry(
            Double baseAmount,
            PaymentMode paymentMode,
            ToothClinicalExamination examination,
            User recordedBy,
            String remarks,
            String transactionReference,
            DiscountReason appliedReason,
            Double customDiscountPercentage,
            String reasonNote,
            User discountAppliedBy) {

        Double percentToApply;
        if (appliedReason == null) {
            percentToApply = customDiscountPercentage != null ? customDiscountPercentage : 0.0;
        } else if (appliedReason == DiscountReason.OTHER) {
            percentToApply = customDiscountPercentage != null ? customDiscountPercentage : 0.0;
        } else {
            percentToApply = appliedReason.resolvePercentage();
        }

        Double amount = calculateDiscountedAmount(baseAmount, percentToApply);
        PaymentEntry entry = createPaymentEntry(amount, paymentMode, PaymentNotes.FULL_PAYMENT,
                TransactionType.CAPTURE, examination, recordedBy, remarks, transactionReference);
        entry.setAppliedDiscountReason(appliedReason);
        entry.setAppliedDiscountPercentage(percentToApply);
        entry.setDiscountAppliedBy(discountAppliedBy);
        entry.setDiscountReason(
                (reasonNote != null && !reasonNote.trim().isEmpty())
                        ? reasonNote.trim()
                        : (appliedReason != null ? appliedReason.getLabel() : null)
        );
        return entry;
    }

    /**
     * Indicates whether a discount was applied on this payment entry.
     */
    public boolean hasDiscountApplied() {
        return appliedDiscountPercentage != null && appliedDiscountPercentage > 0.0;
    }

    /**
     * Creates a new refund entry
     */
    public static PaymentEntry createRefundEntry(
            Double amount,
            PaymentMode paymentMode,
            ToothClinicalExamination examination,
            User recordedBy,
            String refundReason,
            PaymentEntry originalPayment,
            RefundType refundType,
            User approvedBy) {
        
        PaymentEntry entry = createPaymentEntry(amount, paymentMode, PaymentNotes.REFUND, 
                TransactionType.REFUND, examination, recordedBy, refundReason, null);
        entry.setOriginalPayment(originalPayment);
        entry.setRefundType(refundType);
        entry.setRefundReason(refundReason);
        entry.setRefundApprovedBy(approvedBy);
        entry.setRefundApprovalDate(LocalDateTime.now());
        return entry;
    }
}
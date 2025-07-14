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
     * Creates a new payment entry with the specified details
     */
    public static PaymentEntry createPaymentEntry(
            Double amount,
            PaymentMode paymentMode,
            PaymentNotes paymentNotes,
            ToothClinicalExamination examination,
            User recordedBy,
            String remarks,
            String transactionReference) {
        
        PaymentEntry entry = new PaymentEntry();
        entry.setAmount(amount);
        entry.setPaymentMode(paymentMode);
        entry.setPaymentNotes(paymentNotes);
        entry.setExamination(examination);
        entry.setRecordedBy(recordedBy);
        entry.setRemarks(remarks);
        entry.setTransactionReference(transactionReference);
        return entry;
    }
} 
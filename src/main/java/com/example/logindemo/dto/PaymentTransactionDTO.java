package com.example.logindemo.dto;

import com.example.logindemo.model.PaymentMode;
import com.example.logindemo.model.PaymentNotes;
import com.example.logindemo.model.RefundType;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentTransactionDTO {
    
    // Payment Entry Details
    private Long paymentId;
    private Double amount;
    private PaymentMode paymentMode;
    private PaymentNotes paymentNotes;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Kolkata")
    private LocalDateTime paymentDate;
    
    private String remarks;
    private String transactionReference;
    
    // Refund Details
    private RefundType refundType;
    private String refundReason;
    private Long originalPaymentId;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Kolkata")
    private LocalDateTime refundApprovalDate;
    
    private String refundApprovedByName;
    
    // Examination Details
    private Long examinationId;
    private String toothNumber;
    private String procedureName;
    private Double totalProcedureAmount;
    private Double totalPaidAmount;
    private Double totalRefundedAmount;
    private Double netPaidAmount;
    private String procedureStatus;
    
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Kolkata")
    private LocalDateTime examinationDate;
    
    // Patient Details
    private Long patientId;
    private String patientName;
    private String patientRegistrationCode;
    private String patientPhone;
    private String patientEmail;
    
    // Doctor Details
    private String assignedDoctorName;
    private String opdDoctorName;
    
    // Clinic Details
    private String clinicName;
    
    // User Details
    private String recordedByName;
    
    // Calculated Fields
    private boolean canRefund;
    private boolean isRefund;
    private String paymentStatus; // PAID, PARTIAL_REFUND, FULL_REFUND
    private Double refundableAmount;
    
    // Helper methods
    public boolean isRefund() {
        return paymentNotes == PaymentNotes.REFUND;
    }
    
    public boolean isFullRefund() {
        return isRefund() && refundType == RefundType.FULL;
    }
    
    public boolean isPartialRefund() {
        return isRefund() && refundType == RefundType.PARTIAL;
    }
    
    public String getFormattedAmount() {
        return String.format("₹%.2f", Math.abs(amount));
    }
    
    public String getPaymentStatusBadgeClass() {
        if (isRefund()) {
            return "badge-danger";
        } else if ("PARTIAL_REFUND".equals(paymentStatus)) {
            return "badge-warning";
        } else {
            return "badge-success";
        }
    }
    
    public String getPaymentStatusText() {
        if (isFullRefund()) {
            return "Full Refund";
        } else if (isPartialRefund()) {
            return "Partial Refund";
        } else if ("PARTIAL_REFUND".equals(paymentStatus)) {
            return "Partially Refunded";
        } else {
            return "Paid";
        }
    }
}
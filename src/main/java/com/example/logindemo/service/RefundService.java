package com.example.logindemo.service;

import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;

import java.util.List;

public interface RefundService {
    
    /**
     * Process a full refund for an examination
     */
    PaymentEntry processFullRefund(Long examinationId, String reason, User approvedBy);
    
    /**
     * Process a partial refund for an examination
     */
    PaymentEntry processPartialRefund(Long examinationId, Double amount, 
                                    Long originalPaymentId, String reason, User approvedBy);
    
    /**
     * Get refund history for an examination
     */
    List<PaymentEntry> getRefundHistory(Long examinationId);
    
    /**
     * Validate if refund amount is valid
     */
    boolean validateRefundAmount(Long examinationId, Double refundAmount);
    
    /**
     * Check if user can process refund for this examination
     */
    boolean canUserProcessRefund(User user, ToothClinicalExamination examination);
    
    /**
     * Get all refundable payments for an examination
     */
    List<PaymentEntry> getRefundablePayments(Long examinationId);
}
package com.example.logindemo.service;

import com.example.logindemo.dto.PaymentTransactionDTO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;

public interface PaymentManagementService {
    
    /**
     * Search payment transactions with various filters
     */
    Page<PaymentTransactionDTO> searchPaymentTransactions(
            String searchTerm,
            String searchType,
            String paymentMode,
            String paymentStatus,
            LocalDateTime startDate,
            LocalDateTime endDate,
            Pageable pageable
    );
    
    /**
     * Get payment transaction by ID
     */
    PaymentTransactionDTO getPaymentTransactionById(Long paymentId);
    
    /**
     * Get all payment transactions for an examination
     */
    List<PaymentTransactionDTO> getPaymentTransactionsByExaminationId(Long examinationId);
    
    /**
     * Get all payment transactions for a patient
     */
    List<PaymentTransactionDTO> getPaymentTransactionsByPatientId(Long patientId);
    
    /**
     * Check if a payment can be refunded
     */
    boolean canRefundPayment(Long paymentId);
    
    /**
     * Get refund history for a payment
     */
    List<PaymentTransactionDTO> getRefundHistory(Long originalPaymentId);
}
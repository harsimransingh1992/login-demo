package com.example.logindemo.service.impl;

import com.example.logindemo.model.*;
import com.example.logindemo.repository.PaymentEntryRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.RefundService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class RefundServiceImpl implements RefundService {

    @Autowired
    private PaymentEntryRepository paymentEntryRepository;

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Override
    @Transactional
    public PaymentEntry processFullRefund(Long examinationId, String reason, User approvedBy) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));

        // Validate user can process this refund
        if (!canUserProcessRefund(approvedBy, examination)) {
            throw new SecurityException("User not authorized to refund this examination");
        }

        Double netPaidAmount = examination.getNetPaidAmount();
        if (netPaidAmount <= 0) {
            throw new RuntimeException("No net payments to refund");
        }

        // Create refund entry using factory method
        PaymentEntry refund = PaymentEntry.createRefundEntry(
            netPaidAmount, // Positive amount for refund
            PaymentMode.CASH, // Default to cash refund
            examination,
            approvedBy,
            reason,
            null, // No specific original payment for full refund
            RefundType.FULL,
            approvedBy
        );

        // Log the refund action
        log.info("Full refund processed: ExaminationId={}, Amount={}, ProcessedBy={}, Role={}", 
                 examinationId, netPaidAmount, approvedBy.getUsername(), approvedBy.getRole());

        return paymentEntryRepository.save(refund);
    }

    @Override
    @Transactional
    public PaymentEntry processPartialRefund(Long examinationId, Double amount, 
                                           Long originalPaymentId, String reason, User approvedBy) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));

        // Validate user can process this refund
        if (!canUserProcessRefund(approvedBy, examination)) {
            throw new SecurityException("User not authorized to refund this examination");
        }

        // Validate refund amount
        if (!validateRefundAmount(examinationId, amount)) {
            throw new RuntimeException("Invalid refund amount");
        }

        PaymentEntry originalPayment = null;
        if (originalPaymentId != null) {
            originalPayment = paymentEntryRepository.findById(originalPaymentId)
                .orElseThrow(() -> new RuntimeException("Original payment not found"));
        }

        // Create refund entry using factory method
        PaymentEntry refund = PaymentEntry.createRefundEntry(
            amount, // Positive amount for refund
            PaymentMode.CASH, // Default to cash refund
            examination,
            approvedBy,
            reason,
            originalPayment,
            RefundType.PARTIAL,
            approvedBy
        );

        // Log the refund action
        log.info("Partial refund processed: ExaminationId={}, Amount={}, ProcessedBy={}, Role={}", 
                 examinationId, amount, approvedBy.getUsername(), approvedBy.getRole());

        return paymentEntryRepository.save(refund);
    }

    @Override
    public List<PaymentEntry> getRefundHistory(Long examinationId) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
        
        return examination.getRefundEntries();
    }

    @Override
    public boolean validateRefundAmount(Long examinationId, Double refundAmount) {
        if (refundAmount == null || refundAmount <= 0) {
            return false;
        }

        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
            .orElse(null);
        
        if (examination == null) {
            return false;
        }

        return refundAmount <= examination.getNetPaidAmount();
    }

    @Override
    public boolean canUserProcessRefund(User user, ToothClinicalExamination examination) {
        // First check if user has canRefund permission
        if (user.getCanRefund() == null || !user.getCanRefund()) {
            return false;
        }
        
        UserRole role = user.getRole();
        
        // Admin and Clinic Owner can refund any examination
        if (role == UserRole.ADMIN || role == UserRole.CLINIC_OWNER) {
            return true;
        }
        
        // Doctors can only refund their own examinations
        if (role == UserRole.DOCTOR || role == UserRole.OPD_DOCTOR) {
            return (examination.getAssignedDoctor() != null && 
                    examination.getAssignedDoctor().getId().equals(user.getId())) ||
                   (examination.getOpdDoctor() != null && 
                    examination.getOpdDoctor().getId().equals(user.getId()));
        }
        
        // Staff cannot process refunds
        return false;
    }

    @Override
    public List<PaymentEntry> getRefundablePayments(Long examinationId) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
        
        if (examination.getPaymentEntries() == null) {
            return List.of();
        }
        
        return examination.getPaymentEntries().stream()
            .filter(entry -> entry.getPaymentNotes() != PaymentNotes.REFUND)
            .filter(entry -> entry.getAmount() > 0)
            .collect(Collectors.toList());
    }
}
package com.example.logindemo.service.impl;

import com.example.logindemo.dto.PaymentTransactionDTO;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.PaymentNotes;
import com.example.logindemo.repository.PaymentEntryRepository;
import com.example.logindemo.service.PaymentManagementService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class PaymentManagementServiceImpl implements PaymentManagementService {

    @Autowired
    private PaymentEntryRepository paymentEntryRepository;
    
    @Autowired
    private EntityManager entityManager;

    @Override
    public Page<PaymentTransactionDTO> searchPaymentTransactions(
            String searchTerm,
            String searchType,
            String paymentMode,
            String paymentStatus,
            LocalDateTime startDate,
            LocalDateTime endDate,
            Pageable pageable) {
        
        log.info("Searching payment transactions with term: {}, type: {}, mode: {}, status: {}", 
                searchTerm, searchType, paymentMode, paymentStatus);
        
        StringBuilder queryBuilder = new StringBuilder();
        queryBuilder.append("SELECT pe.id as paymentId, ")
                   .append("pe.amount, pe.payment_mode as paymentMode, pe.payment_notes as paymentNotes, ")
                   .append("pe.transaction_type as transactionType, ")
                   .append("pe.payment_date as paymentDate, pe.remarks, pe.transaction_reference as transactionReference, ")
                   .append("pe.refund_type as refundType, pe.refund_reason as refundReason, ")
                   .append("pe.original_payment_id as originalPaymentId, pe.refund_approval_date as refundApprovalDate, ")
                   .append("CONCAT(refund_user.first_name, ' ', refund_user.last_name) as refundApprovedByName, ")
                   .append("tce.id as examinationId, tce.tooth_number as toothNumber, ")
                   .append("p.procedure_name as procedureName, tce.total_procedure_amount as totalProcedureAmount, ")
                   .append("tce.total_paid_amount as totalPaidAmount, tce.total_refunded_amount as totalRefundedAmount, ")
                   .append("tce.net_paid_amount as netPaidAmount, tce.procedure_status as procedureStatus, ")
                   .append("tce.examination_date as examinationDate, ")
                   .append("pat.id as patientId, CONCAT(pat.first_name, ' ', pat.last_name) as patientName, ")
                   .append("pat.registration_code as patientRegistrationCode, pat.phone_number as patientPhone, ")
                   .append("pat.email as patientEmail, ")
                   .append("CONCAT(doc.first_name, ' ', doc.last_name) as assignedDoctorName, ")
                   .append("CONCAT(opd.first_name, ' ', opd.last_name) as opdDoctorName, ")
                   .append("c.clinic_name as clinicName, ")
                   .append("CONCAT(rec_user.first_name, ' ', rec_user.last_name) as recordedByName ")
                   .append("FROM payment_entry pe ")
                   .append("LEFT JOIN toothclinicalexamination tce ON pe.examination_id = tce.id ")
                   .append("LEFT JOIN patients pat ON tce.patient_id = pat.id ")
                   .append("LEFT JOIN procedure_prices p ON tce.procedure_id = p.id ")
                   .append("LEFT JOIN users doc ON tce.assigned_user_id = doc.id ")
                   .append("LEFT JOIN users opd ON tce.opd_doctor_id = opd.id ")
                   .append("LEFT JOIN clinics c ON pat.registered_clinic = c.id ")
                   .append("LEFT JOIN users rec_user ON pe.recorded_by = rec_user.id ")
                   .append("LEFT JOIN users refund_user ON pe.refund_approved_by = refund_user.id ")
                   .append("WHERE 1=1 ");

        // Add search filters
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            if ("EXAMINATION_ID".equals(searchType)) {
                queryBuilder.append("AND tce.id = :searchTerm ");
            } else if ("PATIENT_ID".equals(searchType)) {
                queryBuilder.append("AND pat.id = :searchTerm ");
            } else if ("REGISTRATION_CODE".equals(searchType)) {
                queryBuilder.append("AND LOWER(pat.registration_code) LIKE LOWER(:searchTermLike) ");
            } else if ("PATIENT_NAME".equals(searchType)) {
                queryBuilder.append("AND (LOWER(pat.first_name) LIKE LOWER(:searchTermLike) ")
                           .append("OR LOWER(pat.last_name) LIKE LOWER(:searchTermLike) ")
                           .append("OR LOWER(CONCAT(pat.first_name, ' ', pat.last_name)) LIKE LOWER(:searchTermLike)) ");
            } else if ("TRANSACTION_REF".equals(searchType)) {
                queryBuilder.append("AND LOWER(pe.transaction_reference) LIKE LOWER(:searchTermLike) ");
            }
        }

        if (paymentMode != null && !paymentMode.isEmpty() && !"ALL".equals(paymentMode)) {
            queryBuilder.append("AND pe.payment_mode = :paymentMode ");
        }

        if (paymentStatus != null && !paymentStatus.isEmpty() && !"ALL".equals(paymentStatus)) {
            if ("REFUND".equals(paymentStatus)) {
                queryBuilder.append("AND pe.transaction_type = 'REFUND' ");
            } else if ("PAYMENT".equals(paymentStatus)) {
                queryBuilder.append("AND pe.transaction_type = 'CAPTURE' ");
            }
        }

        if (startDate != null) {
            queryBuilder.append("AND pe.payment_date >= :startDate ");
        }

        if (endDate != null) {
            queryBuilder.append("AND pe.payment_date <= :endDate ");
        }

        queryBuilder.append("ORDER BY pe.payment_date DESC ");

        Query query = entityManager.createNativeQuery(queryBuilder.toString());

        // Set parameters
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            if ("EXAMINATION_ID".equals(searchType) || "PATIENT_ID".equals(searchType)) {
                try {
                    query.setParameter("searchTerm", Long.parseLong(searchTerm.trim()));
                } catch (NumberFormatException e) {
                    log.warn("Invalid numeric search term: {}", searchTerm);
                    return new PageImpl<>(List.of(), pageable, 0);
                }
            } else {
                query.setParameter("searchTermLike", "%" + searchTerm.trim() + "%");
            }
        }

        if (paymentMode != null && !paymentMode.isEmpty() && !"ALL".equals(paymentMode)) {
            query.setParameter("paymentMode", paymentMode);
        }

        if (startDate != null) {
            query.setParameter("startDate", startDate);
        }

        if (endDate != null) {
            query.setParameter("endDate", endDate);
        }

        // Get total count
        String countQuery = queryBuilder.toString().replaceFirst("SELECT.*FROM", "SELECT COUNT(*) FROM");
        Query countQ = entityManager.createNativeQuery(countQuery);
        
        // Set same parameters for count query
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            if ("EXAMINATION_ID".equals(searchType) || "PATIENT_ID".equals(searchType)) {
                try {
                    countQ.setParameter("searchTerm", Long.parseLong(searchTerm.trim()));
                } catch (NumberFormatException e) {
                    return new PageImpl<>(List.of(), pageable, 0);
                }
            } else {
                countQ.setParameter("searchTermLike", "%" + searchTerm.trim() + "%");
            }
        }
        if (paymentMode != null && !paymentMode.isEmpty() && !"ALL".equals(paymentMode)) {
            countQ.setParameter("paymentMode", paymentMode);
        }
        if (startDate != null) {
            countQ.setParameter("startDate", startDate);
        }
        if (endDate != null) {
            countQ.setParameter("endDate", endDate);
        }

        long total = ((Number) countQ.getSingleResult()).longValue();

        // Apply pagination
        query.setFirstResult((int) pageable.getOffset());
        query.setMaxResults(pageable.getPageSize());

        @SuppressWarnings("unchecked")
        List<Object[]> results = query.getResultList();
        
        List<PaymentTransactionDTO> dtos = results.stream()
                .map(this::mapToPaymentTransactionDTO)
                .collect(Collectors.toList());

        return new PageImpl<>(dtos, pageable, total);
    }

    @Override
    public PaymentTransactionDTO getPaymentTransactionById(Long paymentId) {
        PaymentEntry payment = paymentEntryRepository.findById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        return mapToPaymentTransactionDTO(payment);
    }

    @Override
    public List<PaymentTransactionDTO> getPaymentTransactionsByExaminationId(Long examinationId) {
        List<PaymentEntry> payments = paymentEntryRepository.findByExaminationIdOrderByPaymentDateDesc(examinationId);
        return payments.stream()
                .map(this::mapToPaymentTransactionDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<PaymentTransactionDTO> getPaymentTransactionsByPatientId(Long patientId) {
        log.info("=== SERVICE LAYER DEBUG ===");
        log.info("Fetching payment transactions for patient ID: {}", patientId);
        
        List<PaymentEntry> payments = paymentEntryRepository.findByExaminationPatientIdOrderByPaymentDateDesc(patientId);
        
        log.info("Found {} payment entries from repository", payments != null ? payments.size() : 0);
        
        if (payments != null && !payments.isEmpty()) {
            log.info("Payment entry details:");
            for (int i = 0; i < payments.size(); i++) {
                PaymentEntry payment = payments.get(i);
                log.info("Payment {}: ID={}, Amount={}, AmountType={}, TransactionType={}, Refund={}, PaymentDate={}", 
                    i + 1,
                    payment.getId(),
                    payment.getAmount(),
                    payment.getAmount() != null ? payment.getAmount().getClass().getSimpleName() : "null",
                    payment.getTransactionType(),
                    payment.isRefund(),
                    payment.getPaymentDate()
                );
                
                if (payment.getExamination() != null && payment.getExamination().getProcedure() != null) {
                    log.info("  - Procedure: {}", payment.getExamination().getProcedure().getProcedureName());
                }
            }
        }
        
        List<PaymentTransactionDTO> result = payments.stream()
                .map(this::mapToPaymentTransactionDTO)
                .collect(Collectors.toList());
        
        log.info("Mapped to {} DTOs", result.size());
        
        if (!result.isEmpty()) {
            log.info("DTO mapping results:");
            for (int i = 0; i < result.size(); i++) {
                PaymentTransactionDTO dto = result.get(i);
                log.info("DTO {}: PaymentId={}, Amount={}, AmountType={}, Refund={}, ProcedureName={}", 
                    i + 1,
                    dto.getPaymentId(),
                    dto.getAmount(),
                    dto.getAmount() != null ? dto.getAmount().getClass().getSimpleName() : "null",
                    dto.isRefund(),
                    dto.getProcedureName()
                );
            }
        }
        
        log.info("=== END SERVICE LAYER DEBUG ===");
        return result;
    }

    @Override
    public boolean canRefundPayment(Long paymentId) {
        PaymentEntry payment = paymentEntryRepository.findById(paymentId).orElse(null);
        if (payment == null || payment.isRefund()) {
            return false;
        }
        
        // Check if already fully refunded
        List<PaymentEntry> refunds = paymentEntryRepository.findByOriginalPaymentId(paymentId);
        double totalRefunded = refunds.stream()
                .filter(r -> r.getPaymentNotes() == PaymentNotes.REFUND)
                .mapToDouble(PaymentEntry::getAmount)
                .sum();
        
        return Math.abs(totalRefunded) < payment.getAmount();
    }

    @Override
    public List<PaymentTransactionDTO> getRefundHistory(Long originalPaymentId) {
        List<PaymentEntry> refunds = paymentEntryRepository.findByOriginalPaymentId(originalPaymentId);
        return refunds.stream()
                .map(this::mapToPaymentTransactionDTO)
                .collect(Collectors.toList());
    }

    private PaymentTransactionDTO mapToPaymentTransactionDTO(Object[] row) {
        PaymentTransactionDTO dto = new PaymentTransactionDTO();
        
        int i = 0;
        dto.setPaymentId(((Number) row[i++]).longValue());
        
        // Get the raw amount and transaction type
        Double rawAmount = (Double) row[i++];
        String transactionType = (String) row[4]; // transaction_type is at index 4
        
        // Handle amount properly for capture vs refund
        if ("REFUND".equals(transactionType)) {
            // Refunds should be displayed as negative amounts
            dto.setAmount(-Math.abs(rawAmount));
        } else {
            // Captures (payments) should be displayed as positive amounts
            dto.setAmount(Math.abs(rawAmount));
        }
        
        dto.setPaymentMode(row[i] != null ? com.example.logindemo.model.PaymentMode.valueOf((String) row[i]) : null); i++;
        dto.setPaymentNotes(row[i] != null ? PaymentNotes.valueOf((String) row[i]) : null); i++;
        i++; // Skip transaction_type as we already used it
        dto.setPaymentDate((LocalDateTime) row[i++]);
        dto.setRemarks((String) row[i++]);
        dto.setTransactionReference((String) row[i++]);
        dto.setRefundType(row[i] != null ? com.example.logindemo.model.RefundType.valueOf((String) row[i]) : null); i++;
        dto.setRefundReason((String) row[i++]);
        dto.setOriginalPaymentId(row[i] != null ? ((Number) row[i]).longValue() : null); i++;
        dto.setRefundApprovalDate((LocalDateTime) row[i++]);
        dto.setRefundApprovedByName((String) row[i++]);
        dto.setExaminationId(row[i] != null ? ((Number) row[i]).longValue() : null); i++;
        dto.setToothNumber((String) row[i++]);
        dto.setProcedureName((String) row[i++]);
        dto.setTotalProcedureAmount((Double) row[i++]);
        dto.setTotalPaidAmount((Double) row[i++]);
        dto.setTotalRefundedAmount((Double) row[i++]);
        dto.setNetPaidAmount((Double) row[i++]);
        dto.setProcedureStatus((String) row[i++]);
        dto.setExaminationDate((LocalDateTime) row[i++]);
        dto.setPatientId(row[i] != null ? ((Number) row[i]).longValue() : null); i++;
        dto.setPatientName((String) row[i++]);
        dto.setPatientRegistrationCode((String) row[i++]);
        dto.setPatientPhone((String) row[i++]);
        dto.setPatientEmail((String) row[i++]);
        dto.setAssignedDoctorName((String) row[i++]);
        dto.setOpdDoctorName((String) row[i++]);
        dto.setClinicName((String) row[i++]);
        dto.setRecordedByName((String) row[i++]);
        
        // Set calculated fields based on transaction type
        dto.setRefund("REFUND".equals(transactionType));
        dto.setCanRefund(!"REFUND".equals(transactionType) && canRefundPayment(dto.getPaymentId()));
        
        // Set payment status based on transaction type and refund status
        if ("REFUND".equals(transactionType)) {
            if (dto.getRefundType() == com.example.logindemo.model.RefundType.FULL) {
                dto.setPaymentStatus("FULL_REFUND");
            } else {
                dto.setPaymentStatus("PARTIAL_REFUND");
            }
        } else {
            // For captures, check if there are any refunds against this payment
            if (dto.getTotalRefundedAmount() != null && dto.getTotalRefundedAmount() > 0) {
                if (dto.getTotalRefundedAmount().equals(dto.getTotalPaidAmount())) {
                    dto.setPaymentStatus("FULLY_REFUNDED");
                } else {
                    dto.setPaymentStatus("PARTIALLY_REFUNDED");
                }
            } else {
                dto.setPaymentStatus("PAID");
            }
        }
        
        return dto;
    }

    private PaymentTransactionDTO mapToPaymentTransactionDTO(PaymentEntry payment) {
        PaymentTransactionDTO dto = new PaymentTransactionDTO();
        
        dto.setPaymentId(payment.getId());
        
        // Handle amount properly for capture vs refund
        if (payment.isRefund()) {
            // Refunds should be displayed as negative amounts
            dto.setAmount(-Math.abs(payment.getAmount()));
        } else {
            // Captures (payments) should be displayed as positive amounts
            dto.setAmount(Math.abs(payment.getAmount()));
        }
        
        dto.setPaymentMode(payment.getPaymentMode());
        dto.setPaymentNotes(payment.getPaymentNotes());
        dto.setPaymentDate(payment.getPaymentDate());
        dto.setRemarks(payment.getRemarks());
        dto.setTransactionReference(payment.getTransactionReference());
        dto.setRefundType(payment.getRefundType());
        dto.setRefundReason(payment.getRefundReason());
        dto.setOriginalPaymentId(payment.getOriginalPayment() != null ? payment.getOriginalPayment().getId() : null);
        dto.setRefundApprovalDate(payment.getRefundApprovalDate());
        dto.setRefundApprovedByName(payment.getRefundApprovedBy() != null ? 
                payment.getRefundApprovedBy().getFirstName() + " " + payment.getRefundApprovedBy().getLastName() : null);
        
        if (payment.getExamination() != null) {
            dto.setExaminationId(payment.getExamination().getId());
            dto.setToothNumber(payment.getExamination().getToothNumber() != null ? 
                    payment.getExamination().getToothNumber().toString() : null);
            dto.setProcedureName(payment.getExamination().getProcedure() != null ? 
                    payment.getExamination().getProcedure().getProcedureName() : null);
            dto.setTotalProcedureAmount(payment.getExamination().getTotalProcedureAmount());
            dto.setTotalPaidAmount(payment.getExamination().getTotalPaidAmount());
            dto.setTotalRefundedAmount(payment.getExamination().getTotalRefundedAmount());
            dto.setNetPaidAmount(payment.getExamination().getNetPaidAmount());
            dto.setProcedureStatus(payment.getExamination().getProcedureStatus() != null ? 
                    payment.getExamination().getProcedureStatus().toString() : null);
            dto.setExaminationDate(payment.getExamination().getExaminationDate());
            
            if (payment.getExamination().getPatient() != null) {
                dto.setPatientId(payment.getExamination().getPatient().getId());
                dto.setPatientName(payment.getExamination().getPatient().getFirstName() + " " + 
                        payment.getExamination().getPatient().getLastName());
                dto.setPatientRegistrationCode(payment.getExamination().getPatient().getRegistrationCode());
                dto.setPatientPhone(payment.getExamination().getPatient().getPhoneNumber());
                dto.setPatientEmail(payment.getExamination().getPatient().getEmail());
                
                if (payment.getExamination().getPatient().getRegisteredClinic() != null) {
                    dto.setClinicName(payment.getExamination().getPatient().getRegisteredClinic().getClinicName());
                }
            }
            
            if (payment.getExamination().getAssignedDoctor() != null) {
                dto.setAssignedDoctorName(payment.getExamination().getAssignedDoctor().getFirstName() + " " + 
                        payment.getExamination().getAssignedDoctor().getLastName());
            }
            
            if (payment.getExamination().getOpdDoctor() != null) {
                dto.setOpdDoctorName(payment.getExamination().getOpdDoctor().getFirstName() + " " + 
                        payment.getExamination().getOpdDoctor().getLastName());
            }
        }
        
        if (payment.getRecordedBy() != null) {
            dto.setRecordedByName(payment.getRecordedBy().getFirstName() + " " + payment.getRecordedBy().getLastName());
        }
        
        // Set calculated fields based on transaction type
        dto.setRefund(payment.isRefund());
        dto.setCanRefund(!payment.isRefund() && canRefundPayment(payment.getId()));
        
        // Set payment status based on transaction type and refund status
        if (payment.isRefund()) {
            if (payment.getRefundType() == com.example.logindemo.model.RefundType.FULL) {
                dto.setPaymentStatus("FULL_REFUND");
            } else {
                dto.setPaymentStatus("PARTIAL_REFUND");
            }
        } else {
            // For captures, check if there are any refunds against this payment
            if (dto.getTotalRefundedAmount() != null && dto.getTotalRefundedAmount() > 0) {
                if (dto.getTotalRefundedAmount().equals(dto.getTotalPaidAmount())) {
                    dto.setPaymentStatus("FULLY_REFUNDED");
                } else {
                    dto.setPaymentStatus("PARTIALLY_REFUNDED");
                }
            } else {
                dto.setPaymentStatus("PAID");
            }
        }
        
        return dto;
    }
}
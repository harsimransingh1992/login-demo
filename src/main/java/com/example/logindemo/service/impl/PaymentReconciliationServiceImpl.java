package com.example.logindemo.service.impl;

import com.example.logindemo.dto.ReconciliationResponse;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.PaymentReconciliationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class PaymentReconciliationServiceImpl implements PaymentReconciliationService {

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Override
    @Transactional(readOnly = true)
    public ReconciliationResponse getReconciliationData(LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.plusDays(1).atStartOfDay();

        // Get all examinations
        List<ToothClinicalExamination> examinations = examinationRepository.findAll();

        ReconciliationResponse response = new ReconciliationResponse();
        
        // Calculate total collections (sum of all payment entries in the date range)
        double totalCollections = examinations.stream()
            .flatMap(exam -> exam.getPaymentEntries() != null ? exam.getPaymentEntries().stream() : java.util.stream.Stream.empty())
            .filter(entry -> entry.getPaymentDate() != null &&
                !entry.getPaymentDate().isBefore(startOfDay) && entry.getPaymentDate().isBefore(endOfDay))
            .mapToDouble(PaymentEntry::getAmount)
                .sum();
        response.setTotalCollections(totalCollections);

        // Calculate total transactions (number of payment entries in the date range)
        int totalTransactions = (int) examinations.stream()
            .flatMap(exam -> exam.getPaymentEntries() != null ? exam.getPaymentEntries().stream() : java.util.stream.Stream.empty())
            .filter(entry -> entry.getPaymentDate() != null &&
                !entry.getPaymentDate().isBefore(startOfDay) && entry.getPaymentDate().isBefore(endOfDay))
            .count();
        response.setTotalTransactions(totalTransactions);

        // Calculate pending amount (examinations with no payment entries in the date range)
        double pendingAmount = examinations.stream()
            .filter(exam -> exam.getPaymentEntries() == null ||
                exam.getPaymentEntries().stream().noneMatch(entry ->
                    entry.getPaymentDate() != null &&
                    !entry.getPaymentDate().isBefore(startOfDay) && entry.getPaymentDate().isBefore(endOfDay)))
            .filter(exam -> exam.getProcedure() != null && exam.getProcedure().getPrice() != null)
            .mapToDouble(exam -> exam.getProcedure().getPrice())
                .sum();
        response.setPendingAmount(pendingAmount);

        // Calculate payment mode breakdown (sum by mode for payment entries in the date range)
        Map<String, Double> paymentModeBreakdown = examinations.stream()
            .flatMap(exam -> exam.getPaymentEntries() != null ? exam.getPaymentEntries().stream() : java.util.stream.Stream.empty())
            .filter(entry -> entry.getPaymentDate() != null &&
                !entry.getPaymentDate().isBefore(startOfDay) && entry.getPaymentDate().isBefore(endOfDay))
            .filter(entry -> entry.getPaymentMode() != null && entry.getAmount() != null)
                .collect(Collectors.groupingBy(
                entry -> entry.getPaymentMode().toString(),
                Collectors.summingDouble(PaymentEntry::getAmount)
                ));
        response.setPaymentModeBreakdown(paymentModeBreakdown);

        // Add transaction details (one per payment entry in the date range)
        List<ReconciliationResponse.TransactionDTO> transactions = examinations.stream()
            .flatMap(exam -> {
                if (exam.getPaymentEntries() == null) return java.util.stream.Stream.empty();
                return exam.getPaymentEntries().stream()
                    .filter(entry -> entry.getPaymentDate() != null &&
                        !entry.getPaymentDate().isBefore(startOfDay) && entry.getPaymentDate().isBefore(endOfDay))
                    .map(entry -> {
                    ReconciliationResponse.TransactionDTO dto = new ReconciliationResponse.TransactionDTO();
                    // Set examination ID
                        dto.setExaminationId(exam.getId());
                    // Set patient name
                        if (exam.getPatient() != null) {
                    String firstName = exam.getPatient().getFirstName() != null ? exam.getPatient().getFirstName() : "";
                    String lastName = exam.getPatient().getLastName() != null ? exam.getPatient().getLastName() : "";
                    dto.setPatientName((firstName + " " + lastName).trim());
                        } else {
                            dto.setPatientName("N/A");
                        }
                    // Set procedure name
                        dto.setProcedureName(exam.getProcedure() != null && exam.getProcedure().getProcedureName() != null ?
                        exam.getProcedure().getProcedureName() : "N/A");
                    // Set amount
                        dto.setAmount(entry.getAmount() != null ? entry.getAmount() : 0.0);
                    // Set payment mode
                        dto.setPaymentMode(entry.getPaymentMode() != null ? entry.getPaymentMode().toString() : "N/A");
                        // Set status (always COMPLETED for now, or use entry status if added)
                        dto.setStatus("COMPLETED");
                    // Set collection date
                        dto.setCollectionDate(entry.getPaymentDate() != null ? entry.getPaymentDate().toString() : "");
                    return dto;
                    });
                })
                .collect(Collectors.toList());
        response.setTransactions(transactions);

        return response;
    }

    @Override
    @Transactional
    public boolean reconcilePayments(LocalDate date) {
        // No-op for now, as payment status is now tracked per PaymentEntry. Optionally, you can add a status field to PaymentEntry and update it here.
            return true;
    }
} 
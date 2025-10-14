package com.example.logindemo.service.impl;

import com.example.logindemo.dto.ReconciliationResponse;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.PaymentReconciliationService;
import com.example.logindemo.utils.PeriDeskUtils;
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

        // Get current user's clinic
        ClinicModel currentClinic = PeriDeskUtils.getCurrentClinicModel();
        
        // Get examinations filtered by current user's clinic
        List<ToothClinicalExamination> examinations = examinationRepository.findAll().stream()
            .filter(exam -> exam.getExaminationClinic() != null && 
                           exam.getExaminationClinic().getId().equals(currentClinic.getId()))
            .collect(Collectors.toList());

        ReconciliationResponse response = new ReconciliationResponse();

        // Collect payment entries for the day within the clinic
        List<PaymentEntry> dayEntries = examinations.stream()
            .flatMap(exam -> exam.getPaymentEntries() != null ? exam.getPaymentEntries().stream() : java.util.stream.Stream.empty())
            .filter(entry -> entry.getPaymentDate() != null &&
                !entry.getPaymentDate().isBefore(startOfDay) && entry.getPaymentDate().isBefore(endOfDay))
            .collect(Collectors.toList());

        // Calculate gross (captures/authorizations), refunds, and net collections
        double grossCollections = dayEntries.stream()
            .filter(entry -> entry.getTransactionType() != null &&
                    (entry.getTransactionType() == com.example.logindemo.model.TransactionType.CAPTURE ||
                     entry.getTransactionType() == com.example.logindemo.model.TransactionType.AUTHORIZATION))
            .mapToDouble(e -> e.getAmount() != null ? e.getAmount() : 0.0)
            .sum();

        double totalRefunds = dayEntries.stream()
            .filter(entry -> entry.getTransactionType() == com.example.logindemo.model.TransactionType.REFUND)
            .mapToDouble(e -> e.getAmount() != null ? e.getAmount() : 0.0)
            .sum();

        double netCollections = grossCollections - totalRefunds;
        response.setGrossCollections(grossCollections);
        response.setTotalRefunds(totalRefunds);
        response.setTotalCollections(netCollections);

        // Calculate total transactions (number of payment entries in the date range)
        int totalTransactions = dayEntries.size();
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
        Map<String, Double> paymentModeBreakdown = dayEntries.stream()
            .filter(entry -> entry.getPaymentMode() != null && entry.getAmount() != null)
            .collect(Collectors.groupingBy(
                entry -> entry.getPaymentMode().toString(),
                Collectors.summingDouble(entry -> {
                    double amt = entry.getAmount() != null ? entry.getAmount() : 0.0;
                    return entry.getTransactionType() == com.example.logindemo.model.TransactionType.REFUND ? -amt : amt;
                })
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
                    // Set patient name and registration code
                        if (exam.getPatient() != null) {
                    String firstName = exam.getPatient().getFirstName() != null ? exam.getPatient().getFirstName() : "";
                    String lastName = exam.getPatient().getLastName() != null ? exam.getPatient().getLastName() : "";
                    dto.setPatientName((firstName + " " + lastName).trim());
                            dto.setPatientRegistrationCode(exam.getPatient().getRegistrationCode() != null ? exam.getPatient().getRegistrationCode() : "N/A");
                        } else {
                            dto.setPatientName("N/A");
                            dto.setPatientRegistrationCode("N/A");
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
                    // Set transaction type
                        dto.setTransactionType(entry.getTransactionType() != null ? entry.getTransactionType().toString() : "CAPTURE");
                    // Set examination date
                        dto.setExaminationDate(exam.getExaminationDate() != null ? exam.getExaminationDate().toString() : "N/A");
                    // Set handler names
                        dto.setRecordedByName(entry.getRecordedBy() != null ?
                                ((entry.getRecordedBy().getFirstName() != null ? entry.getRecordedBy().getFirstName() : "") +
                                 " " +
                                 (entry.getRecordedBy().getLastName() != null ? entry.getRecordedBy().getLastName() : "")).trim()
                                : "N/A");
                        dto.setRefundApprovedByName(entry.getRefundApprovedBy() != null ?
                                ((entry.getRefundApprovedBy().getFirstName() != null ? entry.getRefundApprovedBy().getFirstName() : "") +
                                 " " +
                                 (entry.getRefundApprovedBy().getLastName() != null ? entry.getRefundApprovedBy().getLastName() : "")).trim()
                                : null);
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
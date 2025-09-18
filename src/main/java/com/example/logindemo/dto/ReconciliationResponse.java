package com.example.logindemo.dto;

import lombok.Data;
import java.util.List;
import java.util.Map;

@Data
public class ReconciliationResponse {
    private double totalCollections;
    private int totalTransactions;
    private double pendingAmount;
    private Map<String, Double> paymentModeBreakdown;
    private List<TransactionDTO> transactions;
    
    @Data
    public static class TransactionDTO {
        private Long examinationId;
        private String patientName;
        private String patientRegistrationCode;
        private String procedureName;
        private double amount;
        private String paymentMode;
        private String status;
        private String collectionDate;
        private String transactionType;
        private String examinationDate;
    }
} 
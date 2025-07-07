package com.example.logindemo.dto;

import com.example.logindemo.model.PaymentMode;
import java.util.Map;

public class PaymentCollectionRequest {
    private Long examinationId;
    private PaymentMode paymentMode;
    private String notes;
    private Map<String, String> paymentDetails;

    // Getters and Setters
    public Long getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(Long examinationId) {
        this.examinationId = examinationId;
    }

    public PaymentMode getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(PaymentMode paymentMode) {
        this.paymentMode = paymentMode;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Map<String, String> getPaymentDetails() {
        return paymentDetails;
    }

    public void setPaymentDetails(Map<String, String> paymentDetails) {
        this.paymentDetails = paymentDetails;
    }
} 
package com.example.logindemo.service;

import com.example.logindemo.dto.ReconciliationResponse;
import java.time.LocalDate;

public interface PaymentReconciliationService {
    ReconciliationResponse getReconciliationData(LocalDate date);
    boolean reconcilePayments(LocalDate date);
} 
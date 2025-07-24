package com.example.logindemo.service;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.ProcedureStatus;
import java.time.LocalDateTime;
import java.util.List;

public interface PaymentFilterService {
    List<ToothClinicalExamination> getPendingPaymentsByClinicAndDateRange(LocalDateTime startDate, LocalDateTime endDate, ProcedureStatus status, String clinicId);
    List<ToothClinicalExamination> getAllPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    List<ToothClinicalExamination> getPendingPaymentsByTreatmentStartDateAndClinic(LocalDateTime startDate, LocalDateTime endDate, String clinicId);
} 
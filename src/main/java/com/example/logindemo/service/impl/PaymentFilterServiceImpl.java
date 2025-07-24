package com.example.logindemo.service.impl;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.PaymentFilterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PaymentFilterServiceImpl implements PaymentFilterService {
    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Override
    public List<ToothClinicalExamination> getPendingPaymentsByClinicAndDateRange(LocalDateTime startDate, LocalDateTime endDate, ProcedureStatus status, String clinicId) {
        return examinationRepository.findByExaminationDateBetweenAndProcedureStatusAndExaminationClinic_ClinicId(startDate, endDate, status, clinicId);
    }

    @Override
    public List<ToothClinicalExamination> getAllPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return examinationRepository.findByExaminationDateBetween(startDate, endDate);
    }

    @Override
    public List<ToothClinicalExamination> getPendingPaymentsByTreatmentStartDateAndClinic(LocalDateTime startDate, LocalDateTime endDate, String clinicId) {
        List<ToothClinicalExamination> all = examinationRepository.findAll();
        return all.stream()
            .filter(exam -> exam.getExaminationClinic() != null && clinicId.equals(exam.getExaminationClinic().getClinicId()))
            .filter(exam -> exam.getTreatmentStartingDate() != null &&
                !exam.getTreatmentStartingDate().isBefore(startDate) &&
                !exam.getTreatmentStartingDate().isAfter(endDate))
            .filter(exam -> exam.getTotalProcedureAmount() != null &&
                exam.getTotalProcedureAmount() > (exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0))
            .toList();
    }
} 
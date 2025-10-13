package com.example.logindemo.service;

import com.example.logindemo.model.PaymentMode;
import com.example.logindemo.model.ToothClinicalExamination;

/**
 * Service interface for handling consultation charges collection
 */
public interface ConsultationChargesService {
    
    /**
     * Get consultation fee based on clinic tier and dental department
     * @param clinicId the clinic ID to get the tier from
     * @return the consultation fee amount
     */
    Double getConsultationFee(String clinicId);
    
    /**
     * Collect consultation charges for a patient
     * @param patientId the patient ID
     * @param consultationFee the consultation fee amount
     * @param paymentMode the payment mode
     * @param paymentNotes optional payment notes
     * @param treatingDoctorId the treating doctor ID (optional)
     * @return the created ToothClinicalExamination record
     */
    ToothClinicalExamination collectConsultationCharges(Long patientId, Double consultationFee, 
                                                       PaymentMode paymentMode, String paymentNotes, Long treatingDoctorId);

    /**
     * Find a recent consultation payment within the given days for a patient at a clinic
     * @param patientId the patient ID
     * @param clinicId the clinic ID
     * @param days the lookback window in days (e.g., 30)
     * @return the most recent matching examination if found, otherwise null
     */
    ToothClinicalExamination findRecentConsultationPayment(Long patientId, String clinicId, int days);
}
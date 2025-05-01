package com.example.logindemo.service;

import com.example.logindemo.dto.ToothClinicalExaminationDTO;

import java.util.List;

public interface ToothClinicalExaminationService {
    List<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientId(Long patientId);
    
    /**
     * Get tooth clinical examination by ID
     * @param id the examination ID
     * @return the ToothClinicalExaminationDTO or null if not found
     */
    ToothClinicalExaminationDTO getToothClinicalExaminationById(Long id);

    List<ToothClinicalExaminationDTO> getTodayAppointments();
}

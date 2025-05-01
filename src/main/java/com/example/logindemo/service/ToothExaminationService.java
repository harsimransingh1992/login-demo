package com.example.logindemo.service;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;

import java.util.List;
import java.util.Optional;

public interface ToothExaminationService {
    /**
     * Get all examinations for a specific patient
     * @param patientId The ID of the patient
     * @return List of tooth examinations
     */
    List<ToothClinicalExaminationDTO> getExaminationsByPatientId(Long patientId);

    /**
     * Get a specific examination by its ID
     * @param id The ID of the examination
     * @return Optional containing the examination if found
     */
    Optional<ToothClinicalExaminationDTO> getExaminationById(Long id);

    /**
     * Save or update a tooth examination
     * @param examinationDTO The examination data to save
     * @return The saved examination
     */
    ToothClinicalExaminationDTO saveExamination(ToothClinicalExaminationDTO examinationDTO);

    /**
     * Update the treatment start date for an examination
     * @param examinationId The ID of the examination
     * @param treatmentStartDate The new treatment start date
     * @return The updated examination
     */
    ToothClinicalExaminationDTO updateTreatmentDate(Long examinationId, String treatmentStartDate);

    /**
     * Assign a doctor to an examination
     * @param examinationId The ID of the examination
     * @param doctorId The ID of the doctor to assign (null to remove assignment)
     * @return The updated examination
     */
    ToothClinicalExaminationDTO assignDoctor(Long examinationId, Long doctorId);
} 
package com.example.logindemo.service;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.User;

import java.util.List;

public interface PatientService {
    void checkInPatient(Long id, String currentClinicId);
    void uncheckInPatient(Long id);

    void registerPatient(PatientDTO patient);

    List<PatientDTO> getAllPatients();
    List<PatientDTO> getCheckedInPatients();
    User attachCurrentClinicModel(String clinicId);

    void saveExamination(ToothClinicalExaminationDTO request);
    
    /**
     * Update an existing examination
     * @param request the examination data to update
     */
    void updateExamination(ToothClinicalExaminationDTO request);
    
    void assignDoctorToExamination(Long examinationId, Long doctorId);
    
    /**
     * Convert a Patient entity to a PatientDTO
     * @param patient the Patient entity to convert
     * @return the corresponding PatientDTO
     */
    PatientDTO convertToDTO(Patient patient);
    
    /**
     * Update an existing patient
     * @param patient the patient data to update
     */
    void updatePatient(PatientDTO patient);
}

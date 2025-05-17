package com.example.logindemo.service;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.User;
import org.springframework.web.multipart.MultipartFile;

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
    
    /**
     * Check if a patient with the same first name and phone number already exists
     * @param firstName the patient's first name
     * @param phoneNumber the patient's phone number
     * @return true if a duplicate exists, false otherwise
     */
    boolean isDuplicatePatient(String firstName, String phoneNumber);
    
    /**
     * Handle profile picture upload for a patient
     * @param file the profile picture file
     * @param patientId the ID of the patient (null for new patients)
     * @return the path where the file was stored
     */
    String handleProfilePictureUpload(MultipartFile file, String patientId);
}

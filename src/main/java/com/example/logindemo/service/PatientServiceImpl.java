package com.example.logindemo.service;

import com.example.logindemo.dto.CheckInRecordDTO;
import com.example.logindemo.dto.OccupationDTO;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.repository.DoctorDetailRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.util.PatientMapper;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@Component("patientService")
public class PatientServiceImpl implements PatientService{

    @Resource(name="patientRepository")
    private PatientRepository patientRepository;

    @Resource(name = "modelMapper")
    private ModelMapper modelMapper;
    
    @Resource
    private PatientMapper patientMapper;

    @Resource
    UserRepository userRepository;

    @Resource(name = "checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;

    @Resource(name="toothClinicalExaminationRepository")
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Resource(name="doctorDetailRepository")
    private DoctorDetailRepository doctorDetailRepository;

    @Resource(name="fileStorageService")
    private FileStorageService fileStorageService;


    @Override
    public void checkInPatient(Long patientId, String currentClinicId) {
        Optional<Patient> patients = patientRepository.findById(patientId);
        final User currentClinicModel = attachCurrentClinicModel(currentClinicId);
        patients.ifPresent(patient -> {
            patient.setCheckedIn(true);
            addCheckInRecordOnPatient(currentClinicModel,patient);//add the logs for check-ins
            patientRepository.save(patient);
        });
    }

    private void addCheckInRecordOnPatient(@NonNull User currentClinicModel, @NonNull Patient patient) {
        CheckInRecord checkInRecord = new CheckInRecord();
        checkInRecord.setCheckInClinic(currentClinicModel);
        checkInRecord.setCheckInTime(LocalDateTime.now());
        checkInRecord.setPatient(patient);
        checkInRecordRepository.save(checkInRecord);
        patient.getPatientCheckIns().add(checkInRecord);
        patient.setCurrentCheckInRecord(checkInRecord);
        patientRepository.save(patient);
        log.info("CheckIn recordID: {} added to patientID: {} ",checkInRecord.getId(), patient.getId());
    }

    @Override
    public void uncheckInPatient(Long patientId) {
        try {
            // Try to find the patient using getPatientsById which should return a single patient
            Patient patient = patientRepository.getPatientsById(patientId);
            if (patient != null) {
                patient.setCheckedIn(false);
                
                // Set check-out time on the current check-in record
                if (patient.getCurrentCheckInRecord() != null) {
                    patient.getCurrentCheckInRecord().setCheckOutTime(LocalDateTime.now());
                    checkInRecordRepository.save(patient.getCurrentCheckInRecord());
                }
                patient.setCurrentCheckInRecord(null);
                patientRepository.save(patient);
                log.info("Successfully unchecked patient with ID: {}", patientId);
            } else {
                log.error("No patient found with ID: {}", patientId);
            }
        } catch (Exception e) {
            log.error("Error while unchecking patient with ID: {}. Error: {}", patientId, e.getMessage());
            
            // Fallback to the findById method
            try {
                Optional<Patient> patientOpt = patientRepository.findById(patientId);
                if (patientOpt.isPresent()) {
                    Patient patient = patientOpt.get();
                    patient.setCheckedIn(false);
                    
                    // Set check-out time on the current check-in record
                    if (patient.getCurrentCheckInRecord() != null) {
                        patient.getCurrentCheckInRecord().setCheckOutTime(LocalDateTime.now());
                        checkInRecordRepository.save(patient.getCurrentCheckInRecord());
                    }
                    patient.setCurrentCheckInRecord(null);
                    patientRepository.save(patient);
                    log.info("Successfully unchecked patient with ID using fallback method: {}", patientId);
                }
            } catch (Exception ex) {
                log.error("Fallback method also failed for patient ID: {}. Error: {}", patientId, ex.getMessage());
            }
        }
    }

    @Override
    public void registerPatient(PatientDTO patientDTO) {
        log.info("Registering new patient: {}", patientDTO.getFirstName());
        try {
            // Convert PatientDTO to Patient entity
            Patient patient = new Patient();
            patient.setFirstName(patientDTO.getFirstName());
            patient.setLastName(patientDTO.getLastName());
            patient.setDateOfBirth(patientDTO.getDateOfBirth());
            patient.setGender(patientDTO.getGender());
            patient.setPhoneNumber(patientDTO.getPhoneNumber());
            patient.setEmail(patientDTO.getEmail());
            patient.setStreetAddress(patientDTO.getStreetAddress());
            patient.setCity(patientDTO.getCity());
            patient.setState(patientDTO.getState());
            patient.setPincode(patientDTO.getPincode());
            patient.setMedicalHistory(patientDTO.getMedicalHistory());
            patient.setEmergencyContactName(patientDTO.getEmergencyContactName());
            patient.setEmergencyContactPhoneNumber(patientDTO.getEmergencyContactPhoneNumber());
            
            
            // Handle occupation conversion
            if (patientDTO.getOccupation() != null) {
                String occupationName;
                occupationName = patientDTO.getOccupation().getName();

                try {
                    patient.setOccupation(Occupation.valueOf(occupationName));
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid occupation value: {}", occupationName);
                    patient.setOccupation(Occupation.OTHER);
                }
            }
            
            // Set referral model
            if (patientDTO.getReferral() != null) {
                try {
                    patient.setReferralModel(ReferralModel.valueOf(patientDTO.getReferral().getName()));
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid referral model value: {}", patientDTO.getReferral().getName());
                    patient.setReferralModel(ReferralModel.OTHER);
                }
            }
            
            // Set registration date
            patient.setRegistrationDate(new Date());
            
            // Save the patient
            patientRepository.save(patient);
            log.info("Successfully registered patient with ID: {}", patient.getId());
        } catch (Exception e) {
            log.error("Error registering patient: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to register patient: " + e.getMessage(), e);
        }
    }

    @Override
    public List<PatientDTO> getAllPatients() {
        List<Patient> patients = patientRepository.findAll();
        return patients.stream().map(patientMapper::toDto).toList();
    }

    @Override
    public List<PatientDTO> getCheckedInPatients() {
        List<Patient> waitingPatients = patientRepository.findByCheckedInTrue();
        
        // Fix any checked-in patients without check-in records
        for (Patient patient : waitingPatients) {
            if (patient.getCurrentCheckInRecord() == null) {
                fixMissingCheckInRecord(patient);
            }
        }
        
        return waitingPatients.stream().map(patientMapper::toDto).toList();
    }

    /**
     * Create a check-in record for a patient that is marked as checked in but doesn't have a record
     */
    private void fixMissingCheckInRecord(Patient patient) {
        log.warn("Found patient ID: {} marked as checked in but without a check-in record. Creating one now.", patient.getId());
        User clinic = userRepository.findAll().stream().findFirst().orElse(null);
        if (clinic != null) {
            CheckInRecord checkInRecord = new CheckInRecord();
            checkInRecord.setCheckInClinic(clinic);
            checkInRecord.setCheckInTime(LocalDateTime.now());
            checkInRecord.setPatient(patient);
            checkInRecordRepository.save(checkInRecord);
            patient.getPatientCheckIns().add(checkInRecord);
            patient.setCurrentCheckInRecord(checkInRecord);
            patientRepository.save(patient);
            log.info("Created missing CheckIn record ID: {} for patient ID: {}", checkInRecord.getId(), patient.getId());
        } else {
            log.error("Cannot create check-in record for patient ID: {} - no clinic found", patient.getId());
        }
    }

    @Override
    public User attachCurrentClinicModel(String clinicId) {
        Optional<User> user = userRepository.findByUsername(clinicId);
        return user.orElse(null);
    }

    @Override
    public void saveExamination(ToothClinicalExaminationDTO request) {
        try {
            final ToothClinicalExamination toothClinicalExamination = modelMapper.map(request, ToothClinicalExamination.class);
            Optional<Patient> patients = patientRepository.findById(request.getPatientId());
            if (patients.isPresent()) {
                toothClinicalExamination.setPatient(patients.get());
                toothClinicalExamination.setExaminationDate(LocalDateTime.now());
                
                // Get current clinic user and set it as examination clinic
                String currentClinicUsername = PeriDeskUtils.getCurrentClinicUserName();
                Optional<User> currentClinic = userRepository.findByUsername(currentClinicUsername);
                if (currentClinic.isPresent()) {
                    toothClinicalExamination.setExaminationClinic(currentClinic.get());
                    log.info("Setting examination clinic to: {}", currentClinicUsername);
                } else {
                    log.warn("Could not find clinic with username: {}", currentClinicUsername);
                }
                
                toothClinicalExaminationRepository.save(toothClinicalExamination);
                log.info("Successfully saved examination for tooth: {} of patient: {}", 
                        toothClinicalExamination.getToothNumber(), request.getPatientId());
            } else {
                log.error("Patient not found with ID: {}", request.getPatientId());
            }
        }
        catch (Exception e) {
            log.error("Error saving examination: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to save examination: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateExamination(ToothClinicalExaminationDTO request) {
        try {
            // Find the existing examination
            Optional<ToothClinicalExamination> examinationOpt = toothClinicalExaminationRepository.findById(request.getId());
            if (!examinationOpt.isPresent()) {
                throw new IllegalArgumentException("Examination not found with ID: " + request.getId());
            }
            
            ToothClinicalExamination examination = examinationOpt.get();
            
            // Update only the fields that can be changed
            if (request.getToothSurface() != null) {
                examination.setToothSurface(request.getToothSurface());
            }
            if (request.getToothCondition() != null) {
                examination.setToothCondition(request.getToothCondition());
            }
            if (request.getExistingRestoration() != null) {
                examination.setExistingRestoration(request.getExistingRestoration());
            }
            if (request.getPocketDepth() != null) {
                examination.setPocketDepth(request.getPocketDepth());
            }
            if (request.getBleedingOnProbing() != null) {
                examination.setBleedingOnProbing(request.getBleedingOnProbing());
            }
            if (request.getPlaqueScore() != null) {
                examination.setPlaqueScore(request.getPlaqueScore());
            }
            if (request.getGingivalRecession() != null) {
                examination.setGingivalRecession(request.getGingivalRecession());
            }
            if (request.getToothMobility() != null) {
                examination.setToothMobility(request.getToothMobility());
            }
            if (request.getToothVitality() != null) {
                examination.setToothVitality(request.getToothVitality());
            }
            if (request.getToothSensitivity() != null) {
                examination.setToothSensitivity(request.getToothSensitivity());
            }
            if (request.getFurcationInvolvement() != null) {
                examination.setFurcationInvolvement(request.getFurcationInvolvement());
            }
            if (request.getExaminationNotes() != null) {
                examination.setExaminationNotes(request.getExaminationNotes());
            }
            
            // Save the updated examination
            toothClinicalExaminationRepository.save(examination);
            log.info("Successfully updated examination with ID: {}", request.getId());
        } catch (Exception e) {
            log.error("Error updating examination: {}", e.getMessage());
            throw e;
        }
    }

    @Override
    public void assignDoctorToExamination(Long examinationId, Long doctorId) {
        try {
            // Find the examination
            Optional<ToothClinicalExamination> examinationOpt = toothClinicalExaminationRepository.findById(examinationId);
            if (!examinationOpt.isPresent()) {
                throw new IllegalArgumentException("Examination not found with ID: " + examinationId);
            }
            
            ToothClinicalExamination examination = examinationOpt.get();
            
            if (doctorId == null) {
                // Case: Remove doctor assignment
                examination.setAssignedDoctor(null);
                log.info("Removed doctor assignment from examination ID {}", examinationId);
            } else {
                // Case: Assign a doctor
                // Find the doctor in DoctorDetail repository
                DoctorDetail doctor = doctorDetailRepository.findById(doctorId)
                    .orElseThrow(() -> new IllegalArgumentException("Doctor not found with ID: " + doctorId));
                
                // Update the examination with the doctor
                examination.setAssignedDoctor(doctor);
                log.info("Assigned doctor ID {} to examination ID {}", doctorId, examinationId);
            }
            
            // Save the updated examination
            toothClinicalExaminationRepository.save(examination);
        } catch (Exception e) {
            log.error("Error updating doctor assignment for examination: {}", e.getMessage());
            throw e;
        }
    }

    @Override
    public PatientDTO convertToDTO(Patient patient) {
        log.info("Converting Patient entity to DTO for patient ID: {}", patient.getId());
        return patientMapper.toDto(patient);
    }
    
    @Override
    public boolean isDuplicatePatient(String firstName, String phoneNumber) {
        log.info("Checking for duplicate patient with firstName: {} and phoneNumber: {}", firstName, phoneNumber);
        return patientRepository.existsByFirstNameIgnoreCaseAndPhoneNumber(firstName, phoneNumber);
    }
    
    @Override
    public String handleProfilePictureUpload(MultipartFile file, String patientId) {
        log.info("Handling profile picture upload for patient ID: {}", patientId);
        try {
            if (file == null || file.isEmpty()) {
                log.warn("Empty file provided for profile picture upload");
                return null;
            }
            
            // Store the file using FileStorageService
            String profilePicturePath = fileStorageService.storeFile(file, "profiles");
            log.info("Profile picture stored at: {}", profilePicturePath);
            
            // If patientId is provided, update the existing patient with the new profile picture path
            if (patientId != null && !patientId.isEmpty()) {
                try {
                    Long id = Long.parseLong(patientId);
                    Optional<Patient> patientOpt = patientRepository.findById(id);
                    if (patientOpt.isPresent()) {
                        Patient patient = patientOpt.get();
                        // Delete old profile picture if exists
                        if (patient.getProfilePicturePath() != null) {
                            fileStorageService.deleteFile(patient.getProfilePicturePath());
                        }
                        patient.setProfilePicturePath(profilePicturePath);
                        patientRepository.save(patient);
                    }
                } catch (NumberFormatException e) {
                    log.error("Invalid patient ID format: {}", patientId, e);
                }
            }
            
            return profilePicturePath;
        } catch (IOException e) {
            log.error("Error uploading profile picture", e);
            throw new RuntimeException("Failed to upload profile picture: " + e.getMessage(), e);
        }
    }
    
    @Override
    public void updatePatient(PatientDTO patientDTO) {
        log.info("Updating patient with ID: {}", patientDTO.getId());
        try {
            // Find the existing patient
            Long patientId = Long.parseLong(patientDTO.getId());
            Optional<Patient> existingPatientOpt = patientRepository.findById(patientId);
            
            if (!existingPatientOpt.isPresent()) {
                throw new IllegalArgumentException("Patient not found with ID: " + patientId);
            }
            
            Patient existingPatient = existingPatientOpt.get();
            
            // Update the patient properties
            existingPatient.setFirstName(patientDTO.getFirstName());
            existingPatient.setLastName(patientDTO.getLastName());
            existingPatient.setDateOfBirth(patientDTO.getDateOfBirth());
            existingPatient.setGender(patientDTO.getGender());
            existingPatient.setPhoneNumber(patientDTO.getPhoneNumber());
            existingPatient.setEmail(patientDTO.getEmail());
            existingPatient.setStreetAddress(patientDTO.getStreetAddress());
            existingPatient.setCity(patientDTO.getCity());
            existingPatient.setState(patientDTO.getState());
            existingPatient.setPincode(patientDTO.getPincode());
            
            // Optional fields
            if (patientDTO.getMedicalHistory() != null) {
                existingPatient.setMedicalHistory(patientDTO.getMedicalHistory());
            }
            
            if (patientDTO.getEmergencyContactName() != null) {
                existingPatient.setEmergencyContactName(patientDTO.getEmergencyContactName());
            }
            
            if (patientDTO.getEmergencyContactPhoneNumber() != null) {
                existingPatient.setEmergencyContactPhoneNumber(patientDTO.getEmergencyContactPhoneNumber());
            }
            
            if (patientDTO.getOccupation() != null) {
                String occupationName;
                if (patientDTO.getOccupation() instanceof OccupationDTO) {
                    occupationName = ((OccupationDTO) patientDTO.getOccupation()).getName();
                } else {
                    occupationName = patientDTO.getOccupation().toString();
                }
                
                try {
                    existingPatient.setOccupation(Occupation.valueOf(occupationName));
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid occupation value: {}", occupationName);
                    existingPatient.setOccupation(Occupation.OTHER);
                }
            }
            
            // Save the updated patient
            patientRepository.save(existingPatient);
            log.info("Successfully updated patient with ID: {}", patientId);
        } catch (Exception e) {
            log.error("Error updating patient: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to update patient: " + e.getMessage(), e);
        }
    }

}

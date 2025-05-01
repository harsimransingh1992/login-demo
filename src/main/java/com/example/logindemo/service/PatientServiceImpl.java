package com.example.logindemo.service;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.dto.OccupationDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.repository.DoctorDetailRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.util.PatientMapper;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
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
        checkInRecordRepository.save(checkInRecord);
        patient.getPatientCheckIns().add(checkInRecord);
        patient.setCurrentCheckInRecord(checkInRecord);
        log.info("CheckIn recordID: {} added to patientID: {} ",checkInRecord.getId(), patient.getId());
    }

    @Override
    public void uncheckInPatient(Long patientId) {
        Optional<Patient> patients = patientRepository.findById(patientId);
        patients.ifPresent(patient -> {
            patient.setCheckedIn(false);
            patient.setCurrentCheckInRecord(null);
            patientRepository.save(patient);
        });
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
                if (patientDTO.getOccupation() instanceof OccupationDTO) {
                    occupationName = ((OccupationDTO) patientDTO.getOccupation()).getName();
                } else {
                    occupationName = patientDTO.getOccupation().toString();
                }
                
                try {
                    patient.setOccupation(Occupation.valueOf(occupationName));
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid occupation value: {}", occupationName);
                    patient.setOccupation(Occupation.OTHER);
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
        return waitingPatients.stream().map(patientMapper::toDto).toList();
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
                toothClinicalExaminationRepository.save(toothClinicalExamination);
            }

        }
        catch (Exception e) {
            log.error(e.getMessage());
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

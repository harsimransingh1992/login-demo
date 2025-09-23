package com.example.logindemo.service;

import com.example.logindemo.dto.CheckInRecordDTO;
import com.example.logindemo.dto.OccupationDTO;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.util.PatientMapper;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Collections;
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

    @Resource(name="userRepository")
    private UserRepository userRepository;

    @Resource(name = "checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;

    @Resource(name="toothClinicalExaminationRepository")
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Resource(name="fileStorageService")
    private FileStorageService fileStorageService;

    @Resource
    private UserService userService;

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
        checkInRecord.setClinic(currentClinicModel.getClinic()); // Set the clinic field for the query to work
        checkInRecord.setCheckInTime(LocalDateTime.now());
        checkInRecord.setPatient(patient);
        checkInRecord.setStatus(CheckInStatus.WAITING); // Set default status
        
        // Save the check-in record first to get the ID
        checkInRecord = checkInRecordRepository.save(checkInRecord);
        
        // Update patient relationships
        patient.getPatientCheckIns().add(checkInRecord);
        patient.setCurrentCheckInRecord(checkInRecord);
        patient.setCheckedIn(true); // Ensure checked in status is set
        
        // Save the patient with updated relationships
        patientRepository.save(patient);
        
        log.info("CheckIn recordID: {} added to patientID: {} with clinic: {}",
            checkInRecord.getId(), patient.getId(), 
            currentClinicModel.getClinic() != null ? currentClinicModel.getClinic().getClinicName() : "NULL");
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
            // Get current user and clinic
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();
            
            User currentUser = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            if (currentUser.getClinic() == null) {
                throw new RuntimeException("Current user is not associated with any clinic");
            }
            
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
            patient.setProfilePicturePath(patientDTO.getProfilePicturePath());
            
            // Set referralOther
            patient.setReferralOther(patientDTO.getReferralOther());
            
            // Set color code
            patient.setColorCode(patientDTO.getColorCode());
            
            // Set audit fields
            patient.setCreatedBy(currentUser);
            patient.setRegisteredClinic(currentUser.getClinic());
            patient.setCreatedAt(new Date());
            
            // Generate and set registration code
            String registrationCode = generateRegistrationCode();
            patient.setRegistrationCode(registrationCode);
            patientDTO.setRegistrationCode(registrationCode);
            
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
            if (patientDTO.getReferralModel() != null) {
                try {
                    patient.setReferralModel(ReferralModel.valueOf(patientDTO.getReferralModel().getName()));
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid referral model value: {}", patientDTO.getReferralModel().getName());
                    patient.setReferralModel(ReferralModel.OTHER);
                }
            }
            
            // Set registration date
            patient.setRegistrationDate(new Date());
            
            // Save the patient
            patientRepository.save(patient);
            log.info("Successfully registered patient with ID: {} and registration code: {} by user: {} at clinic: {}", 
                patient.getId(), registrationCode, currentUser.getUsername(), currentUser.getClinic().getClinicName());
        } catch (Exception e) {
            log.error("Error registering patient: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to register patient: " + e.getMessage(), e);
        }
    }

    /**
     * Generates a registration code as a simple sequential number starting from 1
     * @return the generated registration code
     */
    private String generateRegistrationCode() {
        // Get the total count of patients and add 1 for the new patient
        long sequence = patientRepository.count() + 1;
        
        // Return just the sequence number as a string
        return String.valueOf(sequence);
    }

    @Override
    public List<PatientDTO> getAllPatients() {
        List<Patient> patients = patientRepository.findAll();
        return patients.stream().map(patientMapper::toDto).toList();
    }

    @Override
    public Page<PatientDTO> getAllPatientsPaginated(Pageable pageable) {
        Page<Patient> patientsPage = patientRepository.findAll(pageable);
        return patientsPage.map(patientMapper::toDto);
    }

    @Override
    public Page<PatientDTO> searchPatientsPaginated(String searchType, String query, Pageable pageable) {
        Page<Patient> patientsPage;
        
        switch (searchType) {
            case "name":
                patientsPage = patientRepository.findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(query, query, pageable);
                break;
            case "phone":
                patientsPage = patientRepository.findByPhoneNumberContaining(query, pageable);
                break;
            case "registration":
                patientsPage = patientRepository.findByRegistrationCodeContainingIgnoreCase(query, pageable);
                break;
            case "examination":
                try {
                    Long examinationId = Long.parseLong(query);
                    patientsPage = patientRepository.findByExaminationId(examinationId, pageable);
                } catch (NumberFormatException e) {
                    // Return empty page if query is not a valid number
                    patientsPage = Page.empty(pageable);
                }
                break;
            default:
                patientsPage = patientRepository.findAll(pageable);
                break;
        }
        
        return patientsPage.map(patientMapper::toDto);
    }

    @Override
    public List<PatientDTO> getCheckedInPatients() {
        long startTime = System.currentTimeMillis();
        
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        log.info("DEBUG: getCheckedInPatients called by user: {}", username);
        
        User loggedInUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        log.info("DEBUG: Found user: {} with ID: {}", loggedInUser.getUsername(), loggedInUser.getId());
            
        if (loggedInUser.getClinic() == null) {
            log.warn("User {} has no clinic associated", username);
            return Collections.emptyList();
        }
        
        log.info("DEBUG: User clinic: {} with ID: {}", loggedInUser.getClinic().getClinicName(), loggedInUser.getClinic().getId());
        
        // Use optimized query to avoid N+1 problem
        List<Patient> waitingPatients = patientRepository.findCheckedInPatientsWithDetailsOptimized(loggedInUser.getClinic());
        log.info("DEBUG: Raw query returned {} patients", waitingPatients.size());
        
        // Debug each patient
        for (Patient patient : waitingPatients) {
            log.info("DEBUG: Patient ID: {}, Name: {} {}, CheckedIn: {}, HasCheckInRecord: {}", 
                patient.getId(), 
                patient.getFirstName(), 
                patient.getLastName(),
                patient.getCheckedIn(),
                patient.getCurrentCheckInRecord() != null);
        }
        
        List<PatientDTO> result = waitingPatients.stream()
            .map(patientMapper::toDto)
            .toList();
            
        long endTime = System.currentTimeMillis();
        log.info("Found {} checked-in patients for clinic {} in {}ms (optimized query)", 
            result.size(), loggedInUser.getClinic().getId(), (endTime - startTime));
        
        return result;
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
            checkInRecord.setClinic(clinic.getClinic()); // Set the clinic field for the query to work
            checkInRecord.setCheckInTime(LocalDateTime.now());
            checkInRecord.setPatient(patient);
            checkInRecord.setStatus(CheckInStatus.WAITING); // Set default status
            
            // Save the check-in record first to get the ID
            checkInRecord = checkInRecordRepository.save(checkInRecord);
            
            // Update patient relationships
            patient.getPatientCheckIns().add(checkInRecord);
            patient.setCurrentCheckInRecord(checkInRecord);
            
            // Save the patient with updated relationships
            patientRepository.save(patient);
            
            log.info("Created missing CheckIn record ID: {} for patient ID: {} with clinic: {}", 
                checkInRecord.getId(), patient.getId(),
                clinic.getClinic() != null ? clinic.getClinic().getClinicName() : "NULL");
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
                
                // Set OPD doctor if provided
                if (request.getOpdDoctorId() != null) {
                    User opdDoctor = userRepository.findById(request.getOpdDoctorId())
                        .orElseThrow(() -> new RuntimeException("OPD doctor not found"));
                    toothClinicalExamination.setOpdDoctor(opdDoctor);
                    log.info("Set OPD doctor to: {}", opdDoctor.getFirstName() + " " + opdDoctor.getLastName());
                }
                
                // Get current clinic user and set it as examination clinic
                String currentClinicUsername = PeriDeskUtils.getCurrentClinicUserName();
                Optional<User> currentUser = userRepository.findByUsername(currentClinicUsername);
                if (currentUser.isPresent() && currentUser.get().getClinic() != null) {
                    ClinicModel clinic = currentUser.get().getClinic();
                    toothClinicalExamination.setExaminationClinic(clinic);
                    log.info("Setting examination clinic to: {}", clinic.getClinicName());
                } else {
                    log.warn("Could not find clinic for user: {}", currentClinicUsername);
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
            if (request.getChiefComplaints() != null) {
                examination.setChiefComplaints(request.getChiefComplaints());
            }
            if (request.getAdvised() != null) {
                examination.setAdvised(request.getAdvised());
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
                // Case: Assign a doctor - now using User entity directly
                User doctor = userRepository.findById(doctorId)
                    .orElseThrow(() -> new IllegalArgumentException("Doctor not found with ID: " + doctorId));
                
                // Verify the user is a doctor
                if (doctor.getRole() != UserRole.DOCTOR && doctor.getRole() != UserRole.OPD_DOCTOR) {
                    throw new IllegalArgumentException("User must be a doctor to assign to examination");
                }
                
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
            
            if (patientDTO.getReferralModel() != null) {
                try {
                    existingPatient.setReferralModel(ReferralModel.valueOf(patientDTO.getReferralModel().getName()));
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid referral model value: {}", patientDTO.getReferralModel().getName());
                    existingPatient.setReferralModel(ReferralModel.OTHER);
                }
            }
            
            // Update color code
            existingPatient.setColorCode(patientDTO.getColorCode());
            
            // Save the updated patient
            patientRepository.save(existingPatient);
            log.info("Successfully updated patient with ID: {}", patientId);
        } catch (Exception e) {
            log.error("Error updating patient: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to update patient: " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    @Override
    public Patient savePatient(Patient patient) {
        return patientRepository.save(patient);
    }

    @Override
    public PatientDTO findByRegistrationCode(String registrationCode) {
        Optional<Patient> patient = patientRepository.findByRegistrationCode(registrationCode);
        return patient.map(patientMapper::toDto).orElse(null);
    }

    @Override
    public double calculatePendingPayments(Long patientId) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (!patientOpt.isPresent()) {
            return 0.0;
        }
        
        Patient patient = patientOpt.get();
        double totalPendingAmount = 0.0;
        
        // Get all examinations for this patient
        List<ToothClinicalExamination> examinations = toothClinicalExaminationRepository.findByPatientId(patientId);
        
        for (ToothClinicalExamination exam : examinations) {
            // Calculate payment amounts with transaction types
            double totalPaid = 0.0;
            double totalRefunded = 0.0;
            
            if (exam.getPaymentEntries() != null) {
                for (PaymentEntry entry : exam.getPaymentEntries()) {
                    if (entry.getAmount() != null) {
                        if (entry.getTransactionType() != null && entry.getTransactionType().toString().equals("REFUND")) {
                            totalRefunded += entry.getAmount();
                        } else {
                            totalPaid += entry.getAmount();
                        }
                    }
                }
            }
            
            double netPaid = totalPaid - totalRefunded;
            double totalProcedureAmount = exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0;
            double remainingAmount = totalProcedureAmount - netPaid;
            
            // Only add to pending if there's actually an amount remaining
            if (remainingAmount > 0) {
                totalPendingAmount += remainingAmount;
            }
        }
        
        return totalPendingAmount;
    }

}

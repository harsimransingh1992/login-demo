package com.example.logindemo.controller;

import com.example.logindemo.dto.*;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.*;
import com.example.logindemo.service.*;
import com.example.logindemo.util.LocationUtil;
import com.example.logindemo.util.PatientMapper;
import com.example.logindemo.model.IndianState;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.beans.PropertyEditor;
import java.beans.PropertyEditorSupport;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import javax.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import java.util.Optional;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.logindemo.model.MediaFile;
import com.example.logindemo.model.ProcedureLifecycleTransition;

@Controller
@RequestMapping("/patients")
@Slf4j
public class PatientController {

    @Resource(name="patientRepository")
    private PatientRepository patientRepository;

    @Resource(name="patientService")
    PatientService patientService;

    @Resource(name="patientMapper")
    private PatientMapper patientMapper;

    @Resource(name="toothClinicalExaminationService")
    private ToothClinicalExaminationService toothClinicalExaminationService;

    @Resource(name="userService")
    private UserService userService;

    @Resource(name="procedurePriceService")
    private ProcedurePriceService procedurePriceService;

    @Resource(name="userRepository")
    private UserRepository userRepository;

    @Resource(name="fileStorageService")
    private FileStorageService fileStorageService;

    @Resource(name="checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;

    @Resource(name="toothClinicalExaminationRepository")
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Resource(name="procedureLifecycleTransitionRepository")
    private ProcedureLifecycleTransitionRepository procedureLifecycleTransitionRepository;

    @Resource(name="appointmentRepository")
    private AppointmentRepository appointmentRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private ProcedureLifecycleService lifecycleService;

    @Autowired
    private LocationUtil locationUtil;

    @Autowired
    private MotivationQuoteService motivationQuoteService;

    @Autowired
    private FollowUpService followUpService;

    @Autowired
    private MediaFileRepository mediaFileRepository;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        // Register custom date editor for dateOfBirth
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, "dateOfBirth", new CustomDateEditor(dateFormat, true));
        
        // Register custom editors for DTO fields
        binder.registerCustomEditor(OccupationDTO.class, "occupation", new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text != null && !text.trim().isEmpty()) {
                    try {
                        Occupation occupation = Occupation.valueOf(text);
                        OccupationDTO dto = new OccupationDTO();
                        dto.setName(occupation.name());
                        dto.setDisplayName(occupation.getDisplayName());
                        setValue(dto);
                    } catch (IllegalArgumentException e) {
                        log.warn("Invalid occupation value: {}", text);
                        setValue(null);
                    }
                } else {
                    setValue(null);
                }
            }
        });
        
        binder.registerCustomEditor(ReferralDTO.class, "referralModel", new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text != null && !text.trim().isEmpty()) {
                    try {
                        ReferralModel referralModel = ReferralModel.valueOf(text);
                        ReferralDTO dto = new ReferralDTO();
                        dto.setName(referralModel.name());
                        dto.setDisplayName(referralModel.getDisplayName());
                        setValue(dto);
                    } catch (IllegalArgumentException e) {
                        log.warn("Invalid referral model value: {}", text);
                        setValue(null);
                    }
                } else {
                    setValue(null);
                }
            }
        });
    }

    // Add ModelAttribute methods for all enums
    @ModelAttribute("toothNumbers")
    public ToothNumber[] toothNumbers() {
        return ToothNumber.values();
    }

    @ModelAttribute("toothSurfaces")
    public ToothSurface[] toothSurfaces() {
        return ToothSurface.values();
    }

    @ModelAttribute("toothConditions")
    public ToothCondition[] toothConditions() {
        return ToothCondition.values();
    }

    @ModelAttribute("toothMobilities")
    public ToothMobility[] toothMobilities() {
        return ToothMobility.values();
    }

    @ModelAttribute("pocketDepths")
    public PocketDepth[] pocketDepths() {
        return PocketDepth.values();
    }

    @ModelAttribute("bleedingOnProbings")
    public BleedingOnProbing[] bleedingOnProbings() {
        return BleedingOnProbing.values();
    }

    @ModelAttribute("plaqueScores")
    public PlaqueScore[] plaqueScores() {
        return PlaqueScore.values();
    }

    @ModelAttribute("gingivalRecessions")
    public GingivalRecession[] gingivalRecessions() {
        return GingivalRecession.values();
    }

    @ModelAttribute("toothVitalities")
    public ToothVitality[] toothVitalities() {
        return ToothVitality.values();
    }

    @ModelAttribute("furcationInvolvements")
    public FurcationInvolvement[] furcationInvolvements() {
        return FurcationInvolvement.values();
    }

    @ModelAttribute("periapicalConditions")
    public PeriapicalCondition[] periapicalConditions() {
        return PeriapicalCondition.values();
    }

    @ModelAttribute("toothSensitivities")
    public ToothSensitivity[] toothSensitivities() {
        return ToothSensitivity.values();
    }

    @ModelAttribute("existingRestorations")
    public ExistingRestoration[] existingRestorations() {
        return ExistingRestoration.values();
    }

    @ModelAttribute("occupations")
    public List<OccupationDTO> occupations() {
        return Arrays.stream(Occupation.values())
            .map(OccupationDTO::fromEntity)
            .collect(Collectors.toList());
    }

    @ModelAttribute("referralModels")
    public List<ReferralDTO> referralModels() {
        return Arrays.stream(ReferralModel.values())
            .map(ReferralDTO::fromEntity)
            .collect(Collectors.toList());
    }

    @ModelAttribute("indianStates")
    public List<IndianState> indianStates() {
        return LocationUtil.getAllStates();
    }

    @ModelAttribute("dentalDepartments")
    public DentalDepartment[] dentalDepartments() {
        return DentalDepartment.values();
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("patient", new PatientDTO());
        return "patient/register";
    }

    @PostMapping("/register")
    public String registerPatient(@ModelAttribute PatientDTO patient, 
                                 @RequestParam(value = "profilePicture", required = false) MultipartFile profilePicture,
                                 Model model, 
                                 RedirectAttributes redirectAttributes) {
        // Check for duplicate patient
        if (patientService.isDuplicatePatient(patient.getFirstName(), patient.getPhoneNumber())) {
            model.addAttribute("error", "Patient with this name and phone number already exists");
            model.addAttribute("patient", patient);
            return "patient/register";
        }
        
        // Validate phone number (must be exactly 10 digits)
        if (patient.getPhoneNumber() == null || !patient.getPhoneNumber().matches("^[0-9]{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits");
            model.addAttribute("patient", patient);
            return "patient/register";
        }
        
        // Validate address fields
        if (patient.getStreetAddress() == null || patient.getStreetAddress().trim().isEmpty()) {
            model.addAttribute("error", "Street address is required");
            model.addAttribute("patient", patient);
            return "patient/register";
        }
        
        if (patient.getState() == null || patient.getState().trim().isEmpty()) {
            model.addAttribute("error", "State is required");
            model.addAttribute("patient", patient);
            return "patient/register";
        }
        
        if (patient.getCity() == null || patient.getCity().trim().isEmpty()) {
            model.addAttribute("error", "City is required");
            model.addAttribute("patient", patient);
            return "patient/register";
        }
        
        if (patient.getPincode() == null || patient.getPincode().trim().isEmpty() 
                || !patient.getPincode().matches("\\d{6}")) {
            model.addAttribute("error", "Valid 6-digit pincode is required");
            model.addAttribute("patient", patient);
            return "patient/register";
        }
        
        String profilePicturePath = null;
        
        // Handle profile picture upload if provided
        if (profilePicture != null && !profilePicture.isEmpty()) {
            try {
                // Check file size (max 2MB)
                if (profilePicture.getSize() > 2 * 1024 * 1024) {
                    model.addAttribute("error", "Profile picture size exceeds 2MB limit");
                    model.addAttribute("patient", patient);
                    return "patient/register";
                }
                
                // Check file type
                String contentType = profilePicture.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    model.addAttribute("error", "Only image files are allowed for profile picture");
                    model.addAttribute("patient", patient);
                    return "patient/register";
                }
                
                // Store the file using FileStorageService
                profilePicturePath = fileStorageService.storeFile(profilePicture, "profiles");
                log.info("Stored profile picture for patient at: {}", profilePicturePath);
                
                // Set the profile picture path in the patient DTO
                patient.setProfilePicturePath(profilePicturePath);
            } catch (IOException e) {
                log.error("Error handling profile picture upload", e);
                model.addAttribute("error", "Error uploading profile picture: " + e.getMessage());
                model.addAttribute("patient", patient);
                return "patient/register";
            }
        }

        patient.setRegistrationDate(new Date());
        
        // Register the patient
        patientService.registerPatient(patient);
        redirectAttributes.addFlashAttribute("success", "Patient registered successfully");
        return "redirect:/patients/list";
    }

    @GetMapping("/list")
    public String listPatients(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            Model model) {
        
        // Use pageSize if provided, otherwise use size (for backward compatibility)
        int actualSize = pageSize != 20 ? pageSize : size;
        
        org.springframework.data.domain.PageRequest pageRequest = org.springframework.data.domain.PageRequest.of(
            page, 
            actualSize, 
            org.springframework.data.domain.Sort.by(
                "desc".equalsIgnoreCase(direction) ? 
                org.springframework.data.domain.Sort.Direction.DESC : 
                org.springframework.data.domain.Sort.Direction.ASC, 
                sort
            )
        );
        
        org.springframework.data.domain.Page<PatientDTO> patientsPage = patientService.getAllPatientsPaginated(pageRequest);
        
        model.addAttribute("patients", patientsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", patientsPage.getTotalPages());
        model.addAttribute("totalItems", patientsPage.getTotalElements());
        model.addAttribute("pageSize", actualSize);
        model.addAttribute("sort", sort);
        model.addAttribute("direction", direction);
        
        return "patient/list";
    }

    @GetMapping("/search")
    public String searchPatients(
            @RequestParam String searchType, 
            @RequestParam String query, 
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            Model model) {
        
        // Use pageSize if provided, otherwise use size (for backward compatibility)
        int actualSize = pageSize != 20 ? pageSize : size;
        
        org.springframework.data.domain.PageRequest pageRequest = org.springframework.data.domain.PageRequest.of(
            page, 
            actualSize, 
            org.springframework.data.domain.Sort.by(
                "desc".equalsIgnoreCase(direction) ? 
                org.springframework.data.domain.Sort.Direction.DESC : 
                org.springframework.data.domain.Sort.Direction.ASC, 
                sort
            )
        );
        
        org.springframework.data.domain.Page<PatientDTO> patientsPage = patientService.searchPatientsPaginated(searchType, query, pageRequest);
        
        model.addAttribute("patients", patientsPage.getContent());
        model.addAttribute("searchType", searchType);
        model.addAttribute("query", query);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", patientsPage.getTotalPages());
        model.addAttribute("totalItems", patientsPage.getTotalElements());
        model.addAttribute("pageSize", actualSize);
        model.addAttribute("sort", sort);
        model.addAttribute("direction", direction);
        
        return "patient/list";
    }

    @PostMapping("/checkin/{id}")
    @ResponseBody
    public ResponseEntity<?> checkInPatient(@PathVariable Long id) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();
            
            User loggedInUser = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
                
            if (loggedInUser.getClinic() == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("User not associated with a clinic");
            }

            Patient patient = patientService.getPatientById(id)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

            // Create new check-in record
            CheckInRecord checkInRecord = new CheckInRecord();
            checkInRecord.setPatient(patient);
            checkInRecord.setCheckInTime(LocalDateTime.now());
            checkInRecord.setCheckInClinic(loggedInUser);
            checkInRecord.setClinic(loggedInUser.getClinic());
            checkInRecord.setStatus(CheckInStatus.WAITING);

            // Save the check-in record first
            checkInRecord = checkInRecordRepository.save(checkInRecord);

            // Update patient's current check-in record and check-in status
            patient.setCurrentCheckInRecord(checkInRecord);
            patient.setCheckedIn(true);
            patient.getPatientCheckIns().add(checkInRecord);

            // Save the patient with the updated check-in record
            patientService.savePatient(patient);

            // Create appointment record with status COMPLETED
            Appointment appointment = new Appointment();
            appointment.setPatient(patient);
            appointment.setPatientName(patient.getFirstName() + " " + patient.getLastName());
            appointment.setPatientMobile(patient.getPhoneNumber());
            appointment.setAppointmentDateTime(LocalDateTime.now());
            appointment.setStatus(AppointmentStatus.COMPLETED);
            appointment.setClinic(loggedInUser.getClinic());
            appointment.setAppointmentBookedBy(loggedInUser);
            appointment.setNotes("Patient checked in - appointment completed");

            // Save the appointment record
            Appointment savedAppointment = appointmentRepository.save(appointment);
            log.info("Saved appointment ID: {}, Doctor in saved appointment: {}", 
                savedAppointment.getId(), 
                savedAppointment.getDoctor() != null ? savedAppointment.getDoctor().getFirstName() : "NULL");

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Patient checked in successfully and appointment marked as completed"
            ));
        } catch (Exception e) {
            log.error("Error checking in patient: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of(
                    "success", false,
                    "message", "Error checking in patient: " + e.getMessage()
                ));
        }
    }

    @PostMapping("/uncheck/{id}")
    public ResponseEntity<Void> uncheckPatient(@PathVariable Long id) {
        log.info("Unchecking in patient {}", id);
        patientService.uncheckInPatient(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/details/{id}")
    public String getPatientDetails(@PathVariable Long id, Model model) {

        Optional<Patient> patient = patientRepository.findById(id);
        
        if(patient.isPresent()) {
            model.addAttribute("patient", patient.get());
            model.addAttribute("examinationHistory", toothClinicalExaminationService.getToothClinicalExaminationForPatientId(patient.get().getId()));
            
            // Get current user's clinic
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            // Add current user's role to model for frontend validation
            model.addAttribute("currentUserRole", currentUser.getRole());
            
            // Get doctors from the same clinic
            List<UserDTO> doctors = userService.getUsersByRoleAndClinic(UserRole.DOCTOR, currentUser.getClinic());
            model.addAttribute("doctorDetails", doctors);
        }
        return "patient/patientDetails"; // Return the name of the patient details view
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        log.info("Showing edit form for patient {}", id);
        Optional<Patient> patientOpt = patientRepository.findById(id);
        if (patientOpt.isPresent()) {
            Patient patient = patientOpt.get();
            model.addAttribute("patient", patient);
            
            // Add required dropdown data
            model.addAttribute("indianStates", IndianState.values());
            
            // Load cities for the current state if state is set
            if (patient.getState() != null) {
                try {
                    IndianState stateEnum = IndianState.valueOf(patient.getState());
                    List<IndianCityInterface> cities = locationUtil.getCitiesByState(stateEnum);
                    model.addAttribute("cities", cities);
                } catch (Exception e) {
                    log.warn("Could not load cities for state: {}", patient.getState(), e);
                }
            }
            
            return "patient/edit";
        } else {
            return "redirect:/patients/list";
        }
    }
    
    @PostMapping("/update")
    public String updatePatient(@ModelAttribute Patient patient, 
                               @RequestParam(value = "profilePicture", required = false) MultipartFile profilePicture,
                               @RequestParam(value = "removeProfilePicture", required = false) String removeProfilePicture,
                               RedirectAttributes redirectAttributes) {
        log.info("Updating patient {}", patient.getId());
        try {
            // Handle profile picture upload if provided
            if (profilePicture != null && !profilePicture.isEmpty()) {
                log.info("New profile picture uploaded for patient {}", patient.getId());
                String profilePicturePath = patientService.handleProfilePictureUpload(profilePicture, patient.getId().toString());
                patient.setProfilePicturePath(profilePicturePath);
            } 
            // Handle profile picture removal if requested
            else if ("true".equals(removeProfilePicture)) {
                log.info("Removing profile picture for patient {}", patient.getId());
                // Get current patient to find the profile picture path
                Optional<Patient> existingPatient = patientRepository.findById(patient.getId());
                if (existingPatient.isPresent() && existingPatient.get().getProfilePicturePath() != null) {
                    // Delete the file
                    fileStorageService.deleteFile(existingPatient.get().getProfilePicturePath());
                }
                // Set path to null in the patient
                patient.setProfilePicturePath(null);
            }
            
            // Save the updated patient
            patientRepository.save(patient);
            redirectAttributes.addFlashAttribute("success", "Patient updated successfully");
        } catch (Exception e) {
            log.error("Error updating patient", e);
            redirectAttributes.addFlashAttribute("error", "Error updating patient: " + e.getMessage());
        }
        return "redirect:/patients/list";
    }

    // Tooth examination endpoints have been moved to ToothExaminationController
    // @PostMapping("/tooth-examination/save") endpoint removed to avoid duplicate mapping

    @PostMapping("/tooth-examination/assign-doctor")
    @ResponseBody
    public ResponseEntity<?> assignDoctorToExamination(@RequestBody Map<String, Long> request) {
        try {
            // Get current user to check role
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            // Check if user is a receptionist - prevent them from assigning doctors
            if (currentUser.getRole() == UserRole.RECEPTIONIST) {
                log.warn("Receptionist {} attempted to assign doctor to examination", currentUsername);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "message", "Receptionists are not authorized to assign doctors to examinations. Please contact a doctor or staff member."
                ));
            }
            
            Long examinationId = request.get("examinationId");
            // doctorId can be null when removing assignment
            Long doctorId = request.get("doctorId"); 
            
            if (examinationId == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examinationId"
                ));
            }
            
            if (doctorId == null) {
                log.info("Removing doctor assignment from examination {}", examinationId);
            } else {
                log.info("Assigning doctor {} to examination {}", doctorId, examinationId);
            }
            
            patientService.assignDoctorToExamination(examinationId, doctorId);
            
            return ResponseEntity.ok(Map.of(
                "success", true
            ));
        } catch (Exception e) {
            log.error("Error updating doctor assignment: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    @GetMapping("/examination")
    public String getAllExaminations() {
        log.info("Redirecting from /examination endpoint to patient list");
        return "redirect:/welcome";
    }
    
    @GetMapping("/examination/")
    public String getAllExaminationsSlash() {
        log.info("Redirecting from /examination/ endpoint to patient list");
        return "redirect:/welcome";
    }

    @GetMapping("/examination/{id}")
    public String getExaminationDetails(@PathVariable Long id, Model model) {
        try {
            ToothClinicalExaminationDTO examination = toothClinicalExaminationService.getToothClinicalExaminationById(id);
            if (examination == null) {
                return "redirect:/patients/list";
            }
            
            // Get patient details
            Optional<Patient> patient = patientRepository.findById(Long.valueOf(examination.getPatient().getId()));
            if (!patient.isPresent()) {
                return "redirect:/patients/list";
            }
            
            // Get current user's clinic
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            // Get doctors from the same clinic
            List<UserDTO> doctors = userService.getUsersByRoleAndClinic(UserRole.DOCTOR, currentUser.getClinic());
            
            model.addAttribute("examination", examination);
            model.addAttribute("patient", patient.get());
            model.addAttribute("doctors", doctors);
            model.addAttribute("currentUserRole", currentUser.getRole());
            
            return "patient/examinationDetails";
        } catch (Exception e) {
            log.error("Error loading examination details", e);
            return "redirect:/patients/list";
        }
    }

    @GetMapping("/examination/{id}/prescription")
    public String showPrescription(@PathVariable Long id, Model model) {
        try {
            ToothClinicalExaminationDTO examination = toothClinicalExaminationService.getToothClinicalExaminationById(id);
            if (examination == null) {
                return "redirect:/patients/list";
            }
            
            // Get patient details
            Optional<Patient> patient = patientRepository.findById(Long.valueOf(examination.getPatient().getId()));
            if (!patient.isPresent()) {
                return "redirect:/patients/list";
            }
            
            // Get assigned doctor details
            User assignedDoctor = null;
            if (examination.getAssignedDoctorId() != null) {
                assignedDoctor = userRepository.findById(examination.getAssignedDoctorId()).orElse(null);
            }
            
            // Get OPD doctor details
            User opdDoctor = null;
            if (examination.getOpdDoctorId() != null) {
                opdDoctor = userRepository.findById(examination.getOpdDoctorId()).orElse(null);
            }
            
            // Get clinic details from current user
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            ClinicModel clinic = currentUser.getClinic();
            
            model.addAttribute("examination", examination);
            model.addAttribute("patient", patient.get());
            model.addAttribute("assignedDoctor", assignedDoctor);
            model.addAttribute("opdDoctor", opdDoctor);
            model.addAttribute("clinic", clinic);
            
            return "patient/prescription";
        } catch (Exception e) {
            log.error("Error loading prescription", e);
            return "redirect:/patients/list";
        }
    }

    @PostMapping("/examination/{id}/update")
    @ResponseBody
    public ResponseEntity<?> updateExamination(@PathVariable Long id, @RequestBody ToothClinicalExaminationDTO examinationDTO) {
        try {
            // Get current user to check role
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            // Check if user is a receptionist - prevent them from updating examinations
            if (currentUser.getRole() == UserRole.RECEPTIONIST) {
                log.warn("Receptionist {} attempted to update tooth examination", currentUsername);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "message", "Receptionists are not authorized to update tooth examinations. Please contact a doctor or staff member."
                ));
            }
            
            // Get the existing examination
            Optional<ToothClinicalExamination> existingExaminationOpt = toothClinicalExaminationRepository.findById(id);
            if (existingExaminationOpt.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Examination not found"
                ));
            }

            ToothClinicalExamination existingExamination = existingExaminationOpt.get();
            
            // Update only the fields that can be changed
            if (examinationDTO.getToothSurface() != null) {
                existingExamination.setToothSurface(examinationDTO.getToothSurface());
            }
            if (examinationDTO.getToothCondition() != null) {
                existingExamination.setToothCondition(examinationDTO.getToothCondition());
            }
            if (examinationDTO.getExistingRestoration() != null) {
                existingExamination.setExistingRestoration(examinationDTO.getExistingRestoration());
            }
            if (examinationDTO.getToothMobility() != null) {
                existingExamination.setToothMobility(examinationDTO.getToothMobility());
            }
            if (examinationDTO.getPocketDepth() != null) {
                existingExamination.setPocketDepth(examinationDTO.getPocketDepth());
            }
            if (examinationDTO.getBleedingOnProbing() != null) {
                existingExamination.setBleedingOnProbing(examinationDTO.getBleedingOnProbing());
            }
            if (examinationDTO.getPlaqueScore() != null) {
                existingExamination.setPlaqueScore(examinationDTO.getPlaqueScore());
            }
            if (examinationDTO.getGingivalRecession() != null) {
                existingExamination.setGingivalRecession(examinationDTO.getGingivalRecession());
            }
            if (examinationDTO.getToothVitality() != null) {
                existingExamination.setToothVitality(examinationDTO.getToothVitality());
            }
            if (examinationDTO.getFurcationInvolvement() != null) {
                existingExamination.setFurcationInvolvement(examinationDTO.getFurcationInvolvement());
            }
            if (examinationDTO.getToothSensitivity() != null) {
                existingExamination.setToothSensitivity(examinationDTO.getToothSensitivity());
            }
            if (examinationDTO.getExaminationNotes() != null) {
                existingExamination.setExaminationNotes(examinationDTO.getExaminationNotes());
            }
            
            // Save the updated examination
            ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(existingExamination);
            
            // Convert back to DTO for response
            ToothClinicalExaminationDTO responseDTO = modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Examination updated successfully",
                "examination", responseDTO
            ));
            
        } catch (Exception e) {
            log.error("Error updating examination", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of(
                    "success", false,
                    "message", "Failed to update examination: " + e.getMessage()
                ));
        }
    }

    @GetMapping("/appointments")
    public String showAppointments(Model model) {
        log.info("Showing today's appointments");
        List<ToothClinicalExaminationDTO> appointments = toothClinicalExaminationService.getTodayAppointments();
        model.addAttribute("appointments", appointments);
        return "patient/appointments";
    }

    @GetMapping("/examination/{id}/procedures")
    public String showProceduresForExamination(@PathVariable Long id, Model model) {
        try {
            log.info("Loading procedure selection page for examination ID: {}", id);
            
            // Validate the examination ID
            if (id == null) {
                log.error("Examination ID is null");
                return "redirect:/welcome?error=Invalid examination ID";
            }
            
            // Get the examination details
            ToothClinicalExaminationDTO examination = toothClinicalExaminationService.getToothClinicalExaminationById(id);
            Optional<ToothClinicalExamination> examinationModel=toothClinicalExaminationRepository.findById(id);
            if (examination == null && examinationModel.isPresent()) {
                log.error("Examination not found for ID: {}", id);
                return "redirect:/welcome?error=Examination not found";
            }
            
            log.info("Found examination: id={}, toothNumber={}, patientId={}", 
                examination.getId(), examination.getToothNumber(), examination.getPatient().getId());

            //get current assigned doctor
            if(examinationModel.get().getAssignedDoctor() != null) {
                examination.setAssignedDoctorId(examinationModel.get().getAssignedDoctor().getId());
            }

            // Check if a doctor is assigned to the examination
            if (examination.getAssignedDoctorId() == null) {
                log.warn("Attempt to access procedures for examination {} without an assigned doctor", id);
                return "redirect:/patients/examination/" + id + "?error=Please assign a doctor before starting a procedure";
            }
            
            // Get the patient details
            Optional<Patient> patient = patientRepository.findById(Long.valueOf(examination.getPatient().getId()));
            if (!patient.isPresent()) {
                log.error("Patient not found for examination: {}", id);
                return "redirect:/welcome?error=Patient not found";
            }
            
            log.info("Found patient: id={}, name={} {}", 
                patient.get().getId(), patient.get().getFirstName(), patient.get().getLastName());
            
            // Get current logged in user (clinic)
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            Optional<User> currentUser = userRepository.findByUsername(currentUsername);
            
            // Get available procedures from the database based on user's city tier
            List<ProcedurePriceDTO> procedures;
            if (currentUser.isPresent() && currentUser.get().getClinic() != null && currentUser.get().getClinic().getCityTier() != null) {
                // Use the clinic's city tier to fetch relevant procedures
                CityTier userCityTier = currentUser.get().getClinic().getCityTier();
                procedures = procedurePriceService.getProceduresByTier(userCityTier);
                log.info("Fetched {} procedures for city tier: {}", procedures.size(), userCityTier);
                
                // Add the user's city tier to the model
                model.addAttribute("userCityTier", userCityTier);
                
                // Add safe display name for city tier
                String cityTierDisplayName = userCityTier.toString();
                if (userCityTier.getDisplayName() != null) {
                    cityTierDisplayName = userCityTier.getDisplayName();
                }
                model.addAttribute("cityTierDisplayName", cityTierDisplayName);
            } else {
                // If user's city tier is not available, show an error
                log.warn("User {} does not have a city tier assigned", currentUsername);
                return "redirect:/patients/examination/" + id + "?error=Your clinic does not have a city tier assigned. Please contact administration.";
            }
            
            // Get procedures already associated with this examination
            List<ProcedurePriceDTO> existingProcedures = toothClinicalExaminationService.getProceduresForExamination(id);
            List<Long> existingProcedureIds = existingProcedures.stream()
                    .map(ProcedurePriceDTO::getId)
                    .collect(Collectors.toList());
            
            log.info("Found {} existing procedures for examination ID: {}", existingProcedureIds.size(), id);
            
            // Add attributes to the model
            model.addAttribute("examination", examination);
            model.addAttribute("patient", patient.get());
            model.addAttribute("procedures", procedures);
            model.addAttribute("existingProcedureIds", existingProcedureIds);
            
            // Explicitly add dental departments for tabs
            model.addAttribute("dentalDepartments", DentalDepartment.values());
            
            log.info("Successfully loaded procedure selection page for examination ID: {}", id);
            return "patient/procedureSelection";
        } catch (Exception e) {
            log.error("Error showing procedures for examination ID {}: {}", id, e.getMessage(), e);
            return "redirect:/welcome?error=Error loading procedures: " + e.getMessage();
        }
    }

    @PostMapping("/examination/start-procedure")
    @ResponseBody
    public ResponseEntity<?> startProcedure(
            @RequestParam("examinationId") Long examinationId,
            @RequestParam("procedureId") Long procedureId,
            @RequestParam(value = "upperDenturePicture", required = false) MultipartFile upperDenturePicture,
            @RequestParam(value = "lowerDenturePicture", required = false) MultipartFile lowerDenturePicture) {
        try {
            if (examinationId == null || procedureId == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examinationId or procedureId"
                ));
            }
            
            // Validate that both denture pictures are provided
            if (upperDenturePicture == null || upperDenturePicture.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Upper denture picture is required"
                ));
            }
            
            if (lowerDenturePicture == null || lowerDenturePicture.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lower denture picture is required"
                ));
            }
            
            log.info("Starting procedure {} for examination {} with denture pictures", procedureId, examinationId);
            
            // Check if the procedure is already associated with the examination
            if (toothClinicalExaminationService.isProcedureAlreadyAssociated(examinationId, procedureId)) {
                // Get the procedure name for better error message
                ProcedurePriceDTO procedure = procedurePriceService.getProcedureById(procedureId);
                String procedureName = procedure != null ? procedure.getProcedureName() : "Procedure #" + procedureId;
                
                Map<String, Object> duplicateProcedureInfo = new HashMap<>();
                duplicateProcedureInfo.put("id", procedureId);
                duplicateProcedureInfo.put("name", procedureName);
                
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "This procedure is already associated with the examination: " + procedureName,
                    "duplicateProcedure", duplicateProcedureInfo
                ));
            }
            
            // Save the denture pictures
            String upperDenturePath = null;
            String lowerDenturePath = null;
            
            try {
                // Save the files
                upperDenturePath = fileStorageService.storeFile(upperDenturePicture, "denture-pictures");
                lowerDenturePath = fileStorageService.storeFile(lowerDenturePicture, "denture-pictures");
                
                log.info("Saved denture pictures - Upper: {}, Lower: {}", upperDenturePath, lowerDenturePath);
                
            } catch (Exception e) {
                log.error("Error saving denture pictures: {}", e.getMessage(), e);
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Error saving denture pictures: " + e.getMessage()
                ));
            }
            
            // Associate the procedure with the examination and save denture paths
            List<Long> procedureIdList = Collections.singletonList(procedureId);
            toothClinicalExaminationService.associateProceduresWithExamination(examinationId, procedureIdList);
            
            // Update the examination with denture picture paths
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            examination.setUpperDenturePicturePath(upperDenturePath);
            examination.setLowerDenturePicturePath(lowerDenturePath);
            toothClinicalExaminationRepository.save(examination);
            
            // Return success and redirect to payment review page
            return ResponseEntity.ok(Map.of(
                "success", true,
                "procedureId", procedureId,
                "message", "Procedure started successfully with denture pictures",
                "redirect", "/patients/examination/" + examinationId + "/payment-review"
            ));
        } catch (Exception e) {
            log.error("Error starting procedure: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @PostMapping("/examination/start-procedures")
    @ResponseBody
    public ResponseEntity<?> startMultipleProcedures(@RequestBody Map<String, Object> request) {
        try {
            // Extract parameters from the request
            Long examinationId = Long.valueOf(request.get("examinationId").toString());
            @SuppressWarnings("unchecked")
            List<String> procedureIds = (List<String>) request.get("procedureIds");
            String totalAmount = request.get("totalAmount").toString();
            
            if (examinationId == null || procedureIds == null || procedureIds.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examinationId or procedureIds"
                ));
            }
            
            log.info("Starting {} procedures for examination {}, total amount: {}", 
                    procedureIds.size(), examinationId, totalAmount);
            
            // Convert List<String> to List<Long> for consistency
            List<Long> longProcedureIds = procedureIds.stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());
            
            // Check if any procedures are already associated with the examination
            List<Long> alreadyAssociatedProcedures = toothClinicalExaminationService.findAlreadyAssociatedProcedures(
                    examinationId, longProcedureIds);
            
            if (!alreadyAssociatedProcedures.isEmpty()) {
                // Get the names of the already associated procedures for better error message
                List<String> alreadyAssociatedNames = new ArrayList<>();
                Map<String, Object> duplicateProcedureInfo = new HashMap<>();
                List<Map<String, Object>> duplicateDetails = new ArrayList<>();
                
                // Fetch procedure details for better error messages
                for (Long procId : alreadyAssociatedProcedures) {
                    // Find the procedure by ID
                    ProcedurePriceDTO procedure = procedurePriceService.getProcedureById(procId);
                    if (procedure != null) {
                        alreadyAssociatedNames.add(procedure.getProcedureName());
                        
                        // Add detailed info for frontend
                        Map<String, Object> procInfo = new HashMap<>();
                        procInfo.put("id", procId);
                        procInfo.put("name", procedure.getProcedureName());
                        duplicateDetails.add(procInfo);
                    } else {
                        // Fallback if procedure not found
                        alreadyAssociatedNames.add("Procedure #" + procId);
                        
                        Map<String, Object> procInfo = new HashMap<>();
                        procInfo.put("id", procId);
                        procInfo.put("name", "Procedure #" + procId);
                        duplicateDetails.add(procInfo);
                    }
                }
                
                duplicateProcedureInfo.put("ids", alreadyAssociatedProcedures);
                duplicateProcedureInfo.put("details", duplicateDetails);
                
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "The following procedures are already associated with this examination: " + 
                          String.join(", ", alreadyAssociatedNames));
                response.put("duplicateProcedures", duplicateProcedureInfo);
                
                return ResponseEntity.badRequest().body(response);
            }
            
            // Associate procedures with the examination
            toothClinicalExaminationService.associateProceduresWithExamination(examinationId, longProcedureIds);
            
            // Return success and redirect to payment review page
            return ResponseEntity.ok(Map.of(
                "success", true,
                "procedureCount", procedureIds.size(),
                "message", "Procedures started successfully",
                "redirect", "/patients/examination/" + examinationId + "/payment-review"
            ));
        } catch (Exception e) {
            log.error("Error starting multiple procedures: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    @GetMapping("/examination/{id}/payment-review")
    public String showPaymentReview(@PathVariable Long id, Model model) {
        try {
            // Get the examination details with associated procedures
            ToothClinicalExaminationDTO examination = toothClinicalExaminationService.getToothClinicalExaminationById(id);
            if (examination == null) {
                return "redirect:/welcome?error=Examination not found";
            }
            
            // Get the patient details
            Optional<Patient> patient = patientRepository.findById(examination.getPatientId());
            if (!patient.isPresent()) {
                return "redirect:/welcome?error=Patient not found";
            }
            
            // Get procedures associated with the examination
            List<ProcedurePriceDTO> procedures = toothClinicalExaminationService.getProceduresForExamination(id);
            
            // Calculate total amount
            double totalAmount = procedures.stream()
                .mapToDouble(proc -> proc.getPrice() != null ? proc.getPrice() : 0)
                .sum();
            
            // Add attributes to the model
            model.addAttribute("examination", examination);
            model.addAttribute("patient", patient.get());
            model.addAttribute("procedures", procedures);
            model.addAttribute("totalAmount", totalAmount);
            
            return "patient/paymentReview";
        } catch (Exception e) {
            log.error("Error showing payment review: {}", e.getMessage(), e);
            return "redirect:/welcome?error=Error loading payment review: " + e.getMessage();
        }
    }

    @GetMapping("/examination/{id}/procedures-json")
    @ResponseBody
    public ResponseEntity<?> getExaminationProceduresAsJson(@PathVariable Long id) {
        try {
            log.info("Fetching procedures for examination ID: {}", id);
            
            // Validate the ID
            if (id == null) {
                log.error("Examination ID is null");
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Invalid examination ID: ID cannot be null"
                ));
            }
            
            // Get procedures associated with the examination
            try {
                List<ProcedurePriceDTO> procedures = toothClinicalExaminationService.getProceduresForExamination(id);
                
                log.info("Found {} procedures for examination ID: {}", procedures.size(), id);
                
                // Log details about each procedure
                for (ProcedurePriceDTO procedure : procedures) {
                    log.info("Procedure: id={}, name={}, price={}, dentalDepartment={}", 
                        procedure.getId(), 
                        procedure.getProcedureName(),
                        procedure.getPrice(),
                        procedure.getDentalDepartment() != null ? 
                            procedure.getDentalDepartment() + " (displayName: " + 
                            (procedure.getDentalDepartment().getDisplayName() != null ? 
                                procedure.getDentalDepartment().getDisplayName() : "null") + ")" : 
                            "null"
                    );
                }
                
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("procedures", procedures);
                
                // Calculate total amount
                double totalAmount = procedures.stream()
                    .mapToDouble(proc -> proc.getPrice() != null ? proc.getPrice() : 0)
                    .sum();
                
                response.put("totalAmount", totalAmount);
                log.info("Total amount: {}", totalAmount);
                
                return ResponseEntity.ok(response);
            } catch (IllegalArgumentException e) {
                // This exception is thrown when the examination is not found
                log.error("Examination not found: {}", id);
                return ResponseEntity.status(404).body(Map.of(
                    "success", false,
                    "message", "Examination not found: " + id
                ));
            }
        } catch (Exception e) {
            log.error("Error fetching procedures for examination {}: {}", id, e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                "success", false,
                "message", "Error fetching procedures: " + e.getMessage()
            ));
        }
    }

    @PostMapping("/examination/{examinationId}/procedure/{procedureId}/remove")
    @ResponseBody
    public ResponseEntity<?> removeProcedureFromExamination(
            @PathVariable Long examinationId,
            @PathVariable Long procedureId) {
        try {
            log.info("Removing procedure {} from examination {}", procedureId, examinationId);
            
            // Validate IDs
            if (examinationId == null || procedureId == null) {
                log.error("Invalid examination ID or procedure ID");
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Invalid examination ID or procedure ID"
                ));
            }
            
            // Check if the procedure is associated with the examination
            if (!toothClinicalExaminationService.isProcedureAlreadyAssociated(examinationId, procedureId)) {
                log.error("Procedure {} is not associated with examination {}", procedureId, examinationId);
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Procedure is not associated with this examination"
                ));
            }
            
            // Remove the procedure from the examination
            toothClinicalExaminationService.removeProcedureFromExamination(examinationId, procedureId);
            
            log.info("Successfully removed procedure {} from examination {}", procedureId, examinationId);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Procedure successfully removed from examination"
            ));
        } catch (Exception e) {
            log.error("Error removing procedure {} from examination {}: {}", 
                    procedureId, examinationId, e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                "success", false,
                "message", "Error removing procedure: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/examination/{examinationId}/lifecycle")
    public String showProcedureLifecycle(@PathVariable Long examinationId, Model model) {
        try {
            log.info("Loading lifecycle page for examination ID: {}", examinationId);
            
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            if (examinationOptional.isEmpty()) {
                log.warn("Examination not found for ID: {}", examinationId);
                return "redirect:/patients/examination";
            }

            ToothClinicalExamination examination = examinationOptional.get();
            Patient patient = examination.getPatient();
            ProcedurePrice procedure = examination.getProcedure();
            User treatingDoctor = examination.getAssignedDoctor();
            User opdDoctor = examination.getOpdDoctor();
            String paymentStatus = determinePaymentStatus(examination);

            log.info("Loading lifecycle stages for examination ID: {}", examinationId);
            // Get lifecycle stages from the service
            List<Map<String, Object>> lifecycleStages = lifecycleService.getFormattedLifecycleStages(examination);
            log.info("Successfully loaded {} lifecycle stages for examination ID: {}", lifecycleStages.size(), examinationId);

            // Get closure date from ProcedureLifecycleTransition
            List<ProcedureLifecycleTransition> transitions = procedureLifecycleTransitionRepository.findByExaminationOrderByTransitionTimeAsc(examination);
            LocalDateTime caseClosureDate = null;
            for (ProcedureLifecycleTransition t : transitions) {
                if ("CLOSED".equalsIgnoreCase(t.getStageName())) {
                    caseClosureDate = t.getTransitionTime();
                }
            }
            model.addAttribute("caseClosureDate", caseClosureDate);
            boolean canAttachMoreImages = false;
            if (examination.getProcedureStatus() == ProcedureStatus.CLOSED && caseClosureDate != null) {
                canAttachMoreImages = caseClosureDate.plusDays(3).isAfter(LocalDateTime.now());
            }
            model.addAttribute("canAttachMoreImages", canAttachMoreImages);

            // Get motivation quote for doctors
            MotivationQuote motivationQuote = motivationQuoteService.getRandomQuote().orElse(null);
            model.addAttribute("motivationQuote", motivationQuote);
            
            // Get follow-up records for this examination
            List<FollowUpRecord> followUpRecords = followUpService.getFollowUpsForExamination(examination);
            model.addAttribute("followUpRecords", followUpRecords);
            
            // Get follow-up statistics
            FollowUpService.FollowUpStatistics followUpStats = followUpService.getFollowUpStatistics(examination);
            model.addAttribute("followUpStats", followUpStats);
            
            model.addAttribute("examination", examination);
            model.addAttribute("patient", patient);
            model.addAttribute("procedure", procedure);
            model.addAttribute("doctor", treatingDoctor);
            model.addAttribute("opdDoctor", opdDoctor);
            model.addAttribute("paymentStatus", paymentStatus);
            model.addAttribute("lifecycleStages", lifecycleStages);

            return "patient/procedureLifecycle";
        } catch (Exception e) {
            log.error("Error loading lifecycle page for examination ID: {}", examinationId, e);
            model.addAttribute("errorMessage", "An error occurred while loading the lifecycle page. Please try again.");
            return "error";
        }
    }

    private String determinePaymentStatus(ToothClinicalExamination examination) {
        double totalPaid = examination.getTotalPaidAmount();
        double totalProcedureAmount = examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0.0;
        double remainingAmount = totalProcedureAmount - totalPaid;
        
        if (remainingAmount <= 0) {
            return "Full Payment Received";
        } else {
            return "₹" + String.format("%.2f", remainingAmount) + " Remaining";
        }
    }

    /**
     * Complete a procedure (mark procedure as completed)
     */
    @GetMapping("/examination/{examinationId}/complete")
    public String completeProcedure(@PathVariable Long examinationId, RedirectAttributes redirectAttributes) {
        try {
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            
            if (examinationOptional.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Examination not found");
                return "redirect:/patients/list";
            }
            
            ToothClinicalExamination examination = examinationOptional.get();
            examination.setProcedureStatus(ProcedureStatus.COMPLETED);
            examination.setUpdatedAt(LocalDateTime.now());
            
            toothClinicalExaminationService.saveExamination(examination);
            
            redirectAttributes.addFlashAttribute("success", "Procedure completed successfully");
            return "redirect:/patients/examination/" + examinationId + "/lifecycle";
        } catch (Exception e) {
            log.error("Error completing procedure: ", e);
            redirectAttributes.addFlashAttribute("error", "Error completing procedure: " + e.getMessage());
            return "redirect:/patients/examination/" + examinationId + "/lifecycle";
        }
    }
    
    /**
     * Show the follow-up scheduling form for an examination
     */
    @GetMapping("/examination/{examinationId}/schedule-followup")
    public String showExaminationFollowupForm(@PathVariable Long examinationId, Model model) {
        try {
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            
            if (examinationOptional.isEmpty()) {
                return "redirect:/patients/list?error=Examination not found";
            }
            
            ToothClinicalExamination examination = examinationOptional.get();
            model.addAttribute("examination", examination);
            model.addAttribute("examinationId", examinationId);
            model.addAttribute("patientName", examination.getPatient().getFirstName() + " " + examination.getPatient().getLastName());
            model.addAttribute("patient", examination.getPatient());
            
            // Get available doctors for the clinic
            List<User> doctors = userRepository.findByRoleAndClinic_Id(UserRole.DOCTOR, examination.getExaminationClinic().getId());
            model.addAttribute("doctors", doctors);
            
            return "patient/scheduleFollowup";
        } catch (Exception e) {
            log.error("Error showing examination follow-up form: ", e);
            return "redirect:/patients/list?error=Error loading follow-up form: " + e.getMessage();
        }
    }
    
    /**
     * Save the scheduled follow-up appointment for an examination
     */
    @PostMapping("/examination/{examinationId}/schedule-followup")
    public String saveExaminationFollowupSchedule(
            @PathVariable Long examinationId,
            @RequestParam("followupDate") String followupDateStr,
            @RequestParam("followupTime") String followupTimeStr,
            @RequestParam("followupNotes") String followupNotes,
            @RequestParam(value = "doctorId", required = false) Long doctorId,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            
            if (examinationOptional.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Examination not found");
                return "redirect:/patients/list";
            }
            
            ToothClinicalExamination examination = examinationOptional.get();
            
            // Parse date and time
            LocalDate followupDate = LocalDate.parse(followupDateStr);
            LocalDateTime followupDateTime = followupDate.atTime(Integer.parseInt(followupTimeStr.split(":")[0]), 
                                                               Integer.parseInt(followupTimeStr.split(":")[1]));
            
            // Get the doctor (use assigned doctor if no specific doctor selected)
            User doctor = null;
            if (doctorId != null) {
                doctor = userRepository.findById(doctorId).orElse(examination.getAssignedDoctor());
            } else {
                doctor = examination.getAssignedDoctor();
            }
            
            if (doctor == null) {
                redirectAttributes.addFlashAttribute("error", "No doctor available for follow-up appointment");
                return "redirect:/patients/examination/" + examinationId + "/schedule-followup";
            }
            
            // Check for conflicting appointments
            if (appointmentRepository.existsConflictingAppointment(doctor, followupDateTime)) {
                redirectAttributes.addFlashAttribute("error", "Doctor has a conflicting appointment at the selected time");
                return "redirect:/patients/examination/" + examinationId + "/schedule-followup";
            }
            
            // Create the appointment
            Appointment appointment = new Appointment();
            appointment.setPatient(examination.getPatient());
            appointment.setPatientName(examination.getPatient().getFirstName() + " " + examination.getPatient().getLastName());
            appointment.setPatientMobile(examination.getPatient().getPhoneNumber());
            appointment.setAppointmentDateTime(followupDateTime);
            appointment.setStatus(AppointmentStatus.SCHEDULED);
            appointment.setClinic(examination.getExaminationClinic());
            appointment.setDoctor(doctor);
            appointment.setNotes("Follow-up appointment for examination ID: " + examinationId + 
                                "\nTooth: " + examination.getToothNumber() + 
                                "\nProcedure: " + (examination.getProcedure() != null ? examination.getProcedure().getProcedureName() : "N/A") +
                                "\nFollow-up Instructions: " + followupNotes);
            
            // Debug logging
            log.info("Creating appointment with doctor: {} (ID: {}), status: {}", 
                doctor.getFirstName() + " " + doctor.getLastName(), doctor.getId(), appointment.getStatus());
            
            // Get current user as the booking person
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User currentUser = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            appointment.setAppointmentBookedBy(currentUser);
            
            // Save the appointment
            Appointment savedAppointment = appointmentRepository.save(appointment);
            log.info("Saved appointment ID: {}, Doctor: {}, Status: {}", 
                savedAppointment.getId(), 
                savedAppointment.getDoctor() != null ? savedAppointment.getDoctor().getFirstName() : "NULL",
                savedAppointment.getStatus());
            
            // Create follow-up record using the service
            FollowUpRecord followUpRecord = followUpService.createFollowUp(
                examination, 
                followupDateTime, 
                followupNotes, 
                doctorId
            );
            
            // Link the appointment to the follow-up record
            followUpRecord.setAppointment(savedAppointment);
            followUpService.updateFollowUpRecord(followUpRecord);
            
            // Save the examination and set status to FOLLOW_UP_SCHEDULED
            examination.setProcedureStatus(ProcedureStatus.FOLLOW_UP_SCHEDULED);
            examination.setUpdatedAt(LocalDateTime.now());
            toothClinicalExaminationService.saveExamination(examination);
            
            redirectAttributes.addFlashAttribute("success", 
                "Follow-up appointment scheduled for " + followupDateStr + " at " + followupTimeStr + 
                " (Follow-up #" + followUpRecord.getSequenceNumber() + ")");
            return "redirect:/patients/examination/" + examinationId + "/lifecycle";
        } catch (Exception e) {
            log.error("Error scheduling examination follow-up: ", e);
            redirectAttributes.addFlashAttribute("error", "Error scheduling follow-up: " + e.getMessage());
            return "redirect:/patients/examination/" + examinationId + "/schedule-followup";
        }
    }

    @PostMapping("/update-examination-status")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> updateProcedureStatusNew(@RequestBody Map<String, Object> request) {
        try {
            Long examinationId = Long.valueOf(request.get("examinationId").toString());
            String status = request.get("status").toString();
            
            log.info("Updating examination {} status to {}", examinationId, status);
            
            // Get the examination
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            // Validate status transition
            ProcedureStatus currentStatus = examination.getProcedureStatus();
            ProcedureStatus newStatus = ProcedureStatus.valueOf(status);

            // Check if there are any active (scheduled) follow-ups that would block transitions
            List<FollowUpRecord> followUpRecords = followUpService.getFollowUpsForExamination(examination);
            boolean hasActiveFollowUps = followUpRecords.stream()
                .anyMatch(followUp -> followUp.getStatus() == FollowUpStatus.SCHEDULED);

            // Block all transitions except FOLLOW_UP_COMPLETED if there are active follow-ups
            if (hasActiveFollowUps && newStatus != ProcedureStatus.FOLLOW_UP_COMPLETED) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Cannot change procedure status while follow-ups are scheduled. Please complete all scheduled follow-ups first."
                ));
            }

            // Block closing if payment is pending
            if (newStatus == ProcedureStatus.CLOSED && examination.getRemainingAmount() > 0) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Cannot close the case because payment is still pending. Please collect the full payment before closing the case."
                ));
            }
            
            if (!currentStatus.getAllowedTransitions().contains(newStatus)) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Invalid status transition from " + currentStatus + " to " + newStatus
                ));
            }
            
            // Update the status
            examination.setProcedureStatus(newStatus);
            
            // Set timestamps based on status
            if (newStatus == ProcedureStatus.IN_PROGRESS) {
                examination.setProcedureStartTime(LocalDateTime.now());
            } else if (newStatus == ProcedureStatus.COMPLETED) {
                examination.setProcedureEndTime(LocalDateTime.now());
            }
            
            // Save the examination
            toothClinicalExaminationRepository.save(examination);
            
            // Create a lifecycle transition record
            ProcedureLifecycleTransition transition = new ProcedureLifecycleTransition();
            transition.setExamination(examination);
            transition.setStageName(newStatus.toString());
            transition.setStageDescription(getStatusDescription(newStatus));
            transition.setTransitionTime(LocalDateTime.now());
            transition.setCompleted(true);
            transition.setTransitionedBy(getCurrentUser());
            procedureLifecycleTransitionRepository.save(transition);
            
            log.info("Successfully updated examination {} status from {} to {}", 
                    examinationId, currentStatus, newStatus);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Status updated successfully",
                "newStatus", newStatus.name(),
                "newStatusLabel", newStatus.getLabel()
            ));
            
        } catch (Exception e) {
            log.error("Error updating examination status: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @PostMapping("/update-examination-status-with-xray")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> updateProcedureStatusWithXray(
            @RequestParam("examinationId") Long examinationId,
            @RequestParam("status") String status,
            @RequestParam(value = "xrayPicture", required = false) MultipartFile xrayPicture) {
        try {
            log.info("Updating examination {} status to {} with X-ray", examinationId, status);
            
            // Validate that status is CLOSED
            if (!"CLOSED".equals(status)) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "This endpoint is only for closing cases with X-ray"
                ));
            }
            
            // Validate that X-ray picture is provided
            if (xrayPicture == null || xrayPicture.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "X-ray picture is required to close the case"
                ));
            }
            
            // Get the examination
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            // Validate status transition
            ProcedureStatus currentStatus = examination.getProcedureStatus();
            ProcedureStatus newStatus = ProcedureStatus.valueOf(status);
            
            // Block closing if payment is pending
            if (newStatus == ProcedureStatus.CLOSED && examination.getRemainingAmount() > 0) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Cannot close the case because payment is still pending. Please collect the full payment before closing the case."
                ));
            }
            
            if (!currentStatus.getAllowedTransitions().contains(newStatus)) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Invalid status transition from " + currentStatus + " to " + newStatus
                ));
            }
            
            // Save the X-ray picture
            String xrayPath = null;
            try {
                xrayPath = fileStorageService.storeFile(xrayPicture, "xray-pictures");
                log.info("Saved X-ray picture: {}", xrayPath);
            } catch (Exception e) {
                log.error("Error saving X-ray picture: {}", e.getMessage(), e);
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Error saving X-ray picture: " + e.getMessage()
                ));
            }
            
            // Update the examination with X-ray path and status
            examination.setXrayPicturePath(xrayPath);
            examination.setProcedureStatus(newStatus);
            examination.setProcedureEndTime(LocalDateTime.now());
            
            // Save the examination
            toothClinicalExaminationRepository.save(examination);
            
            // Create a lifecycle transition record
            ProcedureLifecycleTransition transition = new ProcedureLifecycleTransition();
            transition.setExamination(examination);
            transition.setStageName(newStatus.toString());
            transition.setStageDescription(getStatusDescription(newStatus));
            transition.setTransitionTime(LocalDateTime.now());
            transition.setCompleted(true);
            transition.setTransitionedBy(getCurrentUser());
            procedureLifecycleTransitionRepository.save(transition);
            
            log.info("Successfully closed examination {} with X-ray", examinationId);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Case closed successfully with X-ray",
                "newStatus", newStatus.name(),
                "newStatusLabel", newStatus.getLabel()
            ));
            
        } catch (Exception e) {
            log.error("Error closing examination with X-ray: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    @PostMapping("/examination/{examinationId}/save-notes")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> saveClinicalNotes(
            @PathVariable Long examinationId,
            @RequestBody Map<String, Object> request) {
        try {
            String notes = request.get("notes").toString();
            
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            if (examinationOptional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Examination not found"
                ));
            }
            
            ToothClinicalExamination examination = examinationOptional.get();
            examination.setExaminationNotes(notes);
            examination.setUpdatedAt(LocalDateTime.now());
            
            toothClinicalExaminationRepository.save(examination);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Clinical notes saved successfully"
            ));
            
        } catch (Exception e) {
            log.error("Error saving clinical notes: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    @GetMapping("/patients/search/registration")
    public String showRegistrationSearchPage() {
        return "patient/search-registration";
    }
    
    @GetMapping("/patients/search/registration/result")
    public String searchByRegistrationCode(@RequestParam String registrationCode, Model model) {
        try {
            PatientDTO patient = patientService.findByRegistrationCode(registrationCode);
            model.addAttribute("patient", patient);
            model.addAttribute("registrationCode", registrationCode);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        return "patient/search-registration";
    }

    private String getStatusDescription(ProcedureStatus status) {
        return switch (status) {
            case OPEN -> "Procedure opened and ready for payment verification";
            case PAYMENT_PENDING -> "Payment verification pending";
            case PAYMENT_COMPLETED -> "Payment verified and procedure can proceed";
            case PAYMENT_DENIED -> "Payment has been denied";
            case IN_PROGRESS -> "Procedure currently in progress";
            case ON_HOLD -> "Procedure temporarily on hold";
            case COMPLETED -> "Procedure fully completed";
            case FOLLOW_UP_SCHEDULED -> "Follow-up appointment scheduled";
            case FOLLOW_UP_COMPLETED -> "Follow-up appointment completed";
            case CLOSED -> "Procedure has been closed with X-ray";
            case CANCELLED -> "Procedure has been cancelled";
        };
    }
    
    private User getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("Current user not found"));
    }

    @PostMapping("/follow-up/{followUpId}/complete")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> completeFollowUp(
            @PathVariable Long followUpId,
            @RequestBody Map<String, Object> request) {
        try {
            String clinicalNotes = request.get("clinicalNotes").toString();
            
            FollowUpRecord followUpRecord = followUpService.completeFollowUp(followUpId, clinicalNotes);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Follow-up marked as completed successfully"
            ));
            
        } catch (Exception e) {
            log.error("Error completing follow-up: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @PostMapping("/follow-up/{followUpId}/reschedule")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> rescheduleFollowUp(
            @PathVariable Long followUpId,
            @RequestBody Map<String, Object> request) {
        try {
            String newDate = request.get("newDate").toString();
            String newTime = request.get("newTime").toString();
            String rescheduleNotes = request.containsKey("rescheduleNotes") ? request.get("rescheduleNotes").toString() : null;
            Long doctorId = request.containsKey("doctorId") && request.get("doctorId") != null && !request.get("doctorId").toString().isEmpty() ? Long.valueOf(request.get("doctorId").toString()) : null;
            
            LocalDate date = LocalDate.parse(newDate);
            LocalDateTime newScheduledDate = date.atTime(
                Integer.parseInt(newTime.split(":")[0]), 
                Integer.parseInt(newTime.split(":")[1])
            );
            
            FollowUpRecord followUpRecord = followUpService.rescheduleFollowUp(followUpId, newScheduledDate, rescheduleNotes, doctorId);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Follow-up rescheduled successfully"
            ));
            
        } catch (Exception e) {
            log.error("Error rescheduling follow-up: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @PostMapping("/follow-up/{followUpId}/cancel")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> cancelFollowUp(
            @PathVariable Long followUpId,
            @RequestBody Map<String, Object> request) {
        try {
            String reason = request.get("reason").toString();
            
            FollowUpRecord followUpRecord = followUpService.cancelFollowUp(followUpId, reason);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Follow-up cancelled successfully"
            ));
            
        } catch (Exception e) {
            log.error("Error cancelling follow-up: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    @PostMapping("/examination/{examinationId}/upload-xray")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> uploadXrayImages(
            @PathVariable Long examinationId,
            @RequestParam("xrayPictures") MultipartFile[] xrayPictures) {
        try {
            log.info("Uploading X-rays for examination ID: {}", examinationId);

            // Validate that at least one X-ray picture is provided
            if (xrayPictures == null || xrayPictures.length == 0) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "At least one X-ray picture is required"
                ));
            }

            // Get the examination
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));

            // Save each X-ray picture
            List<String> savedPaths = new ArrayList<>();
            for (MultipartFile xrayPicture : xrayPictures) {
                if (xrayPicture != null && !xrayPicture.isEmpty()) {
                    String xrayPath = fileStorageService.storeFile(xrayPicture, "xray-pictures");
                    log.info("Saved X-ray picture: {}", xrayPath);
                    savedPaths.add(xrayPath);

                    // Save MediaFile entry
                    MediaFile media = new MediaFile();
                    media.setExamination(examination);
                    media.setFilePath(xrayPath);
                    media.setFileType("xray");
                    mediaFileRepository.save(media);
                }
            }
            examination.setUpdatedAt(LocalDateTime.now());
            toothClinicalExaminationRepository.save(examination);

            log.info("Successfully uploaded {} X-rays for examination {}", savedPaths.size(), examinationId);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "X-ray(s) uploaded successfully",
                "xrayPaths", savedPaths
            ));
        } catch (Exception e) {
            log.error("Error uploading X-rays: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
}

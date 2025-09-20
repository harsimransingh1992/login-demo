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
import org.springframework.data.domain.Page;

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
import java.util.Date;
import java.time.ZoneId;
import javax.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import java.util.Optional;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.logindemo.model.MediaFile;
import com.example.logindemo.model.ProcedureLifecycleTransition;
import com.example.logindemo.model.ReopeningRecord;

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

    @Resource(name="procedurePriceRepository")
    private ProcedurePriceRepository procedurePriceRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private ProcedureLifecycleService lifecycleService;

    @Autowired
    private LocationUtil locationUtil;

    @Autowired
    private MotivationQuoteService motivationQuoteService;

    @Autowired
    private ClinicalFileService clinicalFileService;

    @Autowired
    private FollowUpService followUpService;

    @Autowired
    private MediaFileRepository mediaFileRepository;

    @Autowired
    private ReopeningRecordRepository reopeningRecordRepository;

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
    
    @ModelAttribute("patientColorCodes")
    public PatientColorCode[] patientColorCodes() {
        return PatientColorCode.values();
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
        
        // Add doctors from current clinic for appointment scheduling
        User currentUser = getCurrentUser();
        ClinicModel userClinic = currentUser.getClinic();
        if (userClinic != null) {
            List<User> clinicDoctors = userRepository.findByClinicAndRoleIn(
                userClinic, 
                List.of(com.example.logindemo.model.UserRole.DOCTOR, com.example.logindemo.model.UserRole.OPD_DOCTOR)
            );
            model.addAttribute("clinicDoctors", clinicDoctors);
        } else {
            model.addAttribute("clinicDoctors", new ArrayList<>());
        }
        
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
    public ResponseEntity<?> checkInPatient(@PathVariable Long id, @RequestBody(required = false) Map<String, Object> request) {
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

            // Check if patient is already checked in
            if (patient.getCheckedIn() != null && patient.getCheckedIn()) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of(
                        "success", false,
                        "message", "Patient is already checked in"
                    ));
            }

            // Get doctor ID from request if provided
            Long doctorId = null;
            if (request != null && request.get("doctorId") != null && !request.get("doctorId").toString().isEmpty()) {
                doctorId = Long.parseLong(request.get("doctorId").toString());
            }

            // Create new check-in record - Allow cross-clinic check-ins
            CheckInRecord checkInRecord = new CheckInRecord();
            checkInRecord.setPatient(patient);
            checkInRecord.setCheckInTime(LocalDateTime.now());
            checkInRecord.setCheckInClinic(loggedInUser);
            checkInRecord.setClinic(loggedInUser.getClinic());
            checkInRecord.setStatus(CheckInStatus.WAITING);
            
            // Set the assigned doctor if provided (from current clinic)
            if (doctorId != null) {
                User doctor = userRepository.findById(doctorId).orElse(null);
                if (doctor != null && doctor.getClinic().equals(loggedInUser.getClinic())) {
                    checkInRecord.setAssignedDoctor(doctor);
                }
            }

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
            
            // Set the assigned doctor if provided
            if (checkInRecord.getAssignedDoctor() != null) {
                appointment.setDoctor(checkInRecord.getAssignedDoctor());
            }

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
    public String getPatientDetails(@PathVariable Long id, 
                                   @RequestParam(defaultValue = "0") int page,
                                   @RequestParam(defaultValue = "10") int size,
                                   Model model) {

        Optional<Patient> patient = patientRepository.findById(id);
        
        if(patient.isPresent()) {
            model.addAttribute("patient", patient.get());
            
            // Get paginated examination history
            Page<ToothClinicalExaminationDTO> examinationPage = toothClinicalExaminationService.getToothClinicalExaminationForPatientIdPaginated(patient.get().getId(), page, size);
            model.addAttribute("examinationHistory", examinationPage.getContent());
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", examinationPage.getTotalPages());
            model.addAttribute("totalItems", examinationPage.getTotalElements());
            model.addAttribute("pageSize", size);
            
            // Get clinical files for the patient
            List<ClinicalFileDTO> clinicalFiles = clinicalFileService.getClinicalFilesByPatientId(patient.get().getId());
            model.addAttribute("clinicalFiles", clinicalFiles);
            
            // Get current user's clinic
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            // Add current user's role to model for frontend validation
            model.addAttribute("currentUserRole", currentUser.getRole());
            
            // Add current user to model for permission checks
            model.addAttribute("currentUser", currentUser);
            
            // Get doctors from the same clinic
            List<UserDTO> doctors = userService.getUsersByRoleAndClinic(UserRole.DOCTOR, currentUser.getClinic());
            List<UserDTO> opdDoctors = userService.getUsersByRoleAndClinic(UserRole.OPD_DOCTOR, currentUser.getClinic());
            List<UserDTO> allDoctors = new ArrayList<>();
            allDoctors.addAll(doctors);
            allDoctors.addAll(opdDoctors);
            model.addAttribute("doctorDetails", allDoctors);

            // Prepare duplicate permissions map keyed by exam id for easy lookup in JSP
            try {
                List<ToothClinicalExaminationDTO> exams = toothClinicalExaminationService.getToothClinicalExaminationForPatientId(patient.get().getId());
                Map<Long, Boolean> duplicateAllowed = new java.util.HashMap<>();
                for (ToothClinicalExaminationDTO examDto : exams) {
                    boolean sameClinic = examDto.getExaminationClinic() != null && currentUser.getClinic() != null
                        && java.util.Objects.equals(examDto.getExaminationClinic().getId(), currentUser.getClinic().getId());
                    boolean sameDate = false;
                    if (examDto.getExaminationDate() != null) {
                        try {
                            sameDate = java.time.LocalDate.now().equals(examDto.getExaminationDate().toLocalDate());
                        } catch (Exception ignore) { /* keep false */ }
                    }
                    boolean isOpdDoctor = false;
                    try {
                        // Attempt to fetch model for OPD doctor comparison
                        java.util.Optional<ToothClinicalExamination> examModelOpt = toothClinicalExaminationRepository.findById(examDto.getId());
                        if (examModelOpt.isPresent() && examModelOpt.get().getOpdDoctor() != null) {
                            isOpdDoctor = java.util.Objects.equals(examModelOpt.get().getOpdDoctor().getId(), currentUser.getId());
                        }
                    } catch (Exception ignore) { /* keep false */ }
                    // Allow OPD_DOCTOR role to duplicate regardless of being the OPD doctor
                    boolean canDuplicate = sameClinic && sameDate && (isOpdDoctor || currentUser.getRole() == UserRole.OPD_DOCTOR);
                    duplicateAllowed.put(examDto.getId(), canDuplicate);
                }
                model.addAttribute("duplicateAllowed", duplicateAllowed);
            } catch (Exception e) {
                log.warn("Could not prepare duplicate permissions: {}", e.getMessage());
            }
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
            
            // Get the examination entity to access payment calculation methods
            Optional<ToothClinicalExamination> entityOpt = toothClinicalExaminationRepository.findById(id);
            if (entityOpt.isPresent()) {
                ToothClinicalExamination entity = entityOpt.get();
                
                // Create an enriched DTO with refund calculations
                ToothClinicalExaminationDTO enrichedExamination = new ToothClinicalExaminationDTO() {
                    @Override
                    public Double getTotalPaidAmount() {
                        return entity.getTotalPaidAmount();
                    }
                    
                    @Override
                    public Double getTotalRefundedAmount() {
                        return entity.getTotalRefundedAmount();
                    }
                    
                    @Override
                    public Double getNetPaidAmount() {
                        return entity.getNetPaidAmount();
                    }
                };
                
                // Copy all properties from the original DTO
                modelMapper.map(examination, enrichedExamination);
                examination = enrichedExamination;
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
            List<UserDTO> opdDoctors = userService.getUsersByRoleAndClinic(UserRole.OPD_DOCTOR, currentUser.getClinic());
            List<UserDTO> allDoctors = new ArrayList<>();
            allDoctors.addAll(doctors);
            allDoctors.addAll(opdDoctors);
            model.addAttribute("doctorDetails", allDoctors);
            
            model.addAttribute("examination", examination);
            model.addAttribute("patient", patient.get());
            model.addAttribute("doctors", allDoctors);
            model.addAttribute("currentUserRole", currentUser.getRole());
            model.addAttribute("currentUser", currentUser);
            
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

    @GetMapping("/examination/{id}/update")
    public String showExaminationUpdatePage(@PathVariable Long id) {
        // Redirect to the examination details page where editing can be done
        return "redirect:/patients/examination/" + id;
    }

    @PostMapping("/examination/{id}/update")
    @ResponseBody
    public ResponseEntity<?> updateExamination(@PathVariable Long id, 
                                             @RequestParam(required = false) String toothCondition,
                                             @RequestParam(required = false) String existingRestoration,
                                             @RequestParam(required = false) String toothMobility,
                                             @RequestParam(required = false) String pocketDepth,
                                             @RequestParam(required = false) String bleedingOnProbing,
                                             @RequestParam(required = false) String plaqueScore,
                                             @RequestParam(required = false) String gingivalRecession,
                                             @RequestParam(required = false) String toothVitality,
                                             @RequestParam(required = false) String furcationInvolvement,
                                             @RequestParam(required = false) String toothSensitivity,
                                             @RequestParam(required = false) String examinationNotes,
                                             @RequestParam(required = false) String chiefComplaints,
                                             @RequestParam(required = false) String advised) {
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
            if (toothCondition != null && !toothCondition.trim().isEmpty()) {
                existingExamination.setToothCondition(ToothCondition.valueOf(toothCondition));
            }
            if (existingRestoration != null && !existingRestoration.trim().isEmpty()) {
                existingExamination.setExistingRestoration(ExistingRestoration.valueOf(existingRestoration));
            }
            if (toothMobility != null && !toothMobility.trim().isEmpty()) {
                existingExamination.setToothMobility(ToothMobility.valueOf(toothMobility));
            }
            if (pocketDepth != null && !pocketDepth.trim().isEmpty()) {
                existingExamination.setPocketDepth(PocketDepth.valueOf(pocketDepth));
            }
            if (bleedingOnProbing != null && !bleedingOnProbing.trim().isEmpty()) {
                existingExamination.setBleedingOnProbing(BleedingOnProbing.valueOf(bleedingOnProbing));
            }
            if (plaqueScore != null && !plaqueScore.trim().isEmpty()) {
                existingExamination.setPlaqueScore(PlaqueScore.valueOf(plaqueScore));
            }
            if (gingivalRecession != null && !gingivalRecession.trim().isEmpty()) {
                existingExamination.setGingivalRecession(GingivalRecession.valueOf(gingivalRecession));
            }
            if (toothVitality != null && !toothVitality.trim().isEmpty()) {
                existingExamination.setToothVitality(ToothVitality.valueOf(toothVitality));
            }
            if (furcationInvolvement != null && !furcationInvolvement.trim().isEmpty()) {
                existingExamination.setFurcationInvolvement(FurcationInvolvement.valueOf(furcationInvolvement));
            }
            if (toothSensitivity != null && !toothSensitivity.trim().isEmpty()) {
                existingExamination.setToothSensitivity(ToothSensitivity.valueOf(toothSensitivity));
            }
            if (examinationNotes != null && !examinationNotes.trim().isEmpty()) {
                existingExamination.setExaminationNotes(examinationNotes);
            }
            if (chiefComplaints != null && !chiefComplaints.trim().isEmpty()) {
                existingExamination.setChiefComplaints(chiefComplaints);
            }
            if (advised != null && !advised.trim().isEmpty()) {
                existingExamination.setAdvised(advised);
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

            // Gate by arch images instead of doctor assignment
            boolean hasUpperArch = false;
            boolean hasLowerArch = false;
            // Check legacy fields
            if (examinationModel.isPresent()) {
                ToothClinicalExamination exEntity = examinationModel.get();
                hasUpperArch = exEntity.getUpperDenturePicturePath() != null && !exEntity.getUpperDenturePicturePath().isEmpty();
                hasLowerArch = exEntity.getLowerDenturePicturePath() != null && !exEntity.getLowerDenturePicturePath().isEmpty();
            }
            // Also check media files repository
            if (!hasUpperArch) {
                hasUpperArch = !mediaFileRepository.findByExaminationIdAndFileType(id, "upper_arch").isEmpty();
            }
            if (!hasLowerArch) {
                hasLowerArch = !mediaFileRepository.findByExaminationIdAndFileType(id, "lower_arch").isEmpty();
            }
            if (!(hasUpperArch && hasLowerArch)) {
                log.warn("Attempt to access procedures for examination {} without both arch images uploaded (upper={}, lower={})", id, hasUpperArch, hasLowerArch);
                return "redirect:/patients/examination/" + id + "?error=Please upload both upper and lower arch pictures before starting a procedure";
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
            // Add doctors list and current user role for treating doctor assignment on selection page
            if (currentUser.isPresent()) {
                User user = currentUser.get();
                List<UserDTO> doctors = userService.getUsersByRoleAndClinic(UserRole.DOCTOR, user.getClinic());
                List<UserDTO> opdDoctors = userService.getUsersByRoleAndClinic(UserRole.OPD_DOCTOR, user.getClinic());
                List<UserDTO> allDoctors = new ArrayList<>();
                allDoctors.addAll(doctors);
                allDoctors.addAll(opdDoctors);
                model.addAttribute("doctors", allDoctors);
                model.addAttribute("currentUserRole", user.getRole());
            }
            
            // Explicitly add dental departments for tabs
            model.addAttribute("dentalDepartments", DentalDepartment.values());
            
            log.info("Successfully loaded procedure selection page for examination ID: {}", id);
            return "patient/procedureSelection";
        } catch (Exception e) {
            log.error("Error showing procedures for examination ID {}: {}", id, e.getMessage(), e);
            return "redirect:/welcome?error=Error loading procedures: " + e.getMessage();
        }
    }

    @PostMapping("/examination/upload-denture-pictures")
    @ResponseBody
    public ResponseEntity<?> uploadDenturePictures(
            @RequestParam("examinationId") Long examinationId,
            @RequestParam("upperDenturePicture") MultipartFile upperDenturePicture,
            @RequestParam("lowerDenturePicture") MultipartFile lowerDenturePicture) {
        try {
            if (examinationId == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examinationId"
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
            
            log.info("Uploading denture pictures for examination {}", examinationId);
            
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
            
            // Update the examination with denture picture paths
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            examination.setUpperDenturePicturePath(upperDenturePath);
            examination.setLowerDenturePicturePath(lowerDenturePath);
            toothClinicalExaminationRepository.save(examination);
            
            // Return success
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Denture pictures uploaded successfully",
                "upperDenturePath", upperDenturePath,
                "lowerDenturePath", lowerDenturePath
            ));
        } catch (Exception e) {
            log.error("Error uploading denture pictures: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
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
            
            // Validate that both denture pictures are provided - REMOVED REQUIREMENT
            // if (upperDenturePicture == null || upperDenturePicture.isEmpty()) {
            //     return ResponseEntity.badRequest().body(Map.of(
            //         "success", false,
            //         "message", "Upper denture picture is required"
            //     ));
            // }
            
            // if (lowerDenturePicture == null || lowerDenturePicture.isEmpty()) {
            //     return ResponseEntity.badRequest().body(Map.of(
            //         "success", false,
            //         "message", "Lower denture picture is required"
            //     ));
            // }
            
            log.info("Starting procedure {} for examination {}", procedureId, examinationId);
            
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
            
            // Save the denture pictures (only if provided)
            String upperDenturePath = null;
            String lowerDenturePath = null;
            
            try {
                // Save the files only if they are provided
                if (upperDenturePicture != null && !upperDenturePicture.isEmpty()) {
                    upperDenturePath = fileStorageService.storeFile(upperDenturePicture, "denture-pictures");
                    log.info("Saved upper denture picture: {}", upperDenturePath);
                }
                
                if (lowerDenturePicture != null && !lowerDenturePicture.isEmpty()) {
                    lowerDenturePath = fileStorageService.storeFile(lowerDenturePicture, "denture-pictures");
                    log.info("Saved lower denture picture: {}", lowerDenturePath);
                }
                
            } catch (Exception e) {
                log.error("Error saving denture pictures: {}", e.getMessage(), e);
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Error saving denture pictures: " + e.getMessage()
                ));
            }
            
            // Associate the procedure with the examination
            List<Long> procedureIdList = Collections.singletonList(procedureId);
            toothClinicalExaminationService.associateProceduresWithExamination(examinationId, procedureIdList);
            
            // Update the examination with denture picture paths (only if provided)
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            if (upperDenturePath != null) {
                examination.setUpperDenturePicturePath(upperDenturePath);
            }
            if (lowerDenturePath != null) {
                examination.setLowerDenturePicturePath(lowerDenturePath);
            }
            toothClinicalExaminationRepository.save(examination);
            
            // Return success and redirect to payment review page
            return ResponseEntity.ok(Map.of(
                "success", true,
                "procedureId", procedureId,
                "message", "Procedure started successfully",
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

            // Provide doctors list and current user role similar to examination details page
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            List<UserDTO> doctors = userService.getUsersByRoleAndClinic(UserRole.DOCTOR, currentUser.getClinic());
            List<UserDTO> opdDoctors = userService.getUsersByRoleAndClinic(UserRole.OPD_DOCTOR, currentUser.getClinic());
            List<UserDTO> allDoctors = new ArrayList<>();
            allDoctors.addAll(doctors);
            allDoctors.addAll(opdDoctors);
            model.addAttribute("doctorDetails", allDoctors);

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
            model.addAttribute("doctors", allDoctors);
            model.addAttribute("currentUserRole", currentUser.getRole());

            return "patient/procedureLifecycle";
        } catch (Exception e) {
            log.error("Error loading lifecycle page for examination ID: {}", examinationId, e);
            model.addAttribute("errorMessage", "An error occurred while loading the lifecycle page. Please try again.");
            return "error";
        }
    }

    private String determinePaymentStatus(ToothClinicalExamination examination) {
        double netPaid = examination.getNetPaidAmount();
        double totalProcedureAmount = examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0.0;
        double remainingAmount = totalProcedureAmount - netPaid;
        
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
            List<User> opdDoctors = userRepository.findByRoleAndClinic_Id(UserRole.OPD_DOCTOR, examination.getExaminationClinic().getId());
            List<User> allDoctors = new ArrayList<>();
            allDoctors.addAll(doctors);
            allDoctors.addAll(opdDoctors);
            model.addAttribute("doctors", allDoctors);
            
            return "patient/scheduleFollowup";
        } catch (Exception e) {
            log.error("Error showing examination follow-up form: ", e);
            return "redirect:/patients/list?error=Error loading follow-up form: " + e.getMessage();
        }
    }

    /**
     * Duplicate an examination with minimal fields (no procedure or amount)
     */
    @PostMapping("/examination/{examinationId}/duplicate")
    @ResponseBody
    public ResponseEntity<?> duplicateExamination(@PathVariable Long examinationId) {
        try {
            Optional<ToothClinicalExamination> optional = toothClinicalExaminationRepository.findById(examinationId);
            if (optional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Examination not found"
                ));
            }

            ToothClinicalExamination existing = optional.get();

            // Authorization and validation checks
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));

            // 1) Clinic must match
            if (existing.getExaminationClinic() == null || currentUser.getClinic() == null
                || !existing.getExaminationClinic().getId().equals(currentUser.getClinic().getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Cannot duplicate: examination clinic does not match current user's clinic"
                ));
            }

            // 2) Examination date must be today
            LocalDate examDate = existing.getExaminationDate() != null ? existing.getExaminationDate().toLocalDate() : null;
            if (examDate == null || !examDate.equals(LocalDate.now())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Cannot duplicate: examination date must be today"
                ));
            }

            // OPD doctor validation removed - any user can now duplicate examinations

            // Create a new examination copying requested clinical details
            ToothClinicalExamination duplicate = new ToothClinicalExamination();
            duplicate.setPatient(existing.getPatient());
            duplicate.setExaminationClinic(existing.getExaminationClinic());
            duplicate.setToothNumber(existing.getToothNumber());
            // Do not copy assigned doctor or OPD doctor as per request
            duplicate.setAssignedDoctor(null);
            duplicate.setOpdDoctor(null);

            // Copy clinical attributes
            duplicate.setChiefComplaints(existing.getChiefComplaints());
            duplicate.setExaminationNotes(existing.getExaminationNotes());
            duplicate.setBleedingOnProbing(existing.getBleedingOnProbing());
            duplicate.setExistingRestoration(existing.getExistingRestoration());
            duplicate.setFurcationInvolvement(existing.getFurcationInvolvement());
            duplicate.setGingivalRecession(existing.getGingivalRecession());
            duplicate.setPeriapicalCondition(existing.getPeriapicalCondition());
            duplicate.setPlaqueScore(existing.getPlaqueScore());
            duplicate.setPocketDepth(existing.getPocketDepth());
            duplicate.setToothCondition(existing.getToothCondition());
            duplicate.setToothMobility(existing.getToothMobility());
            duplicate.setToothSensitivity(existing.getToothSensitivity());
            duplicate.setToothVitality(existing.getToothVitality());
            duplicate.setAdvised(existing.getAdvised());

            // Copy images (both legacy paths)
            duplicate.setUpperDenturePicturePath(existing.getUpperDenturePicturePath());
            duplicate.setLowerDenturePicturePath(existing.getLowerDenturePicturePath());
            duplicate.setXrayPicturePath(existing.getXrayPicturePath());

            // Reset fields that should NOT be duplicated
            duplicate.setProcedure(null);
            duplicate.setTotalProcedureAmount(null);
            duplicate.setProcedureStatus(ProcedureStatus.OPEN);
            duplicate.setTreatmentStartingDate(null);

            // Dates
            duplicate.setExaminationDate(LocalDateTime.now());
            duplicate.setCreatedAt(LocalDateTime.now());
            duplicate.setUpdatedAt(LocalDateTime.now());

            ToothClinicalExamination saved = toothClinicalExaminationRepository.save(duplicate);

            // Copy media files (e.g., xray, upper_arch, lower_arch)
            try {
                List<MediaFile> mediaFiles = mediaFileRepository.findByExamination_Id(existing.getId());
                for (MediaFile mf : mediaFiles) {
                    MediaFile clone = new MediaFile();
                    clone.setExamination(saved);
                    clone.setFilePath(mf.getFilePath());
                    clone.setFileType(mf.getFileType());
                    clone.setUploadedAt(LocalDateTime.now());
                    mediaFileRepository.save(clone);
                }
            } catch (Exception mediaEx) {
                log.warn("Failed to copy media files for examination {} -> {}: {}", existing.getId(), saved.getId(), mediaEx.getMessage());
            }

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "newExaminationId", saved.getId()
            ));
        } catch (Exception e) {
            log.error("Error duplicating examination {}: {}", examinationId, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        }
    }

    @GetMapping("/examination/{examinationId}/details")
    @ResponseBody
    public ResponseEntity<?> getExaminationDetails(@PathVariable Long examinationId) {
        try {
            Optional<ToothClinicalExamination> optional = toothClinicalExaminationRepository.findById(examinationId);
            if (optional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Examination not found"
                ));
            }

            ToothClinicalExamination examination = optional.get();

            // Get treating doctor name
            String treatingDoctorName = null;
            if (examination.getDoctor() != null) {
                treatingDoctorName = examination.getDoctor().getFirstName() + " " + 
                                   examination.getDoctor().getLastName();
            }

            // Get procedure name and price
            String procedureName = null;
            Double procedurePrice = null;
            log.info("Examination ID: {}, Procedure: {}", examinationId, examination.getProcedure());
            if (examination.getProcedure() != null) {
                procedureName = examination.getProcedure().getProcedureName();
                procedurePrice = examination.getProcedure().getPrice();
                log.info("Procedure found - Name: {}, Price: {}", procedureName, procedurePrice);
            } else {
                log.warn("No procedure found for examination ID: {}", examinationId);
            }

            // Count attachments
            int attachmentCount = mediaFileRepository.countByExaminationId(examinationId);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "treatingDoctorName", treatingDoctorName != null ? treatingDoctorName : "",
                    "procedureName", procedureName != null ? procedureName : "",
                    "procedurePrice", procedurePrice != null ? procedurePrice : 0.0,
                    "attachmentCount", attachmentCount
            ));

        } catch (Exception e) {
            log.error("Error getting examination details: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "Error getting examination details: " + e.getMessage()
            ));
        }
    }

    @PostMapping("/examination/{examinationId}/duplicate-selective")
    @ResponseBody
    public ResponseEntity<?> duplicateExaminationSelective(
            @PathVariable Long examinationId,
            @RequestBody Map<String, Object> request) {
        try {
            Optional<ToothClinicalExamination> optional = toothClinicalExaminationRepository.findById(examinationId);
            if (optional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Examination not found"
                ));
            }

            ToothClinicalExamination existing = optional.get();

            // Authorization and validation checks (same as original)
            String currentUsername = PeriDeskUtils.getCurrentClinicUserName();
            User currentUser = userService.findByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("Current user not found"));

            // 1) Clinic must match
            if (existing.getExaminationClinic() == null || currentUser.getClinic() == null
                || !existing.getExaminationClinic().getId().equals(currentUser.getClinic().getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Cannot duplicate: examination clinic does not match current user's clinic"
                ));
            }

            // 2) Examination date must be today
            LocalDate examDate = existing.getExaminationDate() != null ? existing.getExaminationDate().toLocalDate() : null;
            if (examDate == null || !examDate.equals(LocalDate.now())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Cannot duplicate: examination date must be today"
                ));
            }

            // OPD doctor validation removed - any user can now duplicate examinations

            // Get selection parameters (matching frontend parameter names)
            boolean copyAttachments = Boolean.TRUE.equals(request.get("duplicateAttachments"));
            boolean copyTreatingDoctor = Boolean.TRUE.equals(request.get("duplicateTreatingDoctor"));
            boolean copyProcedure = Boolean.TRUE.equals(request.get("duplicateProcedure"));
            
            // Get target teeth from request
            @SuppressWarnings("unchecked")
            List<Integer> targetTeeth = (List<Integer>) request.get("targetTeeth");
            
            // Validate target teeth
            if (targetTeeth == null || targetTeeth.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "At least one tooth must be selected"
                ));
            }

            List<Long> createdExaminationIds = new ArrayList<>();
            
            // Create examination for each selected tooth
            for (Integer toothNumber : targetTeeth) {
                // Create a new examination copying basic clinical details
                ToothClinicalExamination duplicate = new ToothClinicalExamination();
                duplicate.setPatient(existing.getPatient());
                duplicate.setExaminationClinic(existing.getExaminationClinic());
                
                // Set the specific tooth number for this duplicate
                duplicate.setToothNumber(ToothNumber.valueOf("TOOTH_" + toothNumber));
                duplicate.setOpdDoctor(null); // Never copy OPD doctor

                // Conditionally copy treating doctor
                if (copyTreatingDoctor) {
                    duplicate.setAssignedDoctor(existing.getAssignedDoctor());
                } else {
                    duplicate.setAssignedDoctor(null);
                }

                // Copy clinical attributes (always copied)
                duplicate.setChiefComplaints(existing.getChiefComplaints());
                duplicate.setExaminationNotes(existing.getExaminationNotes());
                duplicate.setBleedingOnProbing(existing.getBleedingOnProbing());
                duplicate.setExistingRestoration(existing.getExistingRestoration());
                duplicate.setFurcationInvolvement(existing.getFurcationInvolvement());
                duplicate.setGingivalRecession(existing.getGingivalRecession());
                duplicate.setPeriapicalCondition(existing.getPeriapicalCondition());
                duplicate.setPlaqueScore(existing.getPlaqueScore());
                duplicate.setPocketDepth(existing.getPocketDepth());
                duplicate.setToothCondition(existing.getToothCondition());
                duplicate.setToothMobility(existing.getToothMobility());
                duplicate.setToothSensitivity(existing.getToothSensitivity());
                duplicate.setToothVitality(existing.getToothVitality());
                duplicate.setAdvised(existing.getAdvised());

                // Copy images (both legacy paths) - always copied
                duplicate.setUpperDenturePicturePath(existing.getUpperDenturePicturePath());
                duplicate.setLowerDenturePicturePath(existing.getLowerDenturePicturePath());
                duplicate.setXrayPicturePath(existing.getXrayPicturePath());

                // Conditionally copy procedure
                if (copyProcedure) {
                    duplicate.setProcedure(existing.getProcedure());
                    duplicate.setTotalProcedureAmount(existing.getTotalProcedureAmount());
                } else {
                    duplicate.setProcedure(null);
                    duplicate.setTotalProcedureAmount(null);
                }

                // Reset fields that should NOT be duplicated
                duplicate.setProcedureStatus(ProcedureStatus.OPEN);
                duplicate.setTreatmentStartingDate(null);

                // Dates
                duplicate.setExaminationDate(LocalDateTime.now());
                duplicate.setCreatedAt(LocalDateTime.now());
                duplicate.setUpdatedAt(LocalDateTime.now());

                ToothClinicalExamination saved = toothClinicalExaminationRepository.save(duplicate);
                createdExaminationIds.add(saved.getId());

                // Conditionally copy media files (attachments) for each examination
                if (copyAttachments) {
                    try {
                        List<MediaFile> mediaFiles = mediaFileRepository.findByExamination_Id(existing.getId());
                        for (MediaFile mf : mediaFiles) {
                            MediaFile clone = new MediaFile();
                            clone.setExamination(saved);
                            clone.setFilePath(mf.getFilePath());
                            clone.setFileType(mf.getFileType());
                            clone.setUploadedAt(LocalDateTime.now());
                            mediaFileRepository.save(clone);
                        }
                    } catch (Exception mediaEx) {
                        log.warn("Failed to copy media files for examination {} -> {}: {}", existing.getId(), saved.getId(), mediaEx.getMessage());
                    }
                }
            }

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "createdExaminationIds", createdExaminationIds,
                    "teethCount", targetTeeth.size(),
                    "message", "Successfully created " + targetTeeth.size() + " examinations for teeth: " + targetTeeth
            ));
        } catch (Exception e) {
            log.error("Error duplicating examination {}: {}", examinationId, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
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

    @PostMapping("/update-procedure-status")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> updateProcedureStatusNew(@RequestBody Map<String, Object> request) {
        log.info("=== ENDPOINT HIT: /update-procedure-status ===");
        log.info("Request received: {}", request);
        log.info("Request class: {}", request.getClass().getName());
        
        try {
            Long examinationId = Long.valueOf(request.get("examinationId").toString());
            String status = request.get("status").toString();
            
            log.info("=== STATUS UPDATE REQUEST ===");
            log.info("Examination ID: {}", examinationId);
            log.info("Requested Status: {}", status);
            
            // Get the examination
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            // Validate status transition
            ProcedureStatus currentStatus = examination.getProcedureStatus();
            ProcedureStatus newStatus = ProcedureStatus.valueOf(status);
            
            log.info("Current Status: {}", currentStatus);
            log.info("New Status: {}", newStatus);
            log.info("Allowed transitions from {}: {}", currentStatus, currentStatus.getAllowedTransitions());

            // Check if there are any active (scheduled) follow-ups that would block transitions
            List<FollowUpRecord> followUpRecords = followUpService.getFollowUpsForExamination(examination);
            boolean hasActiveFollowUps = followUpRecords.stream()
                .anyMatch(followUp -> followUp.getStatus() == FollowUpStatus.SCHEDULED);
            
            log.info("Follow-up records found: {}", followUpRecords.size());
            log.info("Has active follow-ups: {}", hasActiveFollowUps);
            if (hasActiveFollowUps) {
                log.info("Active follow-ups: {}", followUpRecords.stream()
                    .filter(followUp -> followUp.getStatus() == FollowUpStatus.SCHEDULED)
                    .map(FollowUpRecord::getId)
                    .collect(java.util.stream.Collectors.toList()));
            }

            // Block all transitions except Next-Sitting Completed, REOPEN->IN_PROGRESS, and status changes for already CLOSED cases if there are active follow-ups
            boolean isReopenToInProgress = (currentStatus == ProcedureStatus.REOPEN && newStatus == ProcedureStatus.IN_PROGRESS);
            boolean isFollowUpCompleted = (newStatus == ProcedureStatus.FOLLOW_UP_COMPLETED);
            boolean isAlreadyClosed = (currentStatus == ProcedureStatus.CLOSED);
            
            log.info("Is REOPEN->IN_PROGRESS transition: {}", isReopenToInProgress);
            log.info("Is Next-Sitting Completed transition: {}", isFollowUpCompleted);
            log.info("Is already CLOSED: {}", isAlreadyClosed);
            
            if (hasActiveFollowUps && !isFollowUpCompleted && !isReopenToInProgress && !isAlreadyClosed) {
                log.warn("BLOCKED: Cannot change procedure status while follow-ups are scheduled");
                return ResponseEntity.badRequest()
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(Map.of(
                        "success", false,
                        "message", "Cannot change procedure status while follow-ups are scheduled. Please complete all scheduled follow-ups first."
                    ));
            }

            // Block closing if payment is pending
            if (newStatus == ProcedureStatus.CLOSED && examination.getRemainingAmount() > 0) {
                log.warn("BLOCKED: Cannot close case with pending payment. Remaining amount: {}", examination.getRemainingAmount());
                return ResponseEntity.badRequest()
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(Map.of(
                        "success", false,
                        "message", "Cannot close the case because payment is still pending. Please collect the full payment before closing the case."
                    ));
            }
            
            if (!currentStatus.getAllowedTransitions().contains(newStatus)) {
                log.warn("BLOCKED: Invalid status transition from {} to {}", currentStatus, newStatus);
                return ResponseEntity.badRequest()
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(Map.of(
                        "success", false,
                        "message", "Invalid status transition from " + currentStatus + " to " + newStatus
                    ));
            }
            
            log.info("PROCEEDING: Status transition validation passed");
            
            // Update the status
            examination.setProcedureStatus(newStatus);
            
            // Set timestamps based on status
            if (newStatus == ProcedureStatus.IN_PROGRESS) {
                examination.setProcedureStartTime(LocalDateTime.now());
                log.info("Set procedure start time for IN_PROGRESS status");
            } else if (newStatus == ProcedureStatus.COMPLETED) {
                examination.setProcedureEndTime(LocalDateTime.now());
                log.info("Set procedure end time for COMPLETED status");
            }
            
            // Save the examination
            toothClinicalExaminationRepository.save(examination);
            log.info("Examination saved with new status: {}", newStatus);
            
            // Create a lifecycle transition record
            ProcedureLifecycleTransition transition = new ProcedureLifecycleTransition();
            transition.setExamination(examination);
            transition.setStageName(newStatus.toString());
            transition.setStageDescription(getStatusDescription(newStatus));
            transition.setTransitionTime(LocalDateTime.now());
            transition.setCompleted(true);
            transition.setTransitionedBy(getCurrentUser());
            procedureLifecycleTransitionRepository.save(transition);
            
            log.info("=== STATUS UPDATE SUCCESS ===");
            log.info("Successfully updated examination {} status from {} to {}", 
                    examinationId, currentStatus, newStatus);
            
            return ResponseEntity.ok()
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .body(Map.of(
                    "success", true,
                    "message", "Status updated successfully",
                    "newStatus", newStatus.name(),
                    "newStatusLabel", newStatus.getLabel()
                ));
            
        } catch (Exception e) {
            log.error("=== STATUS UPDATE ERROR ===");
            log.error("Error updating examination status: {}", e.getMessage(), e);
            return ResponseEntity.badRequest()
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .body(Map.of(
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
            String newNotes = request.get("notes").toString();
            
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            if (examinationOptional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Examination not found"
                ));
            }
            
            ToothClinicalExamination examination = examinationOptional.get();
            
            // Get current user and clinic information
            User currentUser = getCurrentUser();
            ClinicModel clinic = currentUser.getClinic();
            
            // Create timestamp
            LocalDateTime now = LocalDateTime.now();
            String timestamp = now.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a"));
            
            // Create user and clinic info
            String userInfo = currentUser.getFirstName() + " " + currentUser.getLastName();
            String clinicInfo = clinic != null ? clinic.getClinicName() + " (" + clinic.getClinicId() + ")" : "Unknown Clinic";
            
            // Format the new note entry
            String noteEntry = String.format("\n\n--- [%s] ---\nDr. %s | %s\n%s", 
                timestamp, userInfo, clinicInfo, newNotes);
            
            // Append to existing notes or create new
            String existingNotes = examination.getExaminationNotes();
            String updatedNotes = (existingNotes != null && !existingNotes.trim().isEmpty()) 
                ? existingNotes + noteEntry 
                : noteEntry;
            
            examination.setExaminationNotes(updatedNotes);
            examination.setUpdatedAt(now);
            
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
            case FOLLOW_UP_SCHEDULED -> "Next-sitting appointment scheduled";
            case FOLLOW_UP_COMPLETED -> "Next-sitting appointment completed";
            case CLOSED -> "Procedure has been closed with X-ray";
            case CANCELLED -> "Procedure has been cancelled";
            case REOPEN -> "Case has been reopened for additional treatment";
            default -> "Unknown status";
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

    @PostMapping("/{patientId}/update-color-code")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> updatePatientColorCode(
            @PathVariable Long patientId,
            @RequestBody Map<String, String> request) {
        
        try {
            String colorCodeStr = request.get("colorCode");
            if (colorCodeStr == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Color code is required"));
            }
            
            PatientColorCode colorCode;
            try {
                colorCode = PatientColorCode.valueOf(colorCodeStr);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Invalid color code"));
            }
            
            Optional<Patient> patientOpt = patientRepository.findById(patientId);
            if (patientOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }
            
            Patient patient = patientOpt.get();
            patient.setColorCode(colorCode);
            patientRepository.save(patient);
            
            log.info("Patient {} color code updated to {}", patientId, colorCode);
            
            return ResponseEntity.ok(Map.of("success", true, "message", "Color code updated successfully"));
            
        } catch (Exception e) {
            log.error("Error updating patient color code", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to update color code"));
        }
    }

    @PostMapping("/{patientId}/update-chairside-note")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> updateChairsideNote(
            @PathVariable Long patientId,
            @RequestBody Map<String, String> request) {
        
        try {
            String newNote = request.get("chairsideNote");
            if (newNote == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Hand over note is required"));
            }
            
            Optional<Patient> patientOpt = patientRepository.findById(patientId);
            if (patientOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }
            
            Patient patient = patientOpt.get();
            
            // Handle clearing notes (empty string)
            if (newNote.trim().isEmpty()) {
                patient.setChairsideNote("");
                patientRepository.save(patient);
                
                log.info("Patient {} hand over note cleared", patientId);
                
                return ResponseEntity.ok(Map.of(
                    "success", true, 
                    "message", "Hand over note cleared successfully",
                    "updatedNotes", ""
                ));
            }
            
            // Get current user and clinic information
            User currentUser = getCurrentUser();
            ClinicModel clinic = currentUser.getClinic();
            
            // Create timestamp
            LocalDateTime now = LocalDateTime.now();
            String timestamp = now.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a"));
            
            // Create user and clinic info
            String userInfo = currentUser.getFirstName() + " " + currentUser.getLastName();
            String clinicInfo = clinic != null ? clinic.getClinicName() + " (" + clinic.getClinicId() + ")" : "Unknown Clinic";
            
            // Format the new note entry
            String noteEntry = String.format("\n\n--- [%s] ---\nDr. %s | %s\n%s", 
                timestamp, userInfo, clinicInfo, newNote);
            
            // Append to existing notes or create new
            String existingNotes = patient.getChairsideNote();
            String updatedNotes = (existingNotes != null && !existingNotes.trim().isEmpty()) 
                ? existingNotes + noteEntry 
                : noteEntry;
            
            patient.setChairsideNote(updatedNotes);
            patientRepository.save(patient);
            
            log.info("Patient {} hand over note updated with timestamp", patientId);
            
                            return ResponseEntity.ok(Map.of(
                    "success", true, 
                    "message", "Hand over note updated successfully",
                    "updatedNotes", updatedNotes
                ));
            
        } catch (Exception e) {
            log.error("Error updating patient hand over note", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to update hand over note"));
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

    @PostMapping("/examination/upload-media-file")
    @ResponseBody
    public ResponseEntity<?> uploadMediaFile(
            @RequestParam("examinationId") Long examinationId,
            @RequestParam("file") MultipartFile file,
            @RequestParam("fileType") String fileType) {
        try {
            if (examinationId == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examinationId"
                ));
            }
            
            if (file == null || file.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "File is required"
                ));
            }
            
            if (fileType == null || fileType.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "File type is required"
                ));
            }
            
            // Validate file type
            String contentType = file.getContentType();
            String originalFilename = file.getOriginalFilename();
            
            // Check if it's an image or PDF
            boolean isImage = contentType != null && contentType.startsWith("image/");
            boolean isPdf = contentType != null && contentType.equals("application/pdf");
            
            if (!isImage && !isPdf) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Only image files (JPG, PNG, etc.) and PDF files are allowed"
                ));
            }
            
            // Validate file size (max 10MB for PDFs, 5MB for images)
            long maxSize = isPdf ? 10 * 1024 * 1024 : 5 * 1024 * 1024;
            if (file.getSize() > maxSize) {
                String maxSizeMB = isPdf ? "10MB" : "5MB";
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "File size must be less than " + maxSizeMB
                ));
            }
            
            log.info("Uploading media file for examination {} with type {} (content type: {})", 
                    examinationId, fileType, contentType);
            
            // Find the examination
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            // Determine storage directory based on file type
            String storageDirectory = isPdf ? "documents" : "dental-images";
            
            // Save the file
            String filePath = null;
            try {
                filePath = fileStorageService.storeFile(file, storageDirectory);
                log.info("Saved media file: {}", filePath);
            } catch (Exception e) {
                log.error("Error saving media file: {}", e.getMessage(), e);
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Error saving file: " + e.getMessage()
                ));
            }
            
            // Create MediaFile entity
            MediaFile mediaFile = new MediaFile();
            mediaFile.setExamination(examination);
            mediaFile.setFilePath(filePath);
            mediaFile.setFileType(fileType);
            mediaFile.setUploadedAt(LocalDateTime.now());
            
            // Save to database
            mediaFileRepository.save(mediaFile);
            
            // Return success
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "File uploaded successfully",
                "mediaFile", Map.of(
                    "id", mediaFile.getId(),
                    "filePath", mediaFile.getFilePath(),
                    "fileType", mediaFile.getFileType(),
                    "uploadedAt", mediaFile.getUploadedAt(),
                    "isPdf", isPdf,
                    "originalFilename", originalFilename
                )
            ));
        } catch (Exception e) {
            log.error("Error uploading media file: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @GetMapping("/examination/{examinationId}/media-files")
    @ResponseBody
    public ResponseEntity<?> getMediaFiles(@PathVariable Long examinationId) {
        try {
            List<MediaFile> mediaFiles = mediaFileRepository.findByExamination_Id(examinationId);
            
            List<Map<String, Object>> mediaFilesData = mediaFiles.stream()
                .map(file -> {
                    Map<String, Object> fileData = new HashMap<>();
                    fileData.put("id", file.getId());
                    fileData.put("filePath", file.getFilePath());
                    fileData.put("fileType", file.getFileType());
                    fileData.put("uploadedAt", file.getUploadedAt());
                    return fileData;
                })
                .collect(Collectors.toList());
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "mediaFiles", mediaFilesData
            ));
        } catch (Exception e) {
            log.error("Error fetching media files: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    @PostMapping("/examination/delete-media-file/{mediaFileId}")
    @ResponseBody
    public ResponseEntity<?> deleteMediaFile(@PathVariable Long mediaFileId) {
        try {
            MediaFile mediaFile = mediaFileRepository.findById(mediaFileId)
                .orElseThrow(() -> new RuntimeException("Media file not found"));
            
            // Delete the physical file
            try {
                fileStorageService.deleteFile(mediaFile.getFilePath());
            } catch (Exception e) {
                log.warn("Could not delete physical file: {}", e.getMessage());
            }
            
            // Delete from database
            mediaFileRepository.delete(mediaFile);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Media file deleted successfully"
            ));
        } catch (Exception e) {
            log.error("Error deleting media file: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    @GetMapping("/examination/fix-media-file")
    @ResponseBody
    public ResponseEntity<?> fixMediaFile() {
        try {
            List<MediaFile> mediaFiles = mediaFileRepository.findByExamination_Id(46L);
            if (!mediaFiles.isEmpty()) {
                MediaFile mediaFile = mediaFiles.get(0);
                mediaFile.setFilePath("dental-images/dc3de607-5eb8-45de-80e3-c15047712b1c.jpeg");
                mediaFileRepository.save(mediaFile);
                return ResponseEntity.ok(Map.of("success", true, "message", "MediaFile record updated successfully"));
            } else {
                return ResponseEntity.ok(Map.of("success", false, "message", "No MediaFile record found for examination 46"));
            }
        } catch (Exception e) {
            log.error("Error fixing media file: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    @PostMapping("/examination/{examinationId}/reopen")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> reopenCase(@PathVariable Long examinationId, @RequestBody Map<String, Object> request) {
        try {
            log.info("=== REOPEN CASE REQUEST ===");
            log.info("Examination ID: {}", examinationId);
            log.info("Request data: {}", request);
            
            // Get the examination
            ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));
            
            log.info("Current examination status: {}", examination.getProcedureStatus());
            log.info("Can be reopened: {}", examination.canBeReopened());
            
            // Check if case can be reopened
            if (!examination.canBeReopened()) {
                log.warn("BLOCKED: Case cannot be reopened. Current status: {}", examination.getProcedureStatus());
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Case cannot be reopened. Only closed cases can be reopened."
                ));
            }
            
            // Get current user (doctor)
            User currentUser = getCurrentUser();
            if (currentUser == null) {
                log.warn("BLOCKED: User not authenticated");
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "User not authenticated"
                ));
            }
            
            log.info("Reopening doctor: {} (ID: {})", currentUser.getUsername(), currentUser.getId());
            
            // Extract request data
            String reopeningReason = (String) request.get("reopeningReason");
            String notes = (String) request.get("notes");
            String patientCondition = (String) request.get("patientCondition");
            String treatmentPlan = (String) request.get("treatmentPlan");
            
            log.info("Reopening reason: {}", reopeningReason);
            log.info("Notes: {}", notes);
            log.info("Patient condition: {}", patientCondition);
            log.info("Treatment plan: {}", treatmentPlan);
            
            if (reopeningReason == null || reopeningReason.trim().isEmpty()) {
                log.warn("BLOCKED: Reopening reason is required");
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Reopening reason is required"
                ));
            }
            
            // Create reopening record
            ReopeningRecord reopeningRecord = new ReopeningRecord(
                examination,
                currentUser,
                currentUser.getClinic(),
                reopeningReason,
                examination.getProcedureStatus()
            );
            
            reopeningRecord.setNotes(notes);
            reopeningRecord.setPatientCondition(patientCondition);
            reopeningRecord.setTreatmentPlan(treatmentPlan);
            
            log.info("Created reopening record with sequence: {}", reopeningRecord.getReopeningSequence());
            
            // Save reopening record
            reopeningRecordRepository.save(reopeningRecord);
            log.info("Reopening record saved with ID: {}", reopeningRecord.getId());
            
            // Update examination status to REOPEN
            ProcedureStatus previousStatus = examination.getProcedureStatus();
            examination.setProcedureStatus(ProcedureStatus.REOPEN);
            examination.addReopeningRecord(reopeningRecord);
            toothClinicalExaminationRepository.save(examination);
            
            log.info("=== REOPEN CASE SUCCESS ===");
            log.info("Case reopened by doctor {} for examination {}", currentUser.getUsername(), examinationId);
            log.info("Status changed from {} to {}", previousStatus, examination.getProcedureStatus());
            log.info("Total reopen count: {}", examination.getReopenCount());
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Case reopened successfully",
                "reopenCount", examination.getReopenCount(),
                "reopenedBy", currentUser.getFirstName() + " " + currentUser.getLastName(),
                "reopenedAt", reopeningRecord.getReopenedAt()
            ));
            
        } catch (Exception e) {
            log.error("=== REOPEN CASE ERROR ===");
            log.error("Error reopening case for examination {}: {}", examinationId, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Error reopening case: " + e.getMessage()
            ));
        }
    }

    @PostMapping("/test-status-update")
    @ResponseBody
    public ResponseEntity<?> testStatusUpdate(@RequestBody Map<String, Object> request) {
        log.info("=== TEST ENDPOINT HIT ===");
        log.info("Test request received: {}", request);
        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "Test endpoint working",
            "receivedData", request
        ));
    }

    @GetMapping("/test-endpoint")
    @ResponseBody
    public ResponseEntity<?> testEndpoint() {
        log.info("=== TEST GET ENDPOINT HIT ===");
        return ResponseEntity.ok()
            .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
            .body(Map.of(
                "success", true,
                "message", "Test endpoint working",
                "timestamp", LocalDateTime.now().toString()
            ));
    }

    @PostMapping("/test-simple-update")
    @ResponseBody
    public ResponseEntity<?> testSimpleUpdate(@RequestParam Long examinationId, @RequestParam String status) {
        log.info("=== SIMPLE TEST ENDPOINT HIT ===");
        log.info("Examination ID: {}", examinationId);
        log.info("Status: {}", status);
        
        return ResponseEntity.ok()
            .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
            .body(Map.of(
                "success", true,
                "message", "Simple test endpoint working",
                "examinationId", examinationId,
                "status", status
            ));
    }
    
    @GetMapping("/my-appointments")
    public String showMyAppointments(Model model) {
        try {
            User currentUser = getCurrentUser();
            log.info("Loading appointments for user: {}", currentUser.getUsername());
            
            // Get appointments for the current user
            List<Appointment> userAppointments = appointmentRepository.findByDoctorOrderByAppointmentDateTimeDesc(currentUser);
            
            // Group appointments by date for calendar view
            Map<LocalDate, List<Appointment>> appointmentsByDate = userAppointments.stream()
                .collect(Collectors.groupingBy(appointment -> 
                    appointment.getAppointmentDateTime().toLocalDate()));
            
            // Get current month's appointments
            LocalDate today = LocalDate.now();
            LocalDate startOfMonth = today.withDayOfMonth(1);
            LocalDate endOfMonth = today.withDayOfMonth(today.lengthOfMonth());
            
            List<Appointment> currentMonthAppointments = userAppointments.stream()
                .filter(appointment -> {
                    LocalDate appointmentDate = appointment.getAppointmentDateTime().toLocalDate();
                    return !appointmentDate.isBefore(startOfMonth) && !appointmentDate.isAfter(endOfMonth);
                })
                .collect(Collectors.toList());
            
            // Get upcoming appointments (next 7 days)
            List<Appointment> upcomingAppointments = userAppointments.stream()
                .filter(appointment -> {
                    LocalDate appointmentDate = appointment.getAppointmentDateTime().toLocalDate();
                    return !appointmentDate.isBefore(today) && appointmentDate.isBefore(today.plusDays(7));
                })
                .collect(Collectors.toList());
            
            // Get today's appointments
            List<Appointment> todaysAppointments = userAppointments.stream()
                .filter(appointment -> 
                    appointment.getAppointmentDateTime().toLocalDate().equals(today))
                .collect(Collectors.toList());
            
            // Convert LocalDateTime to Date for JSP compatibility
            List<Map<String, Object>> todaysAppointmentsWithDate = todaysAppointments.stream()
                .map(appointment -> {
                    Map<String, Object> appointmentMap = new HashMap<>();
                    appointmentMap.put("id", appointment.getId());
                    appointmentMap.put("appointmentDateTime", Date.from(appointment.getAppointmentDateTime().atZone(ZoneId.systemDefault()).toInstant()));
                    appointmentMap.put("patient", appointment.getPatient());
                    appointmentMap.put("notes", appointment.getNotes());
                    appointmentMap.put("status", appointment.getStatus());
                    return appointmentMap;
                })
                .collect(Collectors.toList());
                
            List<Map<String, Object>> upcomingAppointmentsWithDate = upcomingAppointments.stream()
                .map(appointment -> {
                    Map<String, Object> appointmentMap = new HashMap<>();
                    appointmentMap.put("id", appointment.getId());
                    appointmentMap.put("appointmentDateTime", Date.from(appointment.getAppointmentDateTime().atZone(ZoneId.systemDefault()).toInstant()));
                    appointmentMap.put("patient", appointment.getPatient());
                    appointmentMap.put("notes", appointment.getNotes());
                    appointmentMap.put("status", appointment.getStatus());
                    return appointmentMap;
                })
                .collect(Collectors.toList());
                
            List<Map<String, Object>> currentMonthAppointmentsWithDate = currentMonthAppointments.stream()
                .map(appointment -> {
                    Map<String, Object> appointmentMap = new HashMap<>();
                    appointmentMap.put("id", appointment.getId());
                    appointmentMap.put("appointmentDateTime", Date.from(appointment.getAppointmentDateTime().atZone(ZoneId.systemDefault()).toInstant()));
                    appointmentMap.put("patient", appointment.getPatient());
                    appointmentMap.put("notes", appointment.getNotes());
                    appointmentMap.put("status", appointment.getStatus());
                    return appointmentMap;
                })
                .collect(Collectors.toList());
            
            model.addAttribute("userAppointments", userAppointments);
            model.addAttribute("appointmentsByDate", appointmentsByDate);
            model.addAttribute("currentMonthAppointments", currentMonthAppointmentsWithDate);
            model.addAttribute("upcomingAppointments", upcomingAppointmentsWithDate);
            model.addAttribute("todaysAppointments", todaysAppointmentsWithDate);
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("today", Date.from(today.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            model.addAttribute("startOfMonth", startOfMonth);
            model.addAttribute("endOfMonth", endOfMonth);
            
            log.info("Loaded {} appointments for user {}", userAppointments.size(), currentUser.getUsername());
            
            return "appointments/myAppointments";
        } catch (Exception e) {
            log.error("Error loading appointments: {}", e.getMessage(), e);
            model.addAttribute("errorMessage", "An error occurred while loading appointments. Please try again.");
            return "error";
        }
    }
    
    @PostMapping("/schedule-appointment")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> scheduleAppointment(@RequestBody Map<String, Object> request) {
        try {
            Long patientId = Long.parseLong(request.get("patientId").toString());
            String appointmentDate = request.get("appointmentDate").toString();
            String appointmentTime = request.get("appointmentTime").toString();
            String notes = request.get("notes") != null ? request.get("notes").toString() : "";
            Long doctorId = request.get("doctorId") != null && !request.get("doctorId").toString().isEmpty() ? 
                Long.parseLong(request.get("doctorId").toString()) : null;
            
            // Parse date and time
            LocalDateTime appointmentDateTime = LocalDateTime.parse(appointmentDate + "T" + appointmentTime);
            
            // Get current user and clinic
            User currentUser = getCurrentUser();
            ClinicModel clinic = currentUser.getClinic();
            
            // Get patient
            Optional<Patient> patientOptional = patientRepository.findById(patientId);
            if (patientOptional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Patient not found"
                ));
            }
            
            Patient patient = patientOptional.get();
            
            // Create appointment
            Appointment appointment = new Appointment();
            appointment.setPatient(patient);
            appointment.setPatientName(patient.getFirstName() + " " + patient.getLastName());
            appointment.setPatientMobile(patient.getPhoneNumber());
            appointment.setAppointmentDateTime(appointmentDateTime);
            appointment.setStatus(AppointmentStatus.SCHEDULED);
            appointment.setClinic(clinic);
            appointment.setAppointmentBookedBy(currentUser);
            appointment.setNotes(notes);
            
            // Set the assigned doctor if provided
            if (doctorId != null) {
                User doctor = userRepository.findById(doctorId).orElse(null);
                if (doctor != null && doctor.getClinic().equals(clinic)) {
                    appointment.setDoctor(doctor);
                }
            }
            
            // Save appointment
            Appointment savedAppointment = appointmentRepository.save(appointment);
            
            log.info("Appointment scheduled - ID: {}, Patient: {}, Date: {}, Time: {}", 
                savedAppointment.getId(), patient.getFirstName() + " " + patient.getLastName(), 
                appointmentDate, appointmentTime);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Appointment scheduled successfully",
                "appointmentId", savedAppointment.getId()
            ));
            
        } catch (Exception e) {
            log.error("Error scheduling appointment: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Failed to schedule appointment: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/my-appointments/api")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAppointmentsForDate(
            @RequestParam("date") String dateString,
            Authentication authentication) {
        try {
            User currentUser = getCurrentUser();
            log.info("Loading appointments for user: {} on date: {}", currentUser.getUsername(), dateString);
            
            // Parse the date string
            LocalDate selectedDate = LocalDate.parse(dateString);
            
            // Get appointments for the current user on the selected date
            List<Appointment> userAppointments = appointmentRepository.findByDoctorOrderByAppointmentDateTimeDesc(currentUser);
            
            List<Appointment> appointmentsForDate = userAppointments.stream()
                .filter(appointment -> 
                    appointment.getAppointmentDateTime().toLocalDate().equals(selectedDate))
                .collect(Collectors.toList());
            
            // Convert to DTO format for JSON response
            List<Map<String, Object>> appointmentsData = appointmentsForDate.stream()
                .map(appointment -> {
                    Map<String, Object> appointmentMap = new HashMap<>();
                    appointmentMap.put("id", appointment.getId());
                    appointmentMap.put("appointmentDateTime", appointment.getAppointmentDateTime().toString());
                    appointmentMap.put("patient", Map.of(
                        "id", appointment.getPatient().getId(),
                        "firstName", appointment.getPatient().getFirstName(),
                        "lastName", appointment.getPatient().getLastName()
                    ));
                    appointmentMap.put("notes", appointment.getNotes());
                    appointmentMap.put("status", appointment.getStatus());
                    return appointmentMap;
                })
                .collect(Collectors.toList());
            
            Map<String, Object> response = new HashMap<>();
            response.put("appointments", appointmentsData);
            response.put("date", selectedDate.toString());
            response.put("count", appointmentsForDate.size());
            
            log.info("Found {} appointments for date: {}", appointmentsForDate.size(), selectedDate);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error loading appointments for date: {}", e.getMessage(), e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "An error occurred while loading appointments");
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/examination/{examinationId}/payment-history")
    @ResponseBody
    public Map<String, Object> getExaminationPaymentHistory(@PathVariable Long examinationId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Get the examination
            Optional<ToothClinicalExamination> examinationOpt = toothClinicalExaminationRepository.findById(examinationId);
            if (examinationOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Examination not found");
                return response;
            }
            
            ToothClinicalExamination examination = examinationOpt.get();
            
            // Verify the examination belongs to the current clinic
            if (!examination.getExaminationClinic().getClinicId().equals(clinicId)) {
                response.put("success", false);
                response.put("message", "You don't have permission to view this examination");
                return response;
            }
            
            // Create examination data
            Map<String, Object> examinationData = new HashMap<>();
            examinationData.put("id", examination.getId());
            examinationData.put("toothNumber", examination.getToothNumber() != null ? examination.getToothNumber().toString() : "");
            examinationData.put("examinationDate", examination.getExaminationDate());
            examinationData.put("totalProcedureAmount", examination.getTotalProcedureAmount());
            
            // Add procedure info if available
            if (examination.getProcedure() != null) {
                Map<String, Object> procedureData = new HashMap<>();
                procedureData.put("id", examination.getProcedure().getId());
                procedureData.put("procedureName", examination.getProcedure().getProcedureName());
                procedureData.put("price", examination.getProcedure().getPrice());
                examinationData.put("procedure", procedureData);
            }
            
            // Get payment entries
            List<Map<String, Object>> paymentData = new ArrayList<>();
            double totalPaid = 0.0;
            double totalRefunded = 0.0;
            
            if (examination.getPaymentEntries() != null) {
                for (PaymentEntry entry : examination.getPaymentEntries()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("id", entry.getId());
                    payment.put("amount", entry.getAmount());
                    payment.put("paymentMode", entry.getPaymentMode().toString());
                    payment.put("paymentDate", entry.getPaymentDate().toString());
                    payment.put("notes", entry.getRemarks());
                    payment.put("transactionType", entry.getTransactionType() != null ? entry.getTransactionType().toString() : "CAPTURE");
                    
                    // Add recorded by info if available
                    if (entry.getRecordedBy() != null) {
                        payment.put("recordedBy", entry.getRecordedBy().getFirstName() + " " + entry.getRecordedBy().getLastName());
                    }
                    
                    if (entry.getAmount() != null) {
                        TransactionType transactionType = entry.getTransactionType();
                        if (transactionType == TransactionType.REFUND) {
                            totalRefunded += entry.getAmount();
                        } else {
                            totalPaid += entry.getAmount();
                        }
                    }
                    
                    paymentData.add(payment);
                }
            }
            
            // Sort payments by date (oldest first - chronological order)
            paymentData.sort((a, b) -> {
                String dateA = a.get("paymentDate").toString();
                String dateB = b.get("paymentDate").toString();
                return dateA.compareTo(dateB);
            });
            
            // Create summary
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalProcedureAmount", examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0);
            summary.put("totalPaid", totalPaid);
            summary.put("totalRefunded", totalRefunded);
            summary.put("netAmount", totalPaid - totalRefunded);
            summary.put("remaining", (examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0) - (totalPaid - totalRefunded));
            
            response.put("success", true);
            response.put("examination", examinationData);
            response.put("payments", paymentData);
            response.put("summary", summary);
            
        } catch (Exception e) {
            log.error("Error loading payment history for examination {}: {}", examinationId, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Error loading payment history: " + e.getMessage());
        }
        
        return response;
    }

    /**
     * Quick Add Examination endpoint - creates multiple examinations for selected teeth with a single procedure
     */
    @PostMapping("/{patientId}/examinations/quick-add")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> quickAddExaminations(
            @PathVariable Long patientId,
            @RequestParam("procedureId") Long procedureId,
            @RequestParam("teethNumbers") String teethNumbers) {
        try {
            // Get current user and clinic
            User currentUser = getCurrentUser();
            ClinicModel clinic = currentUser.getClinic();
            
            if (clinic == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "User clinic not found"
                ));
            }

            // Validate patient exists
            Optional<Patient> patientOptional = patientRepository.findById(patientId);
            if (patientOptional.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Patient not found"
                ));
            }
            Patient patient = patientOptional.get();

            // Validate procedure exists
            ProcedurePriceDTO procedureDTO = procedurePriceService.getProcedureById(procedureId);
            if (procedureDTO == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Procedure not found"
                ));
            }
            
            // Get the actual ProcedurePrice entity for setting in examination
            Optional<ProcedurePrice> procedureOpt = procedurePriceRepository.findById(procedureId);
            if (!procedureOpt.isPresent()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Procedure entity not found"
                ));
            }
            ProcedurePrice procedure = procedureOpt.get();

            // Parse teeth numbers
            String[] teethArray = teethNumbers.split(",");
            List<ToothNumber> selectedTeeth = new ArrayList<>();
            
            for (String toothStr : teethArray) {
                try {
                    int toothNum = Integer.parseInt(toothStr.trim());
                    // Convert number to ToothNumber enum
                    String toothEnumName = "TOOTH_" + toothNum;
                    try {
                        ToothNumber toothNumber = ToothNumber.valueOf(toothEnumName);
                        selectedTeeth.add(toothNumber);
                    } catch (IllegalArgumentException e) {
                        log.warn("Invalid tooth number: {}", toothNum);
                    }
                } catch (NumberFormatException e) {
                    log.warn("Invalid tooth number format: {}", toothStr);
                }
            }

            if (selectedTeeth.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "No valid teeth selected"
                ));
            }

            // Create examinations for each selected tooth
            List<ToothClinicalExamination> createdExaminations = new ArrayList<>();
            LocalDateTime now = LocalDateTime.now();

            for (ToothNumber toothNumber : selectedTeeth) {
                ToothClinicalExamination examination = new ToothClinicalExamination();
                examination.setPatient(patient);
                examination.setExaminationClinic(clinic);
                examination.setToothNumber(toothNumber);
                examination.setProcedure(procedure);
                examination.setTotalProcedureAmount(procedure.getPrice());
                examination.setProcedureStatus(ProcedureStatus.OPEN);
                examination.setExaminationDate(now);
                examination.setCreatedAt(now);
                examination.setUpdatedAt(now);
                
                // Set default values for required fields
                examination.setChiefComplaints("Quick Add - " + procedureDTO.getProcedureName());
                examination.setExaminationNotes("Created via Quick Add for tooth " + toothNumber.toString());
                
                ToothClinicalExamination saved = toothClinicalExaminationRepository.save(examination);
                createdExaminations.add(saved);
                
                log.info("Created examination {} for patient {} tooth {} with procedure {}", 
                    saved.getId(), patientId, toothNumber.toString(), procedureDTO.getProcedureName());
            }

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Successfully created " + createdExaminations.size() + " examination(s)",
                "examinationCount", createdExaminations.size(),
                "examinationIds", createdExaminations.stream().map(ToothClinicalExamination::getId).collect(Collectors.toList())
            ));

        } catch (Exception e) {
            log.error("Error creating quick add examinations for patient {}: {}", patientId, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Error creating examinations: " + e.getMessage()
            ));
        }
    }

    @DeleteMapping("/examination/{examinationId}/delete")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> deleteExamination(@PathVariable Long examinationId) {
        try {
            log.info("Delete examination request for examination ID: {}", examinationId);

            // Get current user
            User currentUser = getCurrentUser();
            
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "User not found"
                ));
            }

            // Check if user has permission to delete examinations
            if (!currentUser.getCanDeleteExamination()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "message", "You do not have permission to delete examinations"
                ));
            }

            // Find the examination
            Optional<ToothClinicalExamination> examinationOpt = toothClinicalExaminationRepository.findById(examinationId);
            if (!examinationOpt.isPresent()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Examination not found"
                ));
            }

            ToothClinicalExamination examination = examinationOpt.get();

            // Check if examination has any payments collected using the correct method
            Double totalPaid = examination.getTotalPaidAmount();
            boolean hasPayments = totalPaid != null && totalPaid > 0;
            
            if (hasPayments) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Cannot delete examination with collected payments. Amount paid: ₹" + totalPaid
                ));
            }

            // Check if examination has any procedure lifecycle transitions (started procedures)
            List<ProcedureLifecycleTransition> transitions = procedureLifecycleTransitionRepository.findByExaminationOrderByTransitionTimeAsc(examination);
            if (!transitions.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Cannot delete examination with started procedures. Please complete or cancel procedures first."
                ));
            }

            // Delete associated media files first
            List<MediaFile> mediaFiles = mediaFileRepository.findByExamination_Id(examinationId);
            for (MediaFile mediaFile : mediaFiles) {
                try {
                    // Delete physical file
                    fileStorageService.deleteFile(mediaFile.getFilePath());
                } catch (Exception e) {
                    log.warn("Failed to delete physical file: {}", mediaFile.getFilePath(), e);
                }
                mediaFileRepository.delete(mediaFile);
            }

            // Delete the examination
            toothClinicalExaminationRepository.delete(examination);

            log.info("Successfully deleted examination {} for patient {} tooth {}", 
                examinationId, examination.getPatient().getId(), examination.getToothNumber());

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Examination deleted successfully"
            ));

        } catch (Exception e) {
            log.error("Error deleting examination {}: {}", examinationId, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "message", "Error deleting examination: " + e.getMessage()
            ));
        }
    }
}

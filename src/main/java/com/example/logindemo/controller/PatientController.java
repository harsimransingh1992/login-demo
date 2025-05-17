package com.example.logindemo.controller;

import com.example.logindemo.dto.DoctorDetailDTO;
import com.example.logindemo.dto.OccupationDTO;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.ReferralDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.DoctorDetailService;
import com.example.logindemo.service.FileStorageService;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.service.ProcedurePriceService;
import com.example.logindemo.util.LocationUtil;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import java.beans.PropertyEditorSupport;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/patients")
@Slf4j
public class PatientController {

    @Resource(name="patientRepository")
    private PatientRepository patientRepository;

    @Resource(name="patientService")
    PatientService patientService;

    @Resource(name="toothClinicalExaminationService")
    private ToothClinicalExaminationService toothClinicalExaminationService;

    @Resource(name="doctorDetailService")
    private DoctorDetailService doctorDetailService;

    @Resource(name="procedurePriceService")
    private ProcedurePriceService procedurePriceService;

    @Resource(name="userRepository")
    private UserRepository userRepository;

    @Resource(name="fileStorageService")
    private FileStorageService fileStorageService;

    @Autowired
    private ModelMapper modelMapper;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        // Register custom editor for OccupationDTO
        binder.registerCustomEditor(OccupationDTO.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                if (text != null && !text.isEmpty()) {
                    OccupationDTO dto = new OccupationDTO();
                    dto.setName(text);
                    setValue(dto);
                } else {
                    setValue(null);
                }
            }
        });
        
        // Register custom editor for ReferralDTO
        binder.registerCustomEditor(ReferralDTO.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                if (text != null && !text.isEmpty()) {
                    ReferralDTO dto = new ReferralDTO();
                    dto.setName(text);
                    setValue(dto);
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
            } catch (IOException e) {
                log.error("Error handling profile picture upload", e);
                model.addAttribute("error", "Error uploading profile picture: " + e.getMessage());
                model.addAttribute("patient", patient);
                return "patient/register";
            }
        }

        patient.setRegistrationDate(new Date());
        
        // Register the patient with the profile picture path
        if (profilePicturePath != null) {
            patient.setProfilePicturePath(profilePicturePath);
        }
        
        patientService.registerPatient(patient);
        redirectAttributes.addFlashAttribute("success", "Patient registered successfully");
        return "redirect:/patients/list";
    }

    @GetMapping("/list")
    public String listPatients(Model model) {
        List<PatientDTO> patients= patientService.getAllPatients();
        model.addAttribute("patients", patients);
        return "patient/list";
    }

    @GetMapping("/search")
    public String searchPatients(@RequestParam String searchType, @RequestParam String query, Model model) {
        List<Patient> patients;
        if ("name".equals(searchType)) {
            patients = patientRepository.findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(query, query);
        } else if ("phone".equals(searchType)) {
            patients = patientRepository.findByPhoneNumberContaining(query);
        } else {
            patients = patientRepository.findAll();
        }
        model.addAttribute("patients", patients);
        return "patient/list";
    }

    @PostMapping("/checkin/{id}")
    public ResponseEntity<Void> checkInPatient(@PathVariable Long id) {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentClinicId=authentication.getName();
        log.info("Checking in patient {}", id);
        patientService.checkInPatient(id,currentClinicId);
        return ResponseEntity.ok().build();
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
        final String clinicUserName = PeriDeskUtils.getCurrentClinicUserName();
        List<DoctorDetailDTO> doctorDetails=doctorDetailService.findDoctorsByOnboardClinicUsername(clinicUserName);
        if(patient.isPresent()) {
            model.addAttribute("patient", patient.get());
            model.addAttribute("examinationHistory",toothClinicalExaminationService.getToothClinicalExaminationForPatientId(patient.get().getId()));
            model.addAttribute("doctorDetails", doctorDetails);
        }
        return "patient/patientDetails"; // Return the name of the patient details view
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        log.info("Showing edit form for patient {}", id);
        Optional<Patient> patientOpt = patientRepository.findById(id);
        if (patientOpt.isPresent()) {
            PatientDTO patientDTO = modelMapper.map(patientOpt.get(), PatientDTO.class);
            model.addAttribute("patient", patientDTO);
            return "patient/edit";
        } else {
            return "redirect:/patients/list";
        }
    }
    
    @PostMapping("/update")
    public String updatePatient(@ModelAttribute PatientDTO patient, 
                               @RequestParam(value = "profilePicture", required = false) MultipartFile profilePicture,
                               @RequestParam(value = "removeProfilePicture", required = false) String removeProfilePicture,
                               RedirectAttributes redirectAttributes) {
        log.info("Updating patient {}", patient.getId());
        try {
            // Handle profile picture upload if provided
            if (profilePicture != null && !profilePicture.isEmpty()) {
                log.info("New profile picture uploaded for patient {}", patient.getId());
                String profilePicturePath = patientService.handleProfilePictureUpload(profilePicture, patient.getId());
                patient.setProfilePicturePath(profilePicturePath);
            } 
            // Handle profile picture removal if requested
            else if ("true".equals(removeProfilePicture)) {
                log.info("Removing profile picture for patient {}", patient.getId());
                // Get current patient to find the profile picture path
                Optional<Patient> existingPatient = patientRepository.findById(Long.parseLong(patient.getId()));
                if (existingPatient.isPresent() && existingPatient.get().getProfilePicturePath() != null) {
                    // Delete the file
                    fileStorageService.deleteFile(existingPatient.get().getProfilePicturePath());
                }
                // Set path to null in the DTO
                patient.setProfilePicturePath(null);
            }
            
            patientService.updatePatient(patient);
            redirectAttributes.addFlashAttribute("success", "Patient updated successfully");
        } catch (Exception e) {
            log.error("Error updating patient", e);
            redirectAttributes.addFlashAttribute("error", "Error updating patient: " + e.getMessage());
        }
        return "redirect:/patients/list";
    }

    // Add endpoint to save tooth examination
    @PostMapping("/tooth-examination/save")
    @ResponseBody
    public ResponseEntity<?> saveToothExamination(@RequestBody ToothClinicalExaminationDTO request) {
        try {
            log.info("Saving tooth examination for tooth {} of patient {}",
                    request.getToothNumber(), request.getPatientId());
            patientService.saveExamination(request);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "toothNumber", request.getToothNumber()
            ));
        } catch (Exception e) {
            log.error("Error saving tooth examination", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        }
    }

    @PostMapping("/tooth-examination/assign-doctor")
    @ResponseBody
    public ResponseEntity<?> assignDoctorToExamination(@RequestBody Map<String, Long> request) {
        try {
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
            if (examination != null) {
                // Get the patient details
                Optional<Patient> patient = patientRepository.findById(examination.getPatientId());
                patient.ifPresent(value -> model.addAttribute("patient", value));
                
                // Get available doctors for this clinic
                final String clinicUserName = PeriDeskUtils.getCurrentClinicUserName();
                List<DoctorDetailDTO> doctorDetails = doctorDetailService.findDoctorsByOnboardClinicUsername(clinicUserName);
                
                model.addAttribute("examination", examination);
                model.addAttribute("doctorDetails", doctorDetails);
                return "patient/examinationDetails";
            } else {
                return "redirect:/welcome?error=Examination not found";
            }
        } catch (Exception e) {
            log.error("Error fetching examination details", e);
            return "redirect:/welcome?error=Error fetching examination details";
        }
    }
    
    @PostMapping("/examination/update")
    @ResponseBody
    public ResponseEntity<?> updateExamination(@RequestBody ToothClinicalExaminationDTO request) {
        try {
            if (request.getId() == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examination ID"
                ));
            }
            
            log.info("Updating examination {} for tooth {}", 
                request.getId(), request.getToothNumber());
            
            patientService.updateExamination(request);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Examination updated successfully"
            ));
        } catch (Exception e) {
            log.error("Error updating examination", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
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
            if (examination == null) {
                log.error("Examination not found for ID: {}", id);
                return "redirect:/welcome?error=Examination not found";
            }
            
            log.info("Found examination: id={}, toothNumber={}, patientId={}", 
                examination.getId(), examination.getToothNumber(), examination.getPatientId());
            
            // Check if a doctor is assigned to the examination
            if (examination.getAssignedDoctor() == null) {
                log.warn("Attempt to access procedures for examination {} without an assigned doctor", id);
                return "redirect:/patients/examination/" + id + "?error=Please assign a doctor before starting a procedure";
            }
            
            // Get the patient details
            Optional<Patient> patient = patientRepository.findById(examination.getPatientId());
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
            if (currentUser.isPresent() && currentUser.get().getCityTier() != null) {
                // Use the user's city tier directly to fetch relevant procedures
                CityTier userCityTier = currentUser.get().getCityTier();
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
            
            log.info("Successfully loaded procedure selection page for examination ID: {}", id);
            return "patient/procedureSelection";
        } catch (Exception e) {
            log.error("Error showing procedures for examination ID {}: {}", id, e.getMessage(), e);
            return "redirect:/welcome?error=Error loading procedures: " + e.getMessage();
        }
    }

    @PostMapping("/examination/start-procedure")
    @ResponseBody
    public ResponseEntity<?> startProcedure(@RequestBody Map<String, Long> request) {
        try {
            Long examinationId = request.get("examinationId");
            Long procedureId = request.get("procedureId");
            
            if (examinationId == null || procedureId == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Missing examinationId or procedureId"
                ));
            }
            
            log.info("Starting procedure {} for examination {}", procedureId, examinationId);
            
            // Here you would typically create a new procedure record in the database
            // For now, we'll just return success
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "procedureId", procedureId,
                "message", "Procedure started successfully"
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

}

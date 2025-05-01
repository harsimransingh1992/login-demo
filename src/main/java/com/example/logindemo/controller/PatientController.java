package com.example.logindemo.controller;

import com.example.logindemo.dto.DoctorDetailDTO;
import com.example.logindemo.dto.OccupationDTO;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.service.DoctorDetailService;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.service.ToothClinicalExaminationService;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import java.beans.PropertyEditorSupport;
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

    @ModelAttribute("indianStates")
    public List<IndianState> indianStates() {
        return LocationUtil.getAllStates();
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("patient", new Patient());
        return "patient/register";
    }

    @PostMapping("/register")
    public String registerPatient(@ModelAttribute PatientDTO patient, Model model, RedirectAttributes redirectAttributes) {
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

        patient.setRegistrationDate(new Date());
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
    public String updatePatient(@ModelAttribute PatientDTO patient, RedirectAttributes redirectAttributes) {
        log.info("Updating patient {}", patient.getId());
        try {
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

}

package com.example.logindemo.controller;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

import java.time.LocalDate;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Optional;

@RestController
@RequestMapping("/patients/tooth-examination")
@Slf4j
public class ToothExaminationController {

    @Autowired
    private PatientService patientService;

    @Autowired
    private ToothClinicalExaminationService toothClinicalExaminationService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping(value = "/save", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    @ResponseBody
    public ResponseEntity<?> saveExamination(
            @ModelAttribute ToothClinicalExaminationDTO examinationDTO,
            HttpServletRequest request) {
        
        // Log request details
        log.info("Received request to /save");
        log.info("Request method: {}", request.getMethod());
        log.info("Content type: {}", request.getContentType());
        
        // Log all request headers
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            log.info("Header {}: {}", headerName, request.getHeader(headerName));
        }
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (examinationDTO == null) {
                log.error("No examination data provided in request body");
                response.put("success", false);
                response.put("message", "No examination data provided");
                return ResponseEntity.badRequest().body(response);
            }

            log.info("Received examination data: {}", examinationDTO);
            
            // Get current user to check role and set as OPD doctor
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User currentUser = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
            
            // Check if user is a receptionist - prevent them from adding examinations
            if (currentUser.getRole() == UserRole.RECEPTIONIST) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Receptionists cannot perform clinical examinations"
                ));
            }
            
            // Check if patient is checked in before allowing tooth examination
            if (examinationDTO.getPatientId() != null) {
                try {
                    Optional<com.example.logindemo.model.Patient> patientOpt = patientService.getPatientById(examinationDTO.getPatientId());
                    if (patientOpt.isPresent()) {
                        com.example.logindemo.model.Patient patient = patientOpt.get();
                        if (!patient.getCheckedIn()) {
                            log.warn("User {} attempted to save tooth examination for unchecked patient {}", username, examinationDTO.getPatientId());
                            response.put("success", false);
                            response.put("message", "Patient must be checked in before adding new tooth examinations. Please check in the patient first.");
                            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
                        }
                    } else {
                        log.error("Patient not found with ID: {}", examinationDTO.getPatientId());
                        response.put("success", false);
                        response.put("message", "Patient not found. Please try again.");
                        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
                    }
                } catch (Exception e) {
                    log.error("Error checking patient status: {}", e.getMessage());
                    response.put("success", false);
                    response.put("message", "Error validating patient status. Please try again.");
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
                }
            }
            
            // Set the current user as OPD doctor
            examinationDTO.setOpdDoctorId(currentUser.getId());
            log.info("Set OPD doctor to: {}", currentUser.getFirstName() + " " + currentUser.getLastName());
            
            // Convert empty strings to null for enum fields
            if (examinationDTO.getBleedingOnProbing() != null && examinationDTO.getBleedingOnProbing().toString().isEmpty()) {
                examinationDTO.setBleedingOnProbing(null);
            }
            if (examinationDTO.getExistingRestoration() != null && examinationDTO.getExistingRestoration().toString().isEmpty()) {
                examinationDTO.setExistingRestoration(null);
            }
            if (examinationDTO.getFurcationInvolvement() != null && examinationDTO.getFurcationInvolvement().toString().isEmpty()) {
                examinationDTO.setFurcationInvolvement(null);
            }
            if (examinationDTO.getGingivalRecession() != null && examinationDTO.getGingivalRecession().toString().isEmpty()) {
                examinationDTO.setGingivalRecession(null);
            }
            if (examinationDTO.getPeriapicalCondition() != null && examinationDTO.getPeriapicalCondition().toString().isEmpty()) {
                examinationDTO.setPeriapicalCondition(null);
            }
            if (examinationDTO.getPocketDepth() != null && examinationDTO.getPocketDepth().toString().isEmpty()) {
                examinationDTO.setPocketDepth(null);
            }
            if (examinationDTO.getToothCondition() != null && examinationDTO.getToothCondition().toString().isEmpty()) {
                examinationDTO.setToothCondition(null);
            }
            if (examinationDTO.getToothMobility() != null && examinationDTO.getToothMobility().toString().isEmpty()) {
                examinationDTO.setToothMobility(null);
            }
            if (examinationDTO.getToothSensitivity() != null && examinationDTO.getToothSensitivity().toString().isEmpty()) {
                examinationDTO.setToothSensitivity(null);
            }
            if (examinationDTO.getToothVitality() != null && examinationDTO.getToothVitality().toString().isEmpty()) {
                examinationDTO.setToothVitality(null);
            }
            
            patientService.saveExamination(examinationDTO);
            
            response.put("success", true);
            response.put("message", "Examination saved successfully");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            return new ResponseEntity<>(response, headers, HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("Failed to save examination: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Failed to save examination: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping(value = "/update-treatment-date", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    @ResponseBody
    public ResponseEntity<?> updateTreatmentDate(@ModelAttribute Map<String, Object> request) {
        try {
            Long examinationId = Long.parseLong(request.get("examinationId").toString());
            String treatmentStartDate = (String) request.get("treatmentStartDate");
            
            log.info("Updating treatment date for examination {}: {}", examinationId, treatmentStartDate);
            
            ToothClinicalExaminationDTO updatedExamination = toothClinicalExaminationService.updateTreatmentDate(examinationId, treatmentStartDate);
            
            log.info("Successfully updated treatment date for examination {}", examinationId);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Treatment start date updated successfully",
                "data", updatedExamination
            ));
        } catch (Exception e) {
            log.error("Failed to update treatment date: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Failed to update treatment date: " + e.getMessage()
            ));
        }
    }

    @ExceptionHandler(Exception.class)
    @ResponseBody
    public ResponseEntity<?> handleException(Exception e, HttpServletRequest request) {
        log.error("Error processing request to {}: {}", request.getRequestURI(), e.getMessage(), e);
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", "An error occurred: " + e.getMessage());
        return ResponseEntity.badRequest().body(response);
    }
} 
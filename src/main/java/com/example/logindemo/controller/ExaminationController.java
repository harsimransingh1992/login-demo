package com.example.logindemo.controller;

import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.service.AuthorizationService;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;


@Controller
public class ExaminationController {

    @Autowired
    private ToothClinicalExaminationService examinationService;
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private AuthorizationService authorizationService;

    @Autowired
    private ModelMapper modelMapper;
    
    /**
     * Example of using @PreAuthorize for role-based authorization at the method level
     * Only users with DOCTOR or ADMIN role can access this endpoint
     */
    @PreAuthorize("hasAnyRole('DOCTOR', 'OPD_DOCTOR', 'ADMIN', 'CLINIC_OWNER')")
    public String showExaminationDetails(@PathVariable("id") Long id, Model model) {
        // Implementation would go here
        return "patient/procedures";
    }
    
    /**
     * Example of programmatic authorization checks with our custom AuthorizationService
     * This allows more fine-grained control than simple role checks
     */
    @PostMapping("/examination/update")
    public ResponseEntity<?> updateExamination(@RequestBody ToothClinicalExaminationDTO examinationDTO) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the existing examination to check permissions
            ToothClinicalExaminationDTO existingExamination = examinationService
                .getExaminationById(examinationDTO.getId())
                .orElse(null);
                
            if (existingExamination == null) {
                response.put("success", false);
                response.put("message", "Examination not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
            
            // Check if the current user is authorized to update this examination
            if (!authorizationService.canEditExamination(modelMapper.map(existingExamination, ToothClinicalExamination.class))) {
                response.put("success", false);
                response.put("message", "You are not authorized to update this examination");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }
            
            // Perform the update if authorized
            ToothClinicalExaminationDTO updated = examinationService.updateExamination(examinationDTO);
            
            response.put("success", true);
            response.put("message", "Examination updated successfully");
            response.put("examination", updated);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error updating examination: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Combination approach: Use @PreAuthorize for basic role check,
     * then use AuthorizationService for more complex logic
     */
    @PreAuthorize("hasAnyRole('DOCTOR', 'OPD_DOCTOR', 'ADMIN', 'CLINIC_OWNER')")
    @DeleteMapping("/patients/examination/{id}")
    public ResponseEntity<?> deleteExamination(@PathVariable("id") Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the existing examination to check permissions
            ToothClinicalExaminationDTO existingExamination = examinationService
                .getExaminationById(id)
                .orElse(null);
                
            if (existingExamination == null) {
                response.put("success", false);
                response.put("message", "Examination not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
            
            // Check if the current user is authorized to delete this examination
            // Admin can delete any, doctor can only delete own examinations
            if (!authorizationService.canEditExamination(modelMapper.map(existingExamination, ToothClinicalExamination.class))) {
                response.put("success", false);
                response.put("message", "You are not authorized to delete this examination");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }
            
            // Perform the delete if authorized
            examinationService.deleteExamination(id);
            
            response.put("success", true);
            response.put("message", "Examination deleted successfully");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error deleting examination: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
} 
package com.example.logindemo.controller;

import com.example.logindemo.model.PaymentMode;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.service.ConsultationChargesService;
import com.example.logindemo.service.ClinicService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
@Slf4j
public class ConsultationFeeController {

    @Autowired
    private ConsultationChargesService consultationChargesService;
    
    @Autowired
    private ClinicService clinicService;

    @GetMapping("/consultation-fee")
    @PreAuthorize("hasRole('RECEPTIONIST') or hasRole('ADMIN') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    public ResponseEntity<Map<String, Object>> getConsultationFee(@RequestParam(required = false) String clinicId) {
        try {
            // If no clinicId is provided, return error
            if (clinicId == null || clinicId.trim().isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Clinic ID is required");
                
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate that the clinic exists
            if (!clinicService.getClinicByClinicId(clinicId).isPresent()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Clinic not found with ID: " + clinicId);
                
                return ResponseEntity.badRequest().body(response);
            }
            
            Double consultationFee = consultationChargesService.getConsultationFee(clinicId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("consultationFee", consultationFee);
            response.put("clinicId", clinicId);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error getting consultation fee for clinic: {}", clinicId, e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to get consultation fee: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/consultation-fee/{clinicId}")
    @PreAuthorize("hasRole('RECEPTIONIST') or hasRole('ADMIN') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    public ResponseEntity<Map<String, Object>> getConsultationFeeByPath(@PathVariable String clinicId) {
        try {
            // Validate that the clinic exists
            if (!clinicService.getClinicByClinicId(clinicId).isPresent()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Clinic not found with ID: " + clinicId);
                
                return ResponseEntity.badRequest().body(response);
            }
            
            Double consultationFee = consultationChargesService.getConsultationFee(clinicId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("consultationFee", consultationFee);
            response.put("clinicId", clinicId);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error getting consultation fee for clinic: {}", clinicId, e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to get consultation fee: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/collect-consultation-charges")
    @PreAuthorize("hasRole('RECEPTIONIST') or hasRole('ADMIN') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    public ResponseEntity<Map<String, Object>> collectConsultationCharges(@RequestBody Map<String, Object> request) {
        try {
            // Extract parameters from request
            String patientIdStr = request.get("patientId").toString();
            String consultationFeeStr = request.get("consultationFee").toString();
            String paymentModeStr = request.get("paymentMode").toString();
            String paymentNotes = request.get("paymentNotes") != null ? request.get("paymentNotes").toString() : "";
            String treatingDoctorIdStr = request.get("treatingDoctorId") != null ? request.get("treatingDoctorId").toString() : null;

            // Validate and parse parameters
            Long patientId = Long.parseLong(patientIdStr);
            Double consultationFee = Double.parseDouble(consultationFeeStr);
            PaymentMode paymentMode = PaymentMode.valueOf(paymentModeStr);
            Long treatingDoctorId = treatingDoctorIdStr != null ? Long.parseLong(treatingDoctorIdStr) : null;

            // Call service to collect consultation charges
            ToothClinicalExamination examination = consultationChargesService.collectConsultationCharges(
                patientId, consultationFee, paymentMode, paymentNotes, treatingDoctorId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Consultation charges collected successfully");
            response.put("examinationId", examination.getId());

            return ResponseEntity.ok(response);
        } catch (NumberFormatException e) {
            log.error("Invalid number format in request: {}", e.getMessage());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Invalid number format in request");
            
            return ResponseEntity.badRequest().body(response);
        } catch (IllegalArgumentException e) {
            log.error("Invalid payment mode: {}", e.getMessage());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Invalid payment mode: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            log.error("Error collecting consultation charges: {}", e.getMessage(), e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to collect consultation charges: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/consultation-fee/recent")
    @PreAuthorize("hasRole('RECEPTIONIST') or hasRole('ADMIN') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    public ResponseEntity<Map<String, Object>> getRecentConsultation(@RequestParam Long patientId,
                                                                     @RequestParam String clinicId,
                                                                     @RequestParam(required = false, defaultValue = "30") int days) {
        try {
            if (clinicId == null || clinicId.trim().isEmpty()) {
                Map<String, Object> resp = new HashMap<>();
                resp.put("success", false);
                resp.put("message", "Clinic ID is required");
                return ResponseEntity.badRequest().body(resp);
            }

            if (!clinicService.getClinicByClinicId(clinicId).isPresent()) {
                Map<String, Object> resp = new HashMap<>();
                resp.put("success", false);
                resp.put("message", "Clinic not found with ID: " + clinicId);
                return ResponseEntity.badRequest().body(resp);
            }

            ToothClinicalExamination recent = consultationChargesService.findRecentConsultationPayment(patientId, clinicId, days);
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", true);
            resp.put("found", recent != null);
            if (recent != null) {
                java.time.LocalDateTime ts = recent.getExaminationDate() != null ? recent.getExaminationDate() : recent.getCreatedAt();
                String clinicName = recent.getExaminationClinic() != null ? recent.getExaminationClinic().getClinicName() : clinicId;
                java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
                resp.put("dateTime", ts != null ? ts.format(fmt) : null);
                resp.put("clinic", clinicName);
                resp.put("examinationId", recent.getId());
            }
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            log.error("Error checking recent consultation payment: {}", e.getMessage(), e);
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", false);
            resp.put("message", "Failed to check recent consultation payment: " + e.getMessage());
            return ResponseEntity.badRequest().body(resp);
        }
    }
}
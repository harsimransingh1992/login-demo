package com.example.logindemo.controller;

import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.service.RefundService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/refunds")
@Slf4j
public class RefundController {

    @Autowired
    private RefundService refundService;

    @Autowired
    private ToothClinicalExaminationService examinationService;

    @Autowired
    private UserService userService;

    /**
     * Show refund management page
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR') or hasRole('STAFF')")
    public String showRefundPage(Model model, Authentication authentication) {
        User currentUser = userService.findByUsername(authentication.getName())
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userRole", currentUser.getRole().name());
        
        return "refunds/refund-management";
    }

    /**
     * Process full refund
     */
    @PostMapping("/full/{examinationId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    @ResponseBody
    public ResponseEntity<?> processFullRefund(@PathVariable Long examinationId,
                                             @RequestParam String reason,
                                             Authentication authentication) {
        try {
            User currentUser = userService.findByUsername(authentication.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            ToothClinicalExaminationDTO examinationDTO = examinationService.getToothClinicalExaminationById(examinationId);
            if (examinationDTO == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("success", false, "message", "Examination not found"));
            }
            
            // Convert DTO to entity for refund service
            ToothClinicalExamination examination = convertDTOToEntity(examinationDTO);
            
            // Additional check for doctors - they can only refund their own cases
            if (!refundService.canUserProcessRefund(currentUser, examination)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "message", "You can only refund your own examinations"));
            }
            
            PaymentEntry refund = refundService.processFullRefund(examinationId, reason, currentUser);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Full refund processed successfully");
            response.put("refundAmount", Math.abs(refund.getAmount()));
            response.put("refundId", refund.getId());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error processing full refund for examination {}: {}", examinationId, e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Process partial refund
     */
    @PostMapping("/partial/{examinationId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    @ResponseBody
    public ResponseEntity<?> processPartialRefund(@PathVariable Long examinationId,
                                                @RequestParam Double amount,
                                                @RequestParam(required = false) Long originalPaymentId,
                                                @RequestParam String reason,
                                                Authentication authentication) {
        try {
            User currentUser = userService.findByUsername(authentication.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            ToothClinicalExaminationDTO examinationDTO = examinationService.getToothClinicalExaminationById(examinationId);
            if (examinationDTO == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("success", false, "message", "Examination not found"));
            }
            
            // Convert DTO to entity for refund service
            ToothClinicalExamination examination = convertDTOToEntity(examinationDTO);
            
            // Additional check for doctors - they can only refund their own cases
            if (!refundService.canUserProcessRefund(currentUser, examination)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "message", "You can only refund your own examinations"));
            }
            
            PaymentEntry refund = refundService.processPartialRefund(examinationId, amount, 
                                                                   originalPaymentId, reason, currentUser);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Partial refund processed successfully");
            response.put("refundAmount", Math.abs(refund.getAmount()));
            response.put("refundId", refund.getId());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error processing partial refund for examination {}: {}", examinationId, e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Get refund history for an examination
     */
    @GetMapping("/history/{examinationId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR') or hasRole('STAFF')")
    @ResponseBody
    public ResponseEntity<List<PaymentEntry>> getRefundHistory(@PathVariable Long examinationId) {
        try {
            List<PaymentEntry> refunds = refundService.getRefundHistory(examinationId);
            return ResponseEntity.ok(refunds);
        } catch (Exception e) {
            log.error("Error getting refund history for examination {}: {}", examinationId, e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    /**
     * Get refundable payments for an examination
     */
    @GetMapping("/refundable-payments/{examinationId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getRefundablePayments(@PathVariable Long examinationId) {
        try {
            log.debug("Getting refundable payments for examination: {}", examinationId);
            List<PaymentEntry> payments = refundService.getRefundablePayments(examinationId);
            log.debug("Found {} refundable payments", payments.size());
            
            // Convert to DTOs to avoid circular reference issues
            List<Map<String, Object>> paymentDTOs = payments.stream()
                .map(payment -> {
                    try {
                        Map<String, Object> dto = new HashMap<>();
                        dto.put("id", payment.getId());
                        dto.put("amount", payment.getAmount());
                        dto.put("paymentMode", payment.getPaymentMode() != null ? payment.getPaymentMode().toString() : "UNKNOWN");
                        dto.put("paymentDate", payment.getPaymentDate() != null ? payment.getPaymentDate().toString() : "");
                        dto.put("transactionType", payment.getTransactionType() != null ? payment.getTransactionType().toString() : "CAPTURE");
                        dto.put("remarks", payment.getRemarks() != null ? payment.getRemarks() : "");
                        dto.put("transactionReference", payment.getTransactionReference() != null ? payment.getTransactionReference() : "");
                        dto.put("recordedBy", payment.getRecordedBy() != null ? 
                            (payment.getRecordedBy().getFirstName() + " " + payment.getRecordedBy().getLastName()).trim() : "Unknown");
                        return dto;
                    } catch (Exception e) {
                        log.error("Error converting payment {} to DTO: {}", payment.getId(), e.getMessage());
                        // Return a minimal DTO to avoid breaking the entire response
                        Map<String, Object> dto = new HashMap<>();
                        dto.put("id", payment.getId());
                        dto.put("amount", payment.getAmount());
                        dto.put("paymentMode", "UNKNOWN");
                        dto.put("paymentDate", "");
                        dto.put("transactionType", "CAPTURE");
                        dto.put("remarks", "");
                        dto.put("transactionReference", "");
                        dto.put("recordedBy", "Unknown");
                        return dto;
                    }
                })
                .collect(Collectors.toList());
                
            log.debug("Successfully converted {} payments to DTOs", paymentDTOs.size());
            return ResponseEntity.ok(paymentDTOs);
        } catch (Exception e) {
            log.error("Error getting refundable payments for examination {}: {}", examinationId, e.getMessage(), e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Failed to load refundable payments");
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(List.of(errorResponse));
        }
    }

    /**
     * Search patient for refund processing
     */
    @GetMapping("/search-patient")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR') or hasRole('STAFF')")
    @ResponseBody
    public ResponseEntity<?> searchPatient(@RequestParam String registrationCode) {
        try {
            // This will reuse the existing search functionality from PendingPaymentController
            // For now, return a placeholder response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Search functionality will be integrated");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Convert DTO to entity for refund operations
     */
    private ToothClinicalExamination convertDTOToEntity(ToothClinicalExaminationDTO dto) {
        // For refund operations, we need a minimal entity with the required fields
        // This is a simplified conversion - in a real application, you might want to use ModelMapper
        ToothClinicalExamination entity = new ToothClinicalExamination();
        entity.setId(dto.getId());
        
        // Set assigned doctor if available
        if (dto.getAssignedDoctorId() != null) {
            Optional<UserDTO> assignedDoctorDTO = userService.getUserById(dto.getAssignedDoctorId());
            if (assignedDoctorDTO.isPresent()) {
                User assignedDoctor = new User();
                assignedDoctor.setId(assignedDoctorDTO.get().getId());
                assignedDoctor.setUsername(assignedDoctorDTO.get().getUsername());
                entity.setAssignedDoctor(assignedDoctor);
            }
        }
        
        // Set OPD doctor if available
        if (dto.getOpdDoctorId() != null) {
            Optional<UserDTO> opdDoctorDTO = userService.getUserById(dto.getOpdDoctorId());
            if (opdDoctorDTO.isPresent()) {
                User opdDoctor = new User();
                opdDoctor.setId(opdDoctorDTO.get().getId());
                opdDoctor.setUsername(opdDoctorDTO.get().getUsername());
                entity.setOpdDoctor(opdDoctor);
            }
        }
        
        return entity;
    }
}
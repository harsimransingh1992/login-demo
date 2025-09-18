package com.example.logindemo.controller;

import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.PaymentMode;
import com.example.logindemo.model.TransactionType;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.utils.PeriDeskUtils;
import com.example.logindemo.service.PaymentFilterService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.ArrayList;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/payments")
public class PendingPaymentController {

    @Autowired
    private ToothClinicalExaminationService examinationService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;
    
    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private PaymentFilterService paymentFilterService;

    @GetMapping("/pending")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    public String showPendingPayments(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false, defaultValue = "pending") String filterType,
            Model model) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = modelMapper.map(
            userService.getUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found")),
            User.class
        );
        String clinicId = user.getClinic().getClinicId();
        List<ToothClinicalExamination> results;
        if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            LocalDateTime start = LocalDate.parse(startDate).atStartOfDay();
            LocalDateTime end = LocalDate.parse(endDate).atTime(LocalTime.MAX);
            if ("all".equalsIgnoreCase(filterType)) {
                results = paymentFilterService.getAllPaymentsByDateRange(start, end);
            } else {
                results = paymentFilterService.getPendingPaymentsByTreatmentStartDateAndClinic(
                    start, end, clinicId);
            }
        } else {
            results = examinationService.findByProcedureStatusAndExaminationClinic_ClinicId(
                ProcedureStatus.PAYMENT_PENDING, clinicId);
        }
        model.addAttribute("pendingExaminations", results);
        return "payments/pending";
    }

    @GetMapping("/today-pending")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> getTodayPendingPayments() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Get today's pending examinations for the clinic
            List<ToothClinicalExamination> todayPendingExaminations = examinationService.findTodayPendingExaminations(clinicId);
            
            List<Map<String, Object>> examinationData = new ArrayList<>();
            
            for (ToothClinicalExamination exam : todayPendingExaminations) {
                Map<String, Object> examData = new HashMap<>();
                examData.put("id", exam.getId());
                examData.put("toothNumber", exam.getToothNumber() != null ? exam.getToothNumber().toString() : "");
                examData.put("examinationDate", exam.getExaminationDate());
                examData.put("totalProcedureAmount", exam.getTotalProcedureAmount());
                
                // Calculate total paid amount
                double totalPaid = 0.0;
                if (exam.getPaymentEntries() != null) {
                    for (PaymentEntry entry : exam.getPaymentEntries()) {
                        if (entry.getAmount() != null) {
                            totalPaid += entry.getAmount();
                        }
                    }
                }
                examData.put("totalPaidAmount", totalPaid);
                examData.put("remainingAmount", (exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0) - totalPaid);
                
                // Add patient info
                if (exam.getPatient() != null) {
                    Map<String, Object> patientData = new HashMap<>();
                    patientData.put("id", exam.getPatient().getId());
                    patientData.put("firstName", exam.getPatient().getFirstName());
                    patientData.put("lastName", exam.getPatient().getLastName());
                    patientData.put("registrationCode", exam.getPatient().getRegistrationCode());
                    patientData.put("phoneNumber", exam.getPatient().getPhoneNumber());
                    examData.put("patient", patientData);
                }
                
                // Add clinic info if available
                if (exam.getExaminationClinic() != null) {
                    Map<String, Object> clinicData = new HashMap<>();
                    clinicData.put("id", exam.getExaminationClinic().getId());
                    clinicData.put("clinicName", exam.getExaminationClinic().getClinicName());
                    clinicData.put("clinicId", exam.getExaminationClinic().getClinicId());
                    examData.put("clinic", clinicData);
                }
                
                // Add procedure info if available
                if (exam.getProcedure() != null) {
                    Map<String, Object> procedureData = new HashMap<>();
                    procedureData.put("id", exam.getProcedure().getId());
                    procedureData.put("procedureName", exam.getProcedure().getProcedureName());
                    procedureData.put("price", exam.getProcedure().getPrice());
                    examData.put("procedure", procedureData);
                }
                
                examinationData.add(examData);
            }
            
            response.put("success", true);
            response.put("examinations", examinationData);
            response.put("count", examinationData.size());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error loading today's pending payments: " + e.getMessage());
        }
        
        return response;
    }

    @GetMapping("/examinations")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR') or hasRole('STAFF') or hasRole('RECEPTIONIST')")
    @ResponseBody
    public List<ToothClinicalExamination> getExaminationsByPatient(@RequestParam Long patientId) {
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Find all examinations for this patient in the current clinic
            List<ToothClinicalExamination> examinations = examinationService.findByPatient_IdAndExaminationClinic_ClinicId(patientId, clinicId);
            
            // Calculate refund-related amounts for each examination
            for (ToothClinicalExamination exam : examinations) {
                // These methods are already implemented in the model
                exam.getTotalPaidAmount();
                exam.getTotalRefundedAmount();
                exam.getNetPaidAmount();
            }
            
            return examinations;
        } catch (Exception e) {
            Logger logger = LoggerFactory.getLogger(PendingPaymentController.class);
            logger.error("Error loading examinations for patient {}: {}", patientId, e.getMessage());
            return new ArrayList<>();
        }
    }

    @GetMapping("/search")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR') or hasRole('STAFF') or hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> searchPatient(@RequestParam String registrationCode) {
        Map<String, Object> response = new HashMap<>();
        Logger logger = LoggerFactory.getLogger(PendingPaymentController.class);
        
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // First, find the patient by registration code
            PatientDTO patientDTO = patientService.findByRegistrationCode(registrationCode);
            if (patientDTO == null) {
                response.put("success", false);
                response.put("message", "Patient not found with registration code: " + registrationCode);
                return response;
            }
            
            // Get the actual Patient entity
            Optional<Patient> patientOpt = patientService.getPatientById(Long.parseLong(patientDTO.getId()));
            if (patientOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Patient entity not found");
                return response;
            }
            
            Patient patient = patientOpt.get();
            
            // Create patient info map from DTO data
            Map<String, Object> patientInfo = new HashMap<>();
            patientInfo.put("id", patientDTO.getId());
            patientInfo.put("firstName", patientDTO.getFirstName());
            patientInfo.put("lastName", patientDTO.getLastName());
            patientInfo.put("registrationCode", patientDTO.getRegistrationCode());
            patientInfo.put("phoneNumber", patientDTO.getPhoneNumber());
            patientInfo.put("age", patientDTO.getAge());
            
            response.put("success", true);
            response.put("patient", patientInfo);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error searching for patient: " + e.getMessage());
        }
        
        return response;
    }

    @GetMapping("/search-patient")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> searchPatientByRegistrationCode(@RequestParam String registrationCode) {
        Map<String, Object> response = new HashMap<>();
        // Add logger
        Logger logger = LoggerFactory.getLogger(PendingPaymentController.class);
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // First, find the patient by registration code
            PatientDTO patientDTO = patientService.findByRegistrationCode(registrationCode);
            if (patientDTO == null) {
                response.put("success", false);
                response.put("message", "Patient not found with registration code: " + registrationCode);
                return response;
            }
            
            // Get the actual Patient entity
            Optional<Patient> patientOpt = patientService.getPatientById(Long.parseLong(patientDTO.getId()));
            if (patientOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Patient entity not found");
                return response;
            }
            
            Patient patient = patientOpt.get();
            
            // Find all examinations for this patient in the current clinic (show ALL, not just pending)
            List<ToothClinicalExamination> allExaminations = examinationService.findByPatient_IdAndExaminationClinic_ClinicId(patient.getId(), clinicId);
            logger.info("Found {} total examinations for patient {} in clinic {}", allExaminations.size(), registrationCode, clinicId);
            
            // Sort examinations by date (newest first for better UX)
            allExaminations.sort((a, b) -> {
                if (a.getExaminationDate() == null && b.getExaminationDate() == null) return 0;
                if (a.getExaminationDate() == null) return 1;
                if (b.getExaminationDate() == null) return -1;
                return b.getExaminationDate().compareTo(a.getExaminationDate());
            });
            
            if (allExaminations.isEmpty()) {
                response.put("success", false);
                response.put("message", "No examinations found for patient with registration code: " + registrationCode);
                return response;
            }
            
            List<Map<String, Object>> examinationData = new ArrayList<>();
            
            for (ToothClinicalExamination exam : allExaminations) {
                Map<String, Object> examData = new HashMap<>();
                examData.put("id", exam.getId());
                examData.put("toothNumber", exam.getToothNumber() != null ? exam.getToothNumber().toString() : "");
                examData.put("examinationDate", exam.getExaminationDate());
                examData.put("totalProcedureAmount", exam.getTotalProcedureAmount());
                
                // Calculate payment amounts with transaction types
                double totalPaid = 0.0;
                double totalRefunded = 0.0;
                int paymentCount = 0;
                
                if (exam.getPaymentEntries() != null) {
                    for (PaymentEntry entry : exam.getPaymentEntries()) {
                        if (entry.getAmount() != null) {
                            paymentCount++;
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
                
                // Determine payment status
                String paymentStatus;
                if (totalProcedureAmount == 0) {
                    paymentStatus = "NO_CHARGE";
                } else if (remainingAmount <= 0) {
                    paymentStatus = "COMPLETED";
                } else if (netPaid > 0) {
                    paymentStatus = "PARTIAL";
                } else {
                    paymentStatus = "PENDING";
                }
                
                examData.put("totalPaidAmount", totalPaid);
                examData.put("totalRefunded", totalRefunded);
                examData.put("netPaidAmount", netPaid);
                examData.put("remainingAmount", remainingAmount);
                examData.put("paymentStatus", paymentStatus);
                examData.put("paymentCount", paymentCount);
                
                // Add clinic info if available
                if (exam.getExaminationClinic() != null) {
                    Map<String, Object> clinicData = new HashMap<>();
                    clinicData.put("id", exam.getExaminationClinic().getId());
                    clinicData.put("clinicName", exam.getExaminationClinic().getClinicName());
                    clinicData.put("clinicId", exam.getExaminationClinic().getClinicId());
                    examData.put("clinic", clinicData);
                }
                
                // Add procedure info if available
                if (exam.getProcedure() != null) {
                    Map<String, Object> procedureData = new HashMap<>();
                    procedureData.put("id", exam.getProcedure().getId());
                    procedureData.put("procedureName", exam.getProcedure().getProcedureName());
                    procedureData.put("price", exam.getProcedure().getPrice());
                    examData.put("procedure", procedureData);
                }
                
                examinationData.add(examData);
            }
            
            // Create patient info map from DTO data
            Map<String, Object> patientInfo = new HashMap<>();
            patientInfo.put("id", patientDTO.getId());
            patientInfo.put("firstName", patientDTO.getFirstName());
            patientInfo.put("lastName", patientDTO.getLastName());
            patientInfo.put("registrationCode", patientDTO.getRegistrationCode());
            patientInfo.put("phoneNumber", patientDTO.getPhoneNumber());
            patientInfo.put("age", patientDTO.getAge());
            
            response.put("success", true);
            response.put("patient", patientInfo);
            response.put("examinations", examinationData);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error searching for patient: " + e.getMessage());
        }
        
        return response;
    }

    @PostMapping("/collect")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> collectPayment(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Long examinationId = Long.parseLong(request.get("examinationId").toString());
            String paymentModeStr = request.get("paymentMode").toString();
            String notes = request.get("notes") != null ? request.get("notes").toString() : "";
            
            @SuppressWarnings("unchecked")
            Map<String, Object> paymentDetails = (Map<String, Object>) request.get("paymentDetails");
            Double amount = Double.parseDouble(paymentDetails.get("amount").toString());
            
            PaymentMode paymentMode = PaymentMode.valueOf(paymentModeStr);
            
            // Convert paymentDetails to Map<String, String> for the service method
            Map<String, String> paymentDetailsStr = new HashMap<>();
            for (Map.Entry<String, Object> entry : paymentDetails.entrySet()) {
                paymentDetailsStr.put(entry.getKey(), entry.getValue().toString());
            }
            
            // Collect the payment using the existing service method
            examinationService.collectPayment(examinationId, paymentMode, notes, paymentDetailsStr);
            
            response.put("success", true);
            response.put("message", "Payment collected successfully");
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error collecting payment: " + e.getMessage());
        }
        
        return response;
    }

    @PostMapping("/update-status")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public String updatePaymentStatus(
            @RequestParam Long examinationId,
            @RequestParam ProcedureStatus newStatus,
            RedirectAttributes redirectAttributes) {
        
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = modelMapper.map(
            userService.getUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found")),
            User.class
        );
        
        // Validate that the new status is either PAYMENT_COMPLETED or PAYMENT_DENIED
        if (newStatus != ProcedureStatus.PAYMENT_COMPLETED && 
            newStatus != ProcedureStatus.PAYMENT_DENIED) {
            return "Invalid status transition";
        }

        try {
            // Get the examination to verify it belongs to the user's clinic
            var examination = examinationService.getToothClinicalExaminationById(examinationId);
            if (examination == null || 
                !examination.getExaminationClinic().getClinicId().equals(user.getClinic().getClinicId())) {
                redirectAttributes.addFlashAttribute("error", "You don't have permission to update this examination");
                return "redirect:/pending-payments";
            }
            
            examinationService.updateProcedureStatus(examinationId, newStatus);
            return "Status updated successfully";
        } catch (Exception e) {
            return "Error updating status: " + e.getMessage();
        }
    }

    @GetMapping("/payment-history/{examinationId}")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> getPaymentHistory(@PathVariable Long examinationId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Get the examination
            Optional<ToothClinicalExamination> examinationOpt = examinationRepository.findById(examinationId);
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
            
            // Add clinic info if available
            if (examination.getExaminationClinic() != null) {
                Map<String, Object> clinicData = new HashMap<>();
                clinicData.put("id", examination.getExaminationClinic().getId());
                clinicData.put("clinicName", examination.getExaminationClinic().getClinicName());
                clinicData.put("clinicId", examination.getExaminationClinic().getClinicId());
                examinationData.put("clinic", clinicData);
            }
            
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
            
            if (examination.getPaymentEntries() != null) {
                for (PaymentEntry entry : examination.getPaymentEntries()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("id", entry.getId());
                    payment.put("amount", entry.getAmount());
                    payment.put("paymentMode", entry.getPaymentMode().toString());
                    payment.put("paymentDate", entry.getPaymentDate().toString());
                    payment.put("notes", entry.getRemarks());
                    payment.put("transactionType", entry.getTransactionType() != null ? entry.getTransactionType().toString() : "CAPTURE");
                    
                    if (entry.getAmount() != null) {
                        totalPaid += entry.getAmount();
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
            summary.put("totalPaid", totalPaid);
            summary.put("remaining", (examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0) - totalPaid);
            summary.put("paymentStatus", getPaymentStatus((examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0) - totalPaid, examination.getTotalProcedureAmount()));
            
            response.put("success", true);
            response.put("examination", examinationData);
            response.put("payments", paymentData);
            response.put("summary", summary);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error loading payment history: " + e.getMessage());
        }
        
        return response;
    }
    
    private String getPaymentStatus(double remaining, Double total) {
        if (remaining <= 0) return "COMPLETED";
        if (remaining < total) return "PARTIAL";
        return "PENDING";
    }

    @GetMapping("/analytics")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> getPaymentAnalytics(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Calculate date range
            LocalDateTime start = startDate != null ? LocalDate.parse(startDate).atStartOfDay() : 
                LocalDate.now().minusDays(30).atStartOfDay();
            LocalDateTime end = endDate != null ? LocalDate.parse(endDate).atTime(LocalTime.MAX) : 
                LocalDate.now().atTime(LocalTime.MAX);
            
            // Get all examinations for the clinic (we'll filter by date in memory for now)
            List<ToothClinicalExamination> allExaminations = examinationService
                .findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus.PAYMENT_PENDING, clinicId);
            
            // Add completed examinations as well for analytics
            List<ToothClinicalExamination> completedExaminations = examinationService
                .findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus.PAYMENT_COMPLETED, clinicId);
            allExaminations.addAll(completedExaminations);
            
            // Filter by date range
            List<ToothClinicalExamination> examinations = allExaminations.stream()
                .filter(exam -> exam.getExaminationDate() != null && 
                               exam.getExaminationDate().isAfter(start.minusSeconds(1)) && 
                               exam.getExaminationDate().isBefore(end.plusSeconds(1)))
                .collect(Collectors.toList());
            
            // Calculate analytics
            double totalRevenue = 0.0;
            double pendingAmount = 0.0;
            double totalPaid = 0.0;
            int totalExaminations = examinations.size();
            int pendingCount = 0;
            int completedCount = 0;
            
            for (ToothClinicalExamination exam : examinations) {
                double procedureAmount = exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0;
                double paidAmount = exam.getTotalPaidAmount();
                double remaining = procedureAmount - paidAmount;
                
                totalRevenue += procedureAmount;
                totalPaid += paidAmount;
                
                if (remaining > 0) {
                    pendingAmount += remaining;
                    pendingCount++;
                } else {
                    completedCount++;
                }
            }
            
            // Calculate collection rate
            double collectionRate = totalRevenue > 0 ? (totalPaid / totalRevenue) * 100 : 0;
            
            // Calculate average payment
            double avgPayment = totalExaminations > 0 ? totalPaid / totalExaminations : 0;
            
            Map<String, Object> analytics = new HashMap<>();
            analytics.put("totalRevenue", totalRevenue);
            analytics.put("pendingAmount", pendingAmount);
            analytics.put("collectionRate", Math.round(collectionRate * 100.0) / 100.0);
            analytics.put("avgPayment", Math.round(avgPayment * 100.0) / 100.0);
            analytics.put("totalExaminations", totalExaminations);
            analytics.put("pendingCount", pendingCount);
            analytics.put("completedCount", completedCount);
            analytics.put("totalPaid", totalPaid);
            
            response.put("success", true);
            response.put("analytics", analytics);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error loading analytics: " + e.getMessage());
        }
        
        return response;
    }

    @PostMapping("/bulk-collect")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> bulkCollectPayment(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            @SuppressWarnings("unchecked")
            List<Long> examinationIds = (List<Long>) request.get("examinationIds");
            String paymentModeStr = request.get("paymentMode").toString();
            String notes = request.get("notes") != null ? request.get("notes").toString() : "";
            Double amount = Double.parseDouble(request.get("amount").toString());
            
            PaymentMode paymentMode = PaymentMode.valueOf(paymentModeStr);
            
            int successCount = 0;
            List<String> errors = new ArrayList<>();
            
            for (Long examinationId : examinationIds) {
                try {
                    Map<String, String> paymentDetails = new HashMap<>();
                    paymentDetails.put("amount", amount.toString());
                    
                    examinationService.collectPayment(examinationId, paymentMode, notes, paymentDetails);
                    successCount++;
                } catch (Exception e) {
                    errors.add("Examination " + examinationId + ": " + e.getMessage());
                }
            }
            
            response.put("success", true);
            response.put("successCount", successCount);
            response.put("totalCount", examinationIds.size());
            response.put("errors", errors);
            response.put("message", "Bulk payment collection completed. " + successCount + " out of " + examinationIds.size() + " payments collected successfully.");
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error in bulk payment collection: " + e.getMessage());
        }
        
        return response;
    }

    @GetMapping("/export")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public Map<String, Object> exportPaymentData(
            @RequestParam String format,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "true") boolean includeHistory,
            @RequestParam(defaultValue = "true") boolean includePatient,
            @RequestParam(defaultValue = "true") boolean includeSummary) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Calculate date range
            LocalDateTime start = startDate != null ? LocalDate.parse(startDate).atStartOfDay() : 
                LocalDate.now().minusDays(30).atStartOfDay();
            LocalDateTime end = endDate != null ? LocalDate.parse(endDate).atTime(LocalTime.MAX) : 
                LocalDate.now().atTime(LocalTime.MAX);
            
            // Get examinations data for the clinic
            List<ToothClinicalExamination> allExaminations = examinationService
                .findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus.PAYMENT_PENDING, clinicId);
            
            // Add completed examinations as well for export
            List<ToothClinicalExamination> completedExaminations = examinationService
                .findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus.PAYMENT_COMPLETED, clinicId);
            allExaminations.addAll(completedExaminations);
            
            // Filter by date range
            List<ToothClinicalExamination> examinations = allExaminations.stream()
                .filter(exam -> exam.getExaminationDate() != null && 
                               exam.getExaminationDate().isAfter(start.minusSeconds(1)) && 
                               exam.getExaminationDate().isBefore(end.plusSeconds(1)))
                .collect(Collectors.toList());
            
            // Prepare export data
            List<Map<String, Object>> exportData = new ArrayList<>();
            
            for (ToothClinicalExamination exam : examinations) {
                Map<String, Object> examData = new HashMap<>();
                examData.put("examinationId", exam.getId());
                examData.put("examinationDate", exam.getExaminationDate());
                examData.put("toothNumber", exam.getToothNumber());
                examData.put("procedureName", exam.getProcedure() != null ? exam.getProcedure().getProcedureName() : "");
                examData.put("totalAmount", exam.getTotalProcedureAmount());
                examData.put("paidAmount", exam.getTotalPaidAmount());
                examData.put("remainingAmount", (exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0) - exam.getTotalPaidAmount());
                
                if (includePatient && exam.getPatient() != null) {
                    examData.put("patientName", exam.getPatient().getFirstName() + " " + exam.getPatient().getLastName());
                    examData.put("registrationCode", exam.getPatient().getRegistrationCode());
                    examData.put("phoneNumber", exam.getPatient().getPhoneNumber());
                }
                
                if (includeHistory && exam.getPaymentEntries() != null) {
                    List<Map<String, Object>> payments = new ArrayList<>();
                    for (PaymentEntry entry : exam.getPaymentEntries()) {
                        Map<String, Object> payment = new HashMap<>();
                        payment.put("amount", entry.getAmount());
                        payment.put("paymentMode", entry.getPaymentMode());
                        payment.put("paymentDate", entry.getPaymentDate());
                        payment.put("notes", entry.getRemarks());
                        payments.add(payment);
                    }
                    examData.put("paymentHistory", payments);
                }
                
                exportData.add(examData);
            }
            
            response.put("success", true);
            response.put("format", format);
            response.put("data", exportData);
            response.put("count", exportData.size());
            response.put("message", "Export data prepared successfully. " + exportData.size() + " records ready for download.");
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error preparing export data: " + e.getMessage());
        }
        
        return response;
    }


} 
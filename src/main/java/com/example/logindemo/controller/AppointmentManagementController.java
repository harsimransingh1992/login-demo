package com.example.logindemo.controller;

import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.service.AppointmentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.model.ClinicModel;

@Controller
@RequestMapping("/appointments")
public class AppointmentManagementController {
    
    private static final Logger logger = LoggerFactory.getLogger(AppointmentManagementController.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/management")
    @PreAuthorize("hasAnyRole('RECEPTIONIST', 'DOCTOR')")
    public String appointmentManagement(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) Boolean myAppointments,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(defaultValue = "appointmentDateTime") String sort,
            @RequestParam(defaultValue = "asc") String direction,
            Model model,
            Authentication authentication) {
        
        // Use pageSize if provided, otherwise use size (for backward compatibility)
        int actualSize = pageSize != 20 ? pageSize : size;
        
        // Determine default for myAppointments: doctors default to true when not specified
        User currentUser = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Current user not found"));
        boolean myAppointmentsEffective = (myAppointments != null) ? myAppointments.booleanValue() :
                (currentUser.getRole() != null && currentUser.getRole().name().equals("DOCTOR"));
        logger.info("Received request for appointment management. Date: {}, My appointments (effective): {}, page: {}, size: {}", 
            date, myAppointmentsEffective, page, actualSize);
        
        LocalDateTime startOfDay;
        LocalDateTime endOfDay;
        String formattedDate;
        org.springframework.data.domain.Page<Appointment> appointmentsPage;
        
        try {
            if (date != null && !date.isEmpty()) {
                LocalDate selectedDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                
                startOfDay = selectedDate.atStartOfDay();
                endOfDay = selectedDate.atTime(LocalTime.MAX);
                formattedDate = selectedDate.format(DATE_FORMATTER);
                logger.info("Using date: {}", formattedDate);
            } else {
                // Default to today
                LocalDate today = LocalDate.now();
                startOfDay = today.atStartOfDay();
                endOfDay = today.atTime(LocalTime.MAX);
                formattedDate = today.format(DATE_FORMATTER);
                logger.info("No date provided. Using today's date: {}", formattedDate);
            }
        } catch (DateTimeParseException e) {
            logger.warn("Invalid date format provided: {}. Defaulting to today's date", date);
            LocalDate today = LocalDate.now();
            startOfDay = today.atStartOfDay();
            endOfDay = today.atTime(LocalTime.MAX);
            formattedDate = today.format(DATE_FORMATTER);
        }
        
        // currentUser already resolved above
        
        // Get user's clinic
        ClinicModel userClinic = currentUser.getClinic();
        if (userClinic == null) {
            logger.warn("User {} has no clinic assigned", currentUser.getUsername());
            appointmentsPage = new org.springframework.data.domain.PageImpl<>(new ArrayList<>());
        } else {
            logger.info("Filtering appointments for clinic: {}", userClinic.getClinicName());
            
            // Create pageable object with sorting
            org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(
                page, 
                actualSize, 
                org.springframework.data.domain.Sort.by(
                    "desc".equalsIgnoreCase(direction) ? 
                    org.springframework.data.domain.Sort.Direction.DESC : 
                    org.springframework.data.domain.Sort.Direction.ASC, 
                    sort
                )
            );
            
            if (myAppointmentsEffective) {
                // Get user's upcoming appointments within their clinic with pagination
                appointmentsPage = appointmentService.getUpcomingAppointmentsForUserInClinicPaginated(currentUser, userClinic, pageable);
                logger.info("Found {} upcoming appointments for user {} in clinic {} (page {} of {})", 
                    appointmentsPage.getTotalElements(), currentUser.getUsername(), userClinic.getClinicName(), 
                    page + 1, appointmentsPage.getTotalPages());
            } else {
                // Get appointments for the selected date within user's clinic with pagination
                logger.debug("Fetching appointments between {} and {} for clinic {} with pagination", startOfDay, endOfDay, userClinic.getClinicName());
                appointmentsPage = appointmentService.getAppointmentsByDateRangeAndClinicPaginated(startOfDay, endOfDay, userClinic, pageable);
                logger.info("Found {} appointments for date {} in clinic {} (page {} of {})", 
                    appointmentsPage.getTotalElements(), formattedDate, userClinic.getClinicName(), 
                    page + 1, appointmentsPage.getTotalPages());
            }
        }
        
        model.addAttribute("appointments", appointmentsPage.getContent());
        model.addAttribute("statuses", AppointmentStatus.values());
        model.addAttribute("selectedDate", formattedDate);
        model.addAttribute("myAppointments", myAppointmentsEffective);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", appointmentsPage.getTotalPages());
        model.addAttribute("totalItems", appointmentsPage.getTotalElements());
        model.addAttribute("pageSize", actualSize);
        model.addAttribute("sort", sort);
        model.addAttribute("direction", direction);
        
        // Prepare JSON data for calendar
        ObjectMapper mapper = new ObjectMapper();
        try {
            List<Map<String, Object>> calendarEvents = appointmentsPage.getContent().stream()
                .map(appointment -> {
                    Map<String, Object> event = new HashMap<>();
                    event.put("id", appointment.getId());
                    event.put("title", appointment.getPatientName() != null ? appointment.getPatientName() : appointment.getPatientMobile());
                    event.put("start", appointment.getAppointmentDateTime().toString());
                    event.put("status", appointment.getStatus().toString());
                    event.put("patientName", appointment.getPatientName());
                    event.put("doctorName", appointment.getDoctor() != null ? 
                        appointment.getDoctor().getFirstName() + " " + appointment.getDoctor().getLastName() : 
                        "Unassigned");
                    event.put("notes", appointment.getNotes());
                    return event;
                })
                .collect(Collectors.toList());
            
            String appointmentsJson = mapper.writeValueAsString(calendarEvents);
            model.addAttribute("appointmentsJson", appointmentsJson);
            logger.debug("Generated calendar events JSON for {} appointments", appointmentsPage.getContent().size());
        } catch (Exception e) {
            logger.error("Error generating calendar events JSON", e);
            model.addAttribute("appointmentsJson", "[]");
        }
        
        return "receptionist/appointments";
    }

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('RECEPTIONIST', 'DOCTOR')")
    public String createAppointment(
            @RequestParam String patientName,
            @RequestParam String patientMobile,
            @RequestParam String appointmentDateTime,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {

        // Validate inputs
        if (patientName == null || patientName.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("patientNameError", "Patient name is required");
            return "redirect:/appointments/management";
        }

        if (patientMobile == null || !patientMobile.matches("\\d{10}")) {
            redirectAttributes.addFlashAttribute("patientMobileError", "Valid 10-digit mobile number is required");
            return "redirect:/appointments/management";
        }

        LocalDateTime appointmentTime;
        try {
            appointmentTime = LocalDateTime.parse(appointmentDateTime);
            if (appointmentTime.isBefore(LocalDateTime.now())) {
                redirectAttributes.addFlashAttribute("appointmentDateTimeError", "Appointment time cannot be in the past");
                return "redirect:/appointments/management";
            }
        } catch (DateTimeParseException e) {
            redirectAttributes.addFlashAttribute("appointmentDateTimeError", "Invalid date/time format");
            return "redirect:/appointments/management";
        }

        try {
            appointmentService.createAppointment(patientName.trim(), patientMobile, appointmentTime, authentication);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment created successfully!");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/appointments/management";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to create appointment. Please try again.");
            return "redirect:/appointments/management";
        }

        return "redirect:/appointments/management";
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAnyRole('RECEPTIONIST', 'DOCTOR')")
    @ResponseBody
    public ResponseEntity<?> updateAppointmentStatus(
            @PathVariable Long id,
            @RequestBody AppointmentStatusUpdateRequest request) {
        try {
            appointmentService.updateAppointmentStatus(id, request.getStatus(), request.getPatientRegistrationNumber());
            return ResponseEntity.ok().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Failed to update appointment status"));
        }
    }

    // Request and Response classes
    public static class AppointmentStatusUpdateRequest {
        private AppointmentStatus status;
        private String patientRegistrationNumber;

        public AppointmentStatus getStatus() {
            return status;
        }

        public void setStatus(AppointmentStatus status) {
            this.status = status;
        }

        public String getPatientRegistrationNumber() {
            return patientRegistrationNumber;
        }

        public void setPatientRegistrationNumber(String patientRegistrationNumber) {
            this.patientRegistrationNumber = patientRegistrationNumber;
        }
    }

    public static class ErrorResponse {
        private String message;

        public ErrorResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }
} 
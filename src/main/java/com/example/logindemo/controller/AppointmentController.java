package com.example.logindemo.controller;

import com.example.logindemo.dto.RescheduleAppointmentDTO;
import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentHistory;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.service.AppointmentService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.ClinicService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/appointments")
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private UserService userService;

    @Autowired
    private ClinicService clinicService;

    @Autowired
    private ModelMapper modelMapper;

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", userService.getUsersByRole(UserRole.DOCTOR));
        model.addAttribute("patients", userService.getUsersByRole(UserRole.STAFF));
        model.addAttribute("clinics", clinicService.getAllClinics());
        return "appointments/create";
    }
    
    // Reschedule appointment endpoint
    @PostMapping("/reschedule")
    @ResponseBody
    public ResponseEntity<?> rescheduleAppointment(@RequestBody RescheduleAppointmentDTO dto) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            User currentUser = userService.getUserByUsername(authentication.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            Appointment rescheduledAppointment = appointmentService.rescheduleAppointment(dto, currentUser);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Appointment rescheduled successfully",
                "appointmentId", rescheduledAppointment.getId(),
                "newDateTime", rescheduledAppointment.getAppointmentDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    // Get appointment history endpoint
    @GetMapping("/{id}/history")
    @ResponseBody
    public ResponseEntity<?> getAppointmentHistory(@PathVariable Long id) {
        try {
            List<AppointmentHistory> history = appointmentService.getAppointmentHistory(id);
            
            // Convert to a simpler format to avoid serialization issues
            List<Map<String, Object>> historyData = history.stream()
                .map(h -> {
                    // Format date/time values
                    String formattedOldValue = "";
                    String formattedNewValue = "";
                    String formattedChangedAt = "";
                    
                    if (h.getOldValue() != null) {
                        try {
                            LocalDateTime oldDateTime = LocalDateTime.parse(h.getOldValue());
                            formattedOldValue = oldDateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a"));
                        } catch (Exception e) {
                            formattedOldValue = h.getOldValue();
                        }
                    }
                    
                    if (h.getNewValue() != null) {
                        try {
                            LocalDateTime newDateTime = LocalDateTime.parse(h.getNewValue());
                            formattedNewValue = newDateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a"));
                        } catch (Exception e) {
                            formattedNewValue = h.getNewValue();
                        }
                    }
                    
                    if (h.getChangedAt() != null) {
                        formattedChangedAt = h.getChangedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a"));
                    }
                    
                    return Map.of(
                        "id", h.getId(),
                        "action", h.getAction(),
                        "oldValue", formattedOldValue,
                        "newValue", formattedNewValue,
                        "changedBy", h.getChangedBy() != null ? Map.of(
                            "firstName", h.getChangedBy().getFirstName(),
                            "lastName", h.getChangedBy().getLastName()
                        ) : null,
                        "changedAt", formattedChangedAt,
                        "notes", h.getNotes() != null ? h.getNotes() : "",
                        "rescheduleNumber", h.getRescheduleNumber() != null ? h.getRescheduleNumber() : 0
                    );
                })
                .toList();
            
            return ResponseEntity.ok(historyData);
        } catch (Exception e) {
            e.printStackTrace(); // Add debugging
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    // Get reschedule summary endpoint
    @GetMapping("/{id}/reschedule-summary")
    @ResponseBody
    public ResponseEntity<?> getRescheduleSummary(@PathVariable Long id) {
        try {
            Map<String, Object> summary = appointmentService.getRescheduleSummary(id);
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

} 
package com.example.logindemo.controller;

import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.AppointmentRepository;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.ModeratorService;
import com.example.logindemo.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.util.*;

@Controller
@RequestMapping("/schedules")
public class CrossClinicAppointmentController {
    private static final Logger log = LoggerFactory.getLogger(CrossClinicAppointmentController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired(required = false)
    private ModeratorService moderatorService;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ClinicRepository clinicRepository;

    @PostMapping("/api/schedule-appointment")
    @ResponseBody
    public ResponseEntity<?> scheduleAppointment(@RequestBody Map<String, Object> payload) {
        try {
            User currentUser = getCurrentUser();
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean hasAuthority = auth != null && auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("CROSS_CLINIC_ACCESS"));
            boolean hasAccessFlag = currentUser != null && Boolean.TRUE.equals(currentUser.getHasCrossClinicApptAccess());
            boolean hasAccess = currentUser != null && (hasAccessFlag || hasAuthority);

            log.info("[api/schedule-appointment] user={}, role={}, flag={}, hasAuthority={}, authorities={}",
                    currentUser != null ? currentUser.getUsername() : "<anon>",
                    currentUser != null ? currentUser.getRole() : null,
                    hasAccessFlag,
                    hasAuthority,
                    auth != null ? auth.getAuthorities() : "none");

            if (currentUser == null || !hasAccess) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Access denied"
                ));
            }

            String clinicId = asString(payload.get("clinicId"));
            Long doctorId = asLong(payload.get("doctorId"));
            String appointmentDateTimeStr = asString(payload.get("appointmentDateTime"));
            Long patientId = asLong(payload.get("patientId"));
            String patientName = asString(payload.get("patientName"));
            String patientMobile = asString(payload.get("patientMobile"));
            String notes = asString(payload.get("notes"));

            if (clinicId == null || clinicId.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "clinicId is required"));
            }
            if (doctorId == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "doctorId is required"));
            }
            if (appointmentDateTimeStr == null || appointmentDateTimeStr.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "appointmentDateTime is required"));
            }

            // Ensure requested clinic is authorized
            List<ClinicModel> clinics = getAccessibleClinics(currentUser);
            Optional<ClinicModel> selectedClinicOpt = clinics.stream()
                    .filter(c -> clinicId.equals(c.getClinicId()))
                    .findFirst();
            if (selectedClinicOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "You are not authorized to schedule for this clinic"
                ));
            }
            ClinicModel clinic = selectedClinicOpt.get();

            // Resolve doctor and ensure belongs to clinic
            User doctor = userRepository.findById(doctorId).orElse(null);
            if (doctor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Invalid doctorId"));
            }
            if (doctor.getClinic() == null || !doctor.getClinic().equals(clinic)) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Doctor does not belong to selected clinic"));
            }

            // Parse date/time
            LocalDateTime appointmentDateTime;
            try {
                appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr);
            } catch (Exception parseEx) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Invalid appointmentDateTime format. Use ISO-8601 (e.g., 2025-10-21T15:30)"
                ));
            }

            // Check conflicts
            if (appointmentRepository.existsConflictingAppointment(doctor, appointmentDateTime)) {
                return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of(
                        "success", false,
                        "message", "Doctor has a conflicting appointment at the selected time"
                ));
            }

            // Build appointment
            Appointment appointment = new Appointment();
            appointment.setAppointmentDateTime(appointmentDateTime);
            appointment.setClinic(clinic);
            appointment.setDoctor(doctor);
            appointment.setStatus(AppointmentStatus.SCHEDULED);
            appointment.setAppointmentBookedBy(currentUser);
            if (notes != null && !notes.isEmpty()) {
                appointment.setNotes(notes);
            }

            if (patientId != null) {
                Patient patient = patientRepository.getPatientsById(patientId);
                if (patient == null) {
                    return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Invalid patientId"));
                }
                appointment.setPatient(patient);
                appointment.setPatientName((patient.getFirstName() != null ? patient.getFirstName() : "") +
                        (patient.getLastName() != null ? (" " + patient.getLastName()) : ""));
                appointment.setPatientMobile(patient.getPhoneNumber());
            } else {
                if (patientName == null || patientName.trim().isEmpty() || patientMobile == null || patientMobile.trim().isEmpty()) {
                    return ResponseEntity.badRequest().body(Map.of(
                            "success", false,
                            "message", "Either patientId or patientName and patientMobile are required"
                    ));
                }
                appointment.setPatientName(patientName);
                appointment.setPatientMobile(patientMobile);
            }

            Appointment saved = appointmentRepository.save(appointment);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Appointment created successfully");
            response.put("appointmentId", saved.getId());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error scheduling appointment", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "Server error"
            ));
        }
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) return null;
        return userService.findByUsername(authentication.getName()).orElse(null);
    }

    private List<ClinicModel> getAccessibleClinics(User user) {
        if (user == null) return Collections.emptyList();
        if (Boolean.TRUE.equals(user.getHasCrossClinicApptAccess()) && user.getAccessibleClinics() != null) {
            return user.getAccessibleClinics();
        }
        if (user.getRole() == UserRole.MODERATOR && moderatorService != null) {
            return moderatorService.getAccessibleClinics(user);
        }
        return Collections.emptyList();
    }

    private String asString(Object o) {
        return o == null ? null : String.valueOf(o);
    }
    private Long asLong(Object o) {
        try {
            return o == null ? null : Long.valueOf(String.valueOf(o));
        } catch (Exception e) {
            return null;
        }
    }
}
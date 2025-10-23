package com.example.logindemo.controller;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.ModeratorService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.AppointmentService;
import com.example.logindemo.model.Appointment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/schedules")
public class CrossClinicScheduleController {
    private static final Logger log = LoggerFactory.getLogger(CrossClinicScheduleController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired(required = false)
    private ModeratorService moderatorService;

    @Autowired
    private AppointmentService appointmentService;

    @GetMapping("/select-clinic")
    public String selectClinicPage(Model model) {
        try {
            User currentUser = getCurrentUser();
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean hasAuthority = auth != null && auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("CROSS_CLINIC_ACCESS"));
            boolean hasAccessFlag = currentUser != null && Boolean.TRUE.equals(currentUser.getHasCrossClinicApptAccess());
            java.util.Set<String> auths = auth != null ? auth.getAuthorities().stream().map(a -> a.getAuthority()).collect(java.util.stream.Collectors.toSet()) : java.util.Collections.emptySet();
            boolean hasRoleAccess = auths.contains("ROLE_RECEPTIONIST") || auths.contains("ROLE_ADMIN") || auths.contains("ROLE_MODERATOR") || auths.contains("ROLE_DOCTOR") || auths.contains("ROLE_OPD_DOCTOR");
            boolean hasAccess = currentUser != null && (hasAccessFlag || hasAuthority);

            // Ensure JSP sees the final access decision
            model.addAttribute("currentUserHasCrossClinicApptAccess", hasAccess);

            if (currentUser == null || !hasAccess) {
                model.addAttribute("errorMessage", "You do not have access to cross-clinic schedules.");
                return "access-denied";
            }
            // Expose clinics via model for server-side render as well
            List<ClinicModel> clinics = getAccessibleClinics(currentUser);
            model.addAttribute("clinics", clinics);
            return "schedules/select-clinic";
        } catch (Exception e) {
            log.error("Error loading select clinic page", e);
            model.addAttribute("errorMessage", "An error occurred while loading the page.");
            return "error";
        }
    }

    @GetMapping("/api/clinics")
    @ResponseBody
    public ResponseEntity<?> getAccessibleClinicsApi() {
        try {
            User currentUser = getCurrentUser();
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean hasAuthority = auth != null && auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("CROSS_CLINIC_ACCESS"));
            boolean hasAccessFlag = currentUser != null && Boolean.TRUE.equals(currentUser.getHasCrossClinicApptAccess());
            java.util.Set<String> auths = auth != null ? auth.getAuthorities().stream().map(a -> a.getAuthority()).collect(java.util.stream.Collectors.toSet()) : java.util.Collections.emptySet();
            boolean hasRoleAccess = auths.contains("ROLE_RECEPTIONIST") || auths.contains("ROLE_ADMIN") || auths.contains("ROLE_MODERATOR") || auths.contains("ROLE_DOCTOR") || auths.contains("ROLE_OPD_DOCTOR");
            boolean hasAccess = currentUser != null && (hasAccessFlag || hasAuthority);

            log.info("[api/clinics] user={}, role={}, flag={}, hasAuthority={}, hasRoleAccess={}, authorities={}",
                    currentUser != null ? currentUser.getUsername() : "<anon>",
                    currentUser != null ? currentUser.getRole() : null,
                    hasAccessFlag,
                    hasAuthority,
                    hasRoleAccess,
                    auth != null ? auth.getAuthorities() : "none");

            if (currentUser == null || !hasAccess) {
                log.warn("[api/clinics] Access denied for user {}. flag={}, hasAuthority={}, hasRoleAccess={}",
                        currentUser != null ? currentUser.getUsername() : "<anon>", hasAccessFlag, hasAuthority, hasRoleAccess);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Access denied"
                ));
            }
            List<ClinicModel> clinics = getAccessibleClinics(currentUser);
            log.info("[api/clinics] Returning {} clinics", clinics != null ? clinics.size() : 0);
            List<Map<String, Object>> payload = new ArrayList<>();
            for (ClinicModel c : clinics) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", c.getId());
                m.put("clinicId", c.getClinicId());
                m.put("clinicName", c.getClinicName());
                payload.add(m);
            }
            return ResponseEntity.ok(payload);
        } catch (Exception e) {
            log.error("Error fetching clinics", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "Server error"
            ));
        }
    }

    @GetMapping("/api/clinic-doctors")
    @ResponseBody
    public ResponseEntity<?> getDoctorsForClinic(@RequestParam("clinicId") String clinicId) {
        try {
            User currentUser = getCurrentUser();
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean hasAuthority = auth != null && auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("CROSS_CLINIC_ACCESS"));
            boolean hasAccessFlag = currentUser != null && Boolean.TRUE.equals(currentUser.getHasCrossClinicApptAccess());
            java.util.Set<String> auths = auth != null ? auth.getAuthorities().stream().map(a -> a.getAuthority()).collect(java.util.stream.Collectors.toSet()) : java.util.Collections.emptySet();
            boolean hasRoleAccess = auths.contains("ROLE_RECEPTIONIST") || auths.contains("ROLE_ADMIN") || auths.contains("ROLE_MODERATOR") || auths.contains("ROLE_DOCTOR") || auths.contains("ROLE_OPD_DOCTOR");
            boolean hasAccess = currentUser != null && (hasAccessFlag || hasAuthority);

            log.info("[api/clinic-doctors] user={}, role={}, flag={}, hasAuthority={}, hasRoleAccess={}, clinicId={}",
                    currentUser != null ? currentUser.getUsername() : "<anon>",
                    currentUser != null ? currentUser.getRole() : null,
                    hasAccessFlag,
                    hasAuthority,
                    hasRoleAccess,
                    clinicId);

            if (currentUser == null || !hasAccess) {
                log.warn("[api/clinic-doctors] Access denied for user {}. flag={}, hasAuthority={}, hasRoleAccess={}",
                        currentUser != null ? currentUser.getUsername() : "<anon>", hasAccessFlag, hasAuthority, hasRoleAccess);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Access denied"
                ));
            }

            // Ensure requested clinic is within accessible clinics
            List<ClinicModel> clinics = getAccessibleClinics(currentUser);
            Optional<ClinicModel> selected = clinics.stream()
                    .filter(c -> clinicId.equals(c.getClinicId()))
                    .findFirst();
            if (selected.isEmpty()) {
                log.warn("[api/clinic-doctors] Clinic {} not authorized for user {}",
                        clinicId,
                        currentUser != null ? currentUser.getUsername() : "<anon>");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "You are not authorized to view this clinic"
                ));
            }
            ClinicModel clinic = selected.get();

            // Find doctors for that clinic
            List<User> doctors = userRepository.findByClinicAndRoleIn(
                    clinic,
                    List.of(UserRole.DOCTOR, UserRole.OPD_DOCTOR)
            );
            log.info("[api/clinic-doctors] Returning {} doctors for clinic {}", doctors != null ? doctors.size() : 0, clinicId);
            List<Map<String, Object>> payload = new ArrayList<>();
            for (User d : doctors) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", d.getId());
                m.put("username", d.getUsername());
                m.put("firstName", d.getFirstName());
                m.put("lastName", d.getLastName());
                payload.add(m);
            }
            return ResponseEntity.ok(payload);
        } catch (Exception e) {
            log.error("Error fetching doctors for clinic {}", clinicId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "Server error"
            ));
        }
    }

    @GetMapping("/api/doctor-appointments")
    @ResponseBody
    public ResponseEntity<?> getDoctorAppointments(
            @RequestParam("clinicId") String clinicId,
            @RequestParam("doctorId") Long doctorId,
            // Switch to mandatory date range for calendar consumption
            @RequestParam("startDate") String startDateStr,
            @RequestParam("endDate") String endDateStr) {
        try {
            User currentUser = getCurrentUser();
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean hasAuthority = auth != null && auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("CROSS_CLINIC_ACCESS"));
            boolean hasAccessFlag = currentUser != null && Boolean.TRUE.equals(currentUser.getHasCrossClinicApptAccess());
            java.util.Set<String> auths = auth != null ? auth.getAuthorities().stream().map(a -> a.getAuthority()).collect(java.util.stream.Collectors.toSet()) : java.util.Collections.emptySet();
            boolean hasRoleAccess = auths.contains("ROLE_RECEPTIONIST") || auths.contains("ROLE_ADMIN") || auths.contains("ROLE_MODERATOR") || auths.contains("ROLE_DOCTOR") || auths.contains("ROLE_OPD_DOCTOR");
            boolean hasAccess = currentUser != null && (hasAccessFlag || hasAuthority);

            if (currentUser == null || !hasAccess) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "Access denied"
                ));
            }

            // Ensure requested clinic is authorized
            List<ClinicModel> clinics = getAccessibleClinics(currentUser);
            Optional<ClinicModel> selected = clinics.stream()
                    .filter(c -> clinicId.equals(c.getClinicId()))
                    .findFirst();
            if (selected.isEmpty()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "message", "You are not authorized to view this clinic"
                ));
            }
            ClinicModel clinic = selected.get();

            // Parse mandatory date range
            LocalDate startDate;
            LocalDate endDate;
            try {
                startDate = LocalDate.parse(startDateStr);
                endDate = LocalDate.parse(endDateStr);
            } catch (Exception parseEx) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Invalid date range. Use format yyyy-MM-dd for startDate and endDate"
                ));
            }
            LocalDateTime start = startDate.atStartOfDay();
            LocalDateTime end = endDate.atTime(23, 59, 59);

            List<Appointment> appts = appointmentService.getAppointmentsByDateRangeAndClinic(start, end, clinic);
            List<Map<String, Object>> payload = appts.stream()
                    .filter(a -> a.getDoctor() != null && a.getDoctor().getId() != null && a.getDoctor().getId().equals(doctorId))
                    .map(a -> {
                        Map<String, Object> m = new HashMap<>();
                        m.put("id", a.getId());
                        m.put("patientName", a.getPatientName());
                        m.put("patientMobile", a.getPatientMobile());
                        m.put("appointmentDateTime", a.getAppointmentDateTime() != null ? a.getAppointmentDateTime().toString() : null);
                        m.put("status", a.getStatus() != null ? a.getStatus().toString() : null);
                        m.put("notes", a.getNotes());
                        // Enriched fields for management-style rendering
                        if (a.getPatient() != null) {
                            m.put("patientId", a.getPatient().getId());
                            m.put("registrationCode", a.getPatient().getRegistrationCode());
                            m.put("isRegistered", true);
                        } else {
                            m.put("patientId", null);
                            m.put("registrationCode", null);
                            m.put("isRegistered", false);
                        }
                        if (a.getDoctor() != null) {
                            String doctorName = ((a.getDoctor().getFirstName() != null ? a.getDoctor().getFirstName() : "") + " " + (a.getDoctor().getLastName() != null ? a.getDoctor().getLastName() : "")).trim();
                            m.put("doctorName", doctorName);
                        } else {
                            m.put("doctorName", "");
                        }
                        return m;
                    })
                    .collect(java.util.stream.Collectors.toList());

            return ResponseEntity.ok(payload);
        } catch (Exception e) {
            log.error("Error fetching doctor appointments for clinic {}", clinicId, e);
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
        if (user == null) return java.util.Collections.emptyList();
        if (Boolean.TRUE.equals(user.getHasCrossClinicApptAccess()) && user.getAccessibleClinics() != null) {
            return user.getAccessibleClinics();
        }
        if (user.getRole() == UserRole.MODERATOR && moderatorService != null) {
            return moderatorService.getAccessibleClinics(user);
        }
        return java.util.Collections.emptyList();
    }
}
package com.example.logindemo.controller;

import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.service.AppointmentService;
import com.example.logindemo.utils.PeriDeskUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import com.example.logindemo.model.ClinicModel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.PageImpl;

@Controller
@RequestMapping("/receptionist/appointments")
@PreAuthorize("hasRole('RECEPTIONIST')")
public class AppointmentTrackingController {

    @Autowired
    private AppointmentService appointmentService;

    @GetMapping("/tracking")
    public String showAppointmentTrackingPage(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String statusFilter,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(defaultValue = "appointmentDateTime") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            Model model
    ) {
        model.addAttribute("appointmentStatuses", AppointmentStatus.values());

        // Set default date range (last 30 days)
        LocalDate today = LocalDate.now();
        LocalDate thirtyDaysAgo = today.minusDays(30);
        LocalDate start = (startDate != null && !startDate.isEmpty()) ? LocalDate.parse(startDate) : thirtyDaysAgo;
        LocalDate end = (endDate != null && !endDate.isEmpty()) ? LocalDate.parse(endDate) : today;
        model.addAttribute("startDate", start.toString());
        model.addAttribute("endDate", end.toString());
        model.addAttribute("statusFilter", statusFilter);

        // Get the current user's clinic
        ClinicModel clinic = PeriDeskUtils.getCurrentClinicModel();
        Sort sortObj = Sort.by("desc".equalsIgnoreCase(direction) ? Sort.Direction.DESC : Sort.Direction.ASC, sort);
        Pageable pageable = PageRequest.of(page, pageSize, sortObj);
        Page<Appointment> appointmentPage;

        if (statusFilter != null && !statusFilter.isEmpty()) {
            AppointmentStatus status = AppointmentStatus.valueOf(statusFilter);
            appointmentPage = appointmentService.getAppointmentsByDateRangeAndClinicAndStatusPaginated(
                start.atStartOfDay(), end.atTime(23, 59, 59), clinic, status, pageable
            );
        } else {
            appointmentPage = appointmentService.getAppointmentsByDateRangeAndClinicPaginated(
                start.atStartOfDay(), end.atTime(23, 59, 59), clinic, pageable
            );
        }

        List<Map<String, Object>> appointmentRows = new ArrayList<>();
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
        for (Appointment appointment : appointmentPage.getContent()) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", appointment.getId());
            row.put("patient", appointment.getPatient());
            row.put("patientName", appointment.getPatientName());
            row.put("patientMobile", appointment.getPatientMobile());
            row.put("appointmentDateTimeStr", appointment.getAppointmentDateTime() != null ? appointment.getAppointmentDateTime().format(displayFormatter) : "");
            row.put("status", appointment.getStatus());
            row.put("notes", appointment.getNotes());
            row.put("clinic", appointment.getClinic());
            row.put("doctor", appointment.getDoctor());
            appointmentRows.add(row);
        }
        model.addAttribute("appointments", appointmentRows);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", appointmentPage.getTotalPages());
        model.addAttribute("totalItems", appointmentPage.getTotalElements());
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("sort", sort);
        model.addAttribute("direction", direction);

        // Stats
        List<Appointment> allAppointmentsForStats = appointmentService.getAppointmentsByDateRangeAndClinic(
            start.atStartOfDay(), end.atTime(23, 59, 59), clinic
        );
        if (statusFilter != null && !statusFilter.isEmpty()) {
            AppointmentStatus status = AppointmentStatus.valueOf(statusFilter);
            allAppointmentsForStats = allAppointmentsForStats.stream()
                .filter(appointment -> appointment.getStatus() == status)
                .collect(Collectors.toList());
        }
        Map<String, Object> stats = calculateStats(allAppointmentsForStats);
        model.addAttribute("stats", stats);

        return "receptionist/appointment-tracking";
    }

    @PostMapping("/save-notes")
    @ResponseBody
    public Map<String, Object> saveNotes(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Long appointmentId = Long.parseLong(request.get("appointmentId").toString());
            String notes = request.get("notes") != null ? request.get("notes").toString() : "";
            
            // Get the appointment
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                response.put("success", false);
                response.put("message", "Appointment not found");
                return response;
            }
            
            // Verify the appointment belongs to the current clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            if (!appointment.getClinic().getClinicId().equals(clinicId)) {
                response.put("success", false);
                response.put("message", "You don't have permission to update this appointment");
                return response;
            }
            
            // Add timestamp to notes
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            String currentNotes = appointment.getNotes() != null ? appointment.getNotes() : "";
            String newNotes = currentNotes + (currentNotes.isEmpty() ? "" : "\n\n") + 
                             "[" + timestamp + "] " + notes;
            
            appointment.setNotes(newNotes);
            appointmentService.updateAppointment(appointmentId, appointment);
            
            response.put("success", true);
            response.put("message", "Notes saved successfully");
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error saving notes: " + e.getMessage());
        }
        
        return response;
    }

    private Map<String, Object> calculateStats(List<Appointment> appointments) {
        Map<String, Object> stats = new HashMap<>();
        
        long noShowCount = appointments.stream()
            .filter(appointment -> appointment.getStatus() == AppointmentStatus.NO_SHOW)
            .count();
        
        long cancelledCount = appointments.stream()
            .filter(appointment -> appointment.getStatus() == AppointmentStatus.CANCELLED)
            .count();
        
        stats.put("noShow", noShowCount);
        stats.put("cancelled", cancelledCount);
        
        return stats;
    }

    private Map<String, Object> convertToAppointmentData(Appointment appointment) {
        Map<String, Object> appointmentData = new HashMap<>();
        
        appointmentData.put("id", appointment.getId());
        
        // Get patient name
        String patientName;
        if (appointment.getPatient() != null) {
            patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();
        } else {
            patientName = appointment.getPatientName() != null ? appointment.getPatientName() : "Walk-in Patient";
        }
        appointmentData.put("patientName", patientName);
        
        // Format appointment date properly
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        String formattedDate = appointment.getAppointmentDateTime().format(formatter);
        appointmentData.put("appointmentDate", formattedDate);
        
        appointmentData.put("status", appointment.getStatus().toString());
        
        // Get phone number
        String phoneNumber;
        if (appointment.getPatient() != null) {
            phoneNumber = appointment.getPatient().getPhoneNumber();
        } else {
            phoneNumber = appointment.getPatientMobile() != null ? appointment.getPatientMobile() : "N/A";
        }
        appointmentData.put("phoneNumber", phoneNumber);
        
        // Add notes
        appointmentData.put("notes", appointment.getNotes());
        
        return appointmentData;
    }
} 
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

@Controller
@RequestMapping("/receptionist/appointments")
@PreAuthorize("hasRole('RECEPTIONIST')")
public class AppointmentTrackingController {

    @Autowired
    private AppointmentService appointmentService;

    @GetMapping("/tracking")
    public String showAppointmentTracking(Model model) {
        return "receptionist/appointment-tracking";
    }

    @PostMapping("/track")
    @ResponseBody
    public Map<String, Object> trackAppointments(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String startDateStr = request.get("startDate").toString();
            String endDateStr = request.get("endDate").toString();
            String statusFilter = request.get("statusFilter") != null ? request.get("statusFilter").toString() : "";
            
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);
            
            // Get the current user's clinic
            String clinicId = PeriDeskUtils.getCurrentClinicModel().getClinicId();
            
            // Get all appointments for the clinic within the date range
            List<Appointment> allAppointments = appointmentService.getAppointmentsByDateRange(
                startDate.atStartOfDay(), 
                endDate.atTime(23, 59, 59)
            );
            
            // Filter by clinic and status if specified
            List<Appointment> filteredAppointments = allAppointments.stream()
                .filter(appointment -> appointment.getClinic().getClinicId().equals(clinicId))
                .collect(Collectors.toList());
            
            if (!statusFilter.isEmpty()) {
                AppointmentStatus status = AppointmentStatus.valueOf(statusFilter);
                filteredAppointments = filteredAppointments.stream()
                    .filter(appointment -> appointment.getStatus() == status)
                    .collect(Collectors.toList());
            }
            
            // Calculate statistics
            Map<String, Object> stats = calculateStats(filteredAppointments);
            
            // Convert to appointment data
            List<Map<String, Object>> appointments = filteredAppointments.stream()
                .map(this::convertToAppointmentData)
                .collect(Collectors.toList());
            
            response.put("success", true);
            response.put("stats", stats);
            response.put("appointments", appointments);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error tracking appointments: " + e.getMessage());
        }
        
        return response;
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
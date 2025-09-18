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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletResponse;
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

    private static final Logger logger = LoggerFactory.getLogger(AppointmentTrackingController.class);

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
            
            appointmentService.updateAppointmentNotes(appointmentId, newNotes);
            
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
    
    @GetMapping("/tracking/export")
    public void exportAppointmentReport(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String statusFilter,
            @RequestParam(defaultValue = "appointmentDateTime") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            HttpServletResponse response
    ) throws IOException {
        try {
            logger.info("Export request received - startDate: {}, endDate: {}, statusFilter: {}", startDate, endDate, statusFilter);
            
            // Set default date range (last 30 days)
            LocalDate today = LocalDate.now();
            LocalDate thirtyDaysAgo = today.minusDays(30);
            LocalDate start = (startDate != null && !startDate.isEmpty()) ? LocalDate.parse(startDate) : thirtyDaysAgo;
            LocalDate end = (endDate != null && !endDate.isEmpty()) ? LocalDate.parse(endDate) : today;
            
            logger.info("Date range: {} to {}", start, end);

            // Get the current user's clinic
            ClinicModel clinic = PeriDeskUtils.getCurrentClinicModel();
            
            List<Appointment> appointments = appointmentService.getAppointmentsByDateRangeAndClinic(
                start.atStartOfDay(), end.atTime(23, 59, 59), clinic
            );
            
            logger.info("Found {} appointments before filtering", appointments.size());
            
            // Filter by status if specified
            if (statusFilter != null && !statusFilter.isEmpty()) {
                try {
                    AppointmentStatus status = AppointmentStatus.valueOf(statusFilter);
                    appointments = appointments.stream()
                        .filter(appointment -> appointment.getStatus() == status)
                        .collect(Collectors.toList());
                    logger.info("After status filtering: {} appointments", appointments.size());
                } catch (IllegalArgumentException e) {
                    logger.warn("Invalid status filter: {}", statusFilter);
                }
            }
            
            // Sort appointments
            if ("desc".equalsIgnoreCase(direction)) {
                appointments.sort((a1, a2) -> a2.getAppointmentDateTime().compareTo(a1.getAppointmentDateTime()));
            } else {
                appointments.sort((a1, a2) -> a1.getAppointmentDateTime().compareTo(a2.getAppointmentDateTime()));
            }

            // Set response headers for CSV download
            response.setContentType("text/csv; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"appointment-tracking-report.csv\"");

            // Create CSV content
            StringBuilder csvContent = new StringBuilder();
            csvContent.append("Patient Name,Mobile Number,Registration ID,Appointment Date,Appointment Time,Doctor,Status,Notes\n");

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");

            for (Appointment appointment : appointments) {
                try {
                    String patientName = "N/A";
                    if (appointment.getPatientName() != null && !appointment.getPatientName().trim().isEmpty()) {
                        patientName = appointment.getPatientName().trim();
                    } else if (appointment.getPatient() != null) {
                        String firstName = appointment.getPatient().getFirstName() != null ? appointment.getPatient().getFirstName().trim() : "";
                        String lastName = appointment.getPatient().getLastName() != null ? appointment.getPatient().getLastName().trim() : "";
                        if (!firstName.isEmpty() || !lastName.isEmpty()) {
                            patientName = (firstName + " " + lastName).trim();
                        }
                    }
                    
                    String mobile = "N/A";
                    if (appointment.getPatientMobile() != null && !appointment.getPatientMobile().trim().isEmpty()) {
                        mobile = appointment.getPatientMobile().trim();
                    } else if (appointment.getPatient() != null && appointment.getPatient().getPhoneNumber() != null && !appointment.getPatient().getPhoneNumber().trim().isEmpty()) {
                        mobile = appointment.getPatient().getPhoneNumber().trim();
                    }
                    
                    String registrationId = "N/A";
                    if (appointment.getPatient() != null && appointment.getPatient().getRegistrationCode() != null && !appointment.getPatient().getRegistrationCode().trim().isEmpty()) {
                        registrationId = appointment.getPatient().getRegistrationCode().trim();
                    }
                    
                    String appointmentDate = appointment.getAppointmentDateTime().format(dateFormatter);
                    String appointmentTime = appointment.getAppointmentDateTime().format(timeFormatter);
                    
                    String doctorName = "Unassigned";
                    if (appointment.getDoctor() != null) {
                        String firstName = appointment.getDoctor().getFirstName() != null ? appointment.getDoctor().getFirstName().trim() : "";
                        String lastName = appointment.getDoctor().getLastName() != null ? appointment.getDoctor().getLastName().trim() : "";
                        if (!firstName.isEmpty() || !lastName.isEmpty()) {
                            doctorName = "Dr. " + (firstName + " " + lastName).trim();
                        }
                    }
                    
                    String status = appointment.getStatus() != null ? appointment.getStatus().toString() : "UNKNOWN";
                    String notes = "";
                    if (appointment.getNotes() != null && !appointment.getNotes().trim().isEmpty()) {
                        notes = appointment.getNotes().trim().replace("\"", "\"\"").replace("\n", " ").replace("\r", " ");
                    }

                    csvContent.append(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",
                        patientName, mobile, registrationId, appointmentDate, appointmentTime, doctorName, status, notes));
                } catch (Exception e) {
                    // Skip this appointment if there's an error processing it
                    continue;
                }
            }

            // Write CSV content to response
            logger.info("Writing CSV content, size: {} characters", csvContent.length());
            response.getWriter().write(csvContent.toString());
            response.getWriter().flush();
            logger.info("Export completed successfully");
            
        } catch (Exception e) {
            logger.error("Error generating export", e);
            // If there's any error, return an error response
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain");
            response.getWriter().write("Error generating export: " + e.getMessage());
        }
    }
}
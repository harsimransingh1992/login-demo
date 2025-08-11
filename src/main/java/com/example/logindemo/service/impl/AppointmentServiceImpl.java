package com.example.logindemo.service.impl;

import com.example.logindemo.dto.RescheduleAppointmentDTO;
import com.example.logindemo.exception.EntityNotFoundException;
import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentHistory;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.AppointmentHistoryRepository;
import com.example.logindemo.repository.AppointmentRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.AppointmentService;
import com.example.logindemo.utils.PeriDeskUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private static final Logger logger = LoggerFactory.getLogger(AppointmentServiceImpl.class);

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AppointmentHistoryRepository appointmentHistoryRepository;

    @Override
    public List<Appointment> getTodayAppointments() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfDay = startOfDay.plusDays(1);
        return appointmentRepository.findByAppointmentDateTimeBetween(startOfDay, endOfDay);
    }

    @Override
    public List<Appointment> getAppointmentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        logger.debug("Fetching appointments between {} and {}", startDate, endDate);
        return appointmentRepository.findByAppointmentDateTimeBetween(startDate, endDate);
    }

    @Override
    @Transactional
    public void updateAppointmentStatus(Long appointmentId, AppointmentStatus newStatus, String patientRegistrationNumber) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalStateException("Appointment not found"));

        // Validate status transition
        if (isTerminalStatus(appointment.getStatus())) {
            throw new IllegalStateException("Cannot change status from terminal state: " + appointment.getStatus());
        }

        // Validate transition from SCHEDULED
        if (appointment.getStatus() == AppointmentStatus.SCHEDULED) {
            if (newStatus != AppointmentStatus.COMPLETED && 
                newStatus != AppointmentStatus.CANCELLED && 
                newStatus != AppointmentStatus.NO_SHOW) {
                throw new IllegalStateException("From SCHEDULED, can only transition to COMPLETED, CANCELLED, or NO_SHOW");
            }
        }

        // Handle patient registration for COMPLETED status
        if (newStatus == AppointmentStatus.COMPLETED) {
            if (patientRegistrationNumber == null || patientRegistrationNumber.trim().isEmpty()) {
                throw new IllegalStateException("Patient registration number is required for completing the appointment");
            }
            
            // Find patient by registration code
            Patient patient = patientRepository.findByRegistrationCode(patientRegistrationNumber)
                    .orElseThrow(() -> new IllegalStateException("Invalid patient registration number"));
            
            // Link patient to appointment
            appointment.setPatient(patient);
        }

        appointment.setStatus(newStatus);
        appointmentRepository.save(appointment);
    }

    private boolean isTerminalStatus(AppointmentStatus status) {
        return status == AppointmentStatus.CANCELLED || status == AppointmentStatus.NO_SHOW;
    }

    @Override
    @Transactional
    public void createAppointment(String patientName, String patientMobile, LocalDateTime appointmentDateTime, Authentication authentication) {
        try {
            logger.debug("Creating appointment for patient: {} with mobile: {}", patientName, patientMobile);
            
            User currentUser = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Current user not found"));
            ClinicModel currentClinic = currentUser.getClinic();
            
            Appointment appointment = new Appointment();
            appointment.setPatientName(patientName);
            appointment.setPatientMobile(patientMobile);
            appointment.setAppointmentDateTime(appointmentDateTime);
            appointment.setClinic(currentClinic);
            appointment.setStatus(AppointmentStatus.SCHEDULED);
            appointment.setAppointmentBookedBy(currentUser);
            
            logger.debug("Saving appointment for walk-in patient");
            appointmentRepository.save(appointment);
            logger.info("Appointment created successfully for patient: {}", patientName);
            
        } catch (Exception e) {
            logger.error("Failed to create appointment", e);
            throw new IllegalStateException("Failed to create appointment: " + e.getMessage(), e);
        }
    }

    @Override
    @Transactional
    public Appointment updateAppointment(Long id, Appointment appointment) {
        Appointment existingAppointment = appointmentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Appointment not found"));
        
        if (!isTimeSlotAvailable(appointment.getDoctor(), appointment.getAppointmentDateTime())) {
            throw new RuntimeException("Selected time slot is not available");
        }
        
        existingAppointment.setDoctor(appointment.getDoctor());
        existingAppointment.setPatient(appointment.getPatient());
        existingAppointment.setAppointmentDateTime(appointment.getAppointmentDateTime());
        existingAppointment.setStatus(appointment.getStatus());
        existingAppointment.setClinic(appointment.getClinic());
        
        return appointmentRepository.save(existingAppointment);
    }

    @Override
    @Transactional
    public void deleteAppointment(Long id) {
        appointmentRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Appointment getAppointmentById(Long id) {
        return appointmentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Appointment not found"));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByDoctor(User doctor) {
        return appointmentRepository.findByDoctorOrderByAppointmentDateTimeDesc(doctor);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByPatient(User patient) {
        return appointmentRepository.findByPatientOrderByAppointmentDateTimeDesc(patient);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByStatus(AppointmentStatus status) {
        return appointmentRepository.findByStatusOrderByAppointmentDateTimeDesc(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByDoctorAndDateRange(User doctor, LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.findByDoctorAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(doctor, start, end);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByPatientAndDateRange(User patient, LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.findByPatientAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(patient, start, end);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isTimeSlotAvailable(User doctor, LocalDateTime appointmentDateTime) {
        return !appointmentRepository.existsConflictingAppointment(doctor, appointmentDateTime);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getUpcomingAppointmentsForUser(User user) {
        LocalDateTime now = LocalDateTime.now();
        return appointmentRepository.findUpcomingAppointmentsForUser(user, now);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getUpcomingAppointmentsForUserInClinic(User user, ClinicModel clinic) {
        LocalDateTime now = LocalDateTime.now();
        return appointmentRepository.findUpcomingAppointmentsForUserInClinic(user, clinic, now);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByDateRangeAndClinic(LocalDateTime startDate, LocalDateTime endDate, ClinicModel clinic) {
        logger.debug("Fetching appointments between {} and {} for clinic {}", startDate, endDate, clinic.getClinicName());
        return appointmentRepository.findByClinicIdAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(clinic.getId(), startDate, endDate);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsForUserInDateRange(User user, LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.findAppointmentsForUserInDateRange(user, start, end);
    }
    
    // Pagination methods
    @Override
    @Transactional(readOnly = true)
    public Page<Appointment> getAllAppointmentsPaginated(Pageable pageable) {
        return appointmentRepository.findAll(pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Appointment> getAppointmentsByClinicPaginated(ClinicModel clinic, Pageable pageable) {
        return appointmentRepository.findByClinicOrderByAppointmentDateTimeDesc(clinic, pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Appointment> getAppointmentsByDateRangeAndClinicPaginated(LocalDateTime startDate, LocalDateTime endDate, ClinicModel clinic, Pageable pageable) {
        logger.debug("Fetching appointments between {} and {} for clinic {} with pagination", startDate, endDate, clinic.getClinicName());
        return appointmentRepository.findByClinicAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(clinic, startDate, endDate, pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Appointment> getUpcomingAppointmentsForUserInClinicPaginated(User user, ClinicModel clinic, Pageable pageable) {
        LocalDateTime now = LocalDateTime.now();
        return appointmentRepository.findUpcomingAppointmentsForDoctorInClinicWithPagination(user, clinic, now, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Appointment> getAppointmentsByDateRangeAndClinicAndStatusPaginated(LocalDateTime startDate, LocalDateTime endDate, ClinicModel clinic, AppointmentStatus status, Pageable pageable) {
        return appointmentRepository.findByClinicAndAppointmentDateTimeBetweenAndStatusOrderByAppointmentDateTimeDesc(clinic, startDate, endDate, status, pageable);
    }
    
    // Enhanced reschedule methods
    @Override
    @Transactional
    public Appointment rescheduleAppointment(RescheduleAppointmentDTO dto, User currentUser) {
        // 1. Validate request
        validateRescheduleRequest(dto);
        
        // 2. Get appointment
        Appointment appointment = appointmentRepository.findById(dto.getAppointmentId())
            .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));
        
        // 3. Check if can be rescheduled
        if (!canReschedule(appointment)) {
            throw new IllegalStateException("Appointment cannot be rescheduled. " + 
                "Max reschedules reached or invalid status.");
        }
        
        // 4. Store original date if first reschedule
        if (appointment.getOriginalAppointmentDateTime() == null) {
            appointment.setOriginalAppointmentDateTime(appointment.getAppointmentDateTime());
        }
        
        // 5. Calculate reschedule number
        int rescheduleNumber = (appointment.getRescheduledCount() != null ? appointment.getRescheduledCount() : 0) + 1;
        
        // 6. Update appointment
        LocalDateTime oldDateTime = appointment.getAppointmentDateTime();
        appointment.setAppointmentDateTime(dto.getNewAppointmentDateTime());
        appointment.setRescheduledCount(rescheduleNumber);
        appointment.setLastRescheduledBy(currentUser);
        appointment.setLastRescheduledAt(LocalDateTime.now());
        appointment.setRescheduleReason(dto.getReason());
        
        // 7. Save appointment
        appointment = appointmentRepository.save(appointment);
        
        // 8. Create history record with reschedule number
        AppointmentHistory history = new AppointmentHistory(
            appointment, "RESCHEDULED", 
            oldDateTime.toString(), dto.getNewAppointmentDateTime().toString(),
            currentUser, 
            String.format("Reschedule #%d: %s%s", rescheduleNumber, dto.getReason(), 
                         dto.getAdditionalNotes() != null ? " - " + dto.getAdditionalNotes() : ""),
            rescheduleNumber
        );
        appointmentHistoryRepository.save(history);
        
        logger.info("Appointment {} rescheduled for the {} time by user {}", 
                   appointment.getId(), rescheduleNumber, currentUser.getUsername());
        
        return appointment;
    }
    
    @Override
    @Transactional(readOnly = true)
    public boolean canReschedule(Appointment appointment) {
        return appointment.canBeRescheduled();
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<AppointmentHistory> getAppointmentHistory(Long appointmentId) {
        return appointmentHistoryRepository.findByAppointmentIdOrderByChangedAtDesc(appointmentId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<AppointmentHistory> getRescheduleHistory(Long appointmentId) {
        return appointmentHistoryRepository.findByAppointmentIdAndActionOrderByChangedAtDesc(appointmentId, "RESCHEDULED");
    }
    
    @Override
    @Transactional(readOnly = true)
    public int getRemainingReschedules(Long appointmentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
            .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));
        return appointment.getRemainingReschedules();
    }
    
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getRescheduleSummary(Long appointmentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
            .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));
        
        List<AppointmentHistory> rescheduleHistory = getRescheduleHistory(appointmentId);
        
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalReschedules", appointment.getRescheduledCount());
        summary.put("remainingReschedules", appointment.getRemainingReschedules());
        summary.put("canReschedule", appointment.canBeRescheduled());
        summary.put("originalDateTime", appointment.getOriginalAppointmentDateTime());
        summary.put("currentDateTime", appointment.getAppointmentDateTime());
        summary.put("rescheduleHistory", rescheduleHistory);
        summary.put("lastRescheduledBy", appointment.getLastRescheduledBy());
        summary.put("lastRescheduledAt", appointment.getLastRescheduledAt());
        
        return summary;
    }
    
    @Override
    public void validateRescheduleRequest(RescheduleAppointmentDTO dto) {
        if (dto.getAppointmentId() == null) {
            throw new IllegalArgumentException("Appointment ID is required");
        }
        
        if (dto.getNewAppointmentDateTime() == null) {
            throw new IllegalArgumentException("New appointment date/time is required");
        }
        
        if (dto.getNewAppointmentDateTime().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("New appointment date/time cannot be in the past");
        }
        
        if (dto.getReason() == null || dto.getReason().trim().isEmpty()) {
            throw new IllegalArgumentException("Reschedule reason is required");
        }
    }
} 
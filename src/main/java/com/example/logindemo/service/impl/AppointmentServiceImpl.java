package com.example.logindemo.service.impl;

import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.User;
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
import java.util.List;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private static final Logger logger = LoggerFactory.getLogger(AppointmentServiceImpl.class);

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

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
} 
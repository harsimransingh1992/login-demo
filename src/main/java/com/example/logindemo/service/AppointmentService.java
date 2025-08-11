package com.example.logindemo.service;

import com.example.logindemo.dto.RescheduleAppointmentDTO;
import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentHistory;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface AppointmentService {
    List<Appointment> getTodayAppointments();
    List<Appointment> getAppointmentsByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    List<Appointment> getAppointmentsByDateRangeAndClinic(LocalDateTime startDate, LocalDateTime endDate, ClinicModel clinic);
    void createAppointment(String patientName, String patientMobile, LocalDateTime appointmentDateTime, Authentication authentication);
    void updateAppointmentStatus(Long appointmentId, AppointmentStatus newStatus, String patientRegistrationNumber);
    Appointment updateAppointment(Long id, Appointment appointment);
    void deleteAppointment(Long id);
    Appointment getAppointmentById(Long id);
    List<Appointment> getAppointmentsByDoctor(User doctor);
    List<Appointment> getAppointmentsByPatient(User patient);
    List<Appointment> getAppointmentsByStatus(AppointmentStatus status);
    List<Appointment> getAppointmentsByDoctorAndDateRange(User doctor, LocalDateTime start, LocalDateTime end);
    List<Appointment> getAppointmentsByPatientAndDateRange(User patient, LocalDateTime start, LocalDateTime end);
    boolean isTimeSlotAvailable(User doctor, LocalDateTime appointmentDateTime);
    List<Appointment> getUpcomingAppointmentsForUser(User user);
    List<Appointment> getUpcomingAppointmentsForUserInClinic(User user, ClinicModel clinic);
    List<Appointment> getAppointmentsForUserInDateRange(User user, LocalDateTime start, LocalDateTime end);
    
    // Pagination methods
    Page<Appointment> getAllAppointmentsPaginated(Pageable pageable);
    Page<Appointment> getAppointmentsByClinicPaginated(ClinicModel clinic, Pageable pageable);
    Page<Appointment> getAppointmentsByDateRangeAndClinicPaginated(LocalDateTime startDate, LocalDateTime endDate, ClinicModel clinic, Pageable pageable);
    Page<Appointment> getUpcomingAppointmentsForUserInClinicPaginated(User user, ClinicModel clinic, Pageable pageable);
    Page<Appointment> getAppointmentsByDateRangeAndClinicAndStatusPaginated(LocalDateTime startDate, LocalDateTime endDate, ClinicModel clinic, AppointmentStatus status, Pageable pageable);
    
    // Enhanced reschedule methods
    Appointment rescheduleAppointment(RescheduleAppointmentDTO dto, User currentUser);
    List<AppointmentHistory> getAppointmentHistory(Long appointmentId);
    List<AppointmentHistory> getRescheduleHistory(Long appointmentId);
    boolean canReschedule(Appointment appointment);
    void validateRescheduleRequest(RescheduleAppointmentDTO dto);
    int getRemainingReschedules(Long appointmentId);
    Map<String, Object> getRescheduleSummary(Long appointmentId);
} 
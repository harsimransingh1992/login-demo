package com.example.logindemo.repository;

import com.example.logindemo.model.Appointment;
import com.example.logindemo.model.AppointmentStatus;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    
    // Find appointments by doctor
    List<Appointment> findByDoctorOrderByAppointmentDateTimeDesc(User doctor);
    
    // Find appointments by patient
    List<Appointment> findByPatientOrderByAppointmentDateTimeDesc(User patient);
    
    // Find appointments by clinic
    List<Appointment> findByClinicIdOrderByAppointmentDateTimeDesc(Long clinicId);
    
    // Find appointments by status
    List<Appointment> findByStatusOrderByAppointmentDateTimeDesc(AppointmentStatus status);
    
    // Find appointments by doctor and date range
    List<Appointment> findByDoctorAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(
        User doctor, LocalDateTime start, LocalDateTime end);
    
    // Find appointments by patient and date range
    List<Appointment> findByPatientAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(
        User patient, LocalDateTime start, LocalDateTime end);
    
    // Find appointments by clinic and date range
    List<Appointment> findByClinicIdAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(
        Long clinicId, LocalDateTime start, LocalDateTime end);
    
    // Find appointments by doctor and status
    List<Appointment> findByDoctorAndStatusOrderByAppointmentDateTimeDesc(
        User doctor, AppointmentStatus status);
    
    // Find appointments by patient and status
    List<Appointment> findByPatientAndStatusOrderByAppointmentDateTimeDesc(
        User patient, AppointmentStatus status);
    
    // Find appointments by clinic and status
    List<Appointment> findByClinicIdAndStatusOrderByAppointmentDateTimeDesc(
        Long clinicId, AppointmentStatus status);
    
    // Check for conflicting appointments
    @Query("SELECT COUNT(a) > 0 FROM Appointment a WHERE a.doctor = ?1 AND a.status != 'CANCELLED' " +
           "AND a.status != 'NO_SHOW' AND a.status != 'COMPLETED' " +
           "AND a.appointmentDateTime = ?2")
    boolean existsConflictingAppointment(User doctor, LocalDateTime appointmentDateTime);

    List<Appointment> findByAppointmentDateTimeBetween(LocalDateTime start, LocalDateTime end);
    List<Appointment> findByDoctor(User doctor);
    List<Appointment> findByPatient(User patient);
    List<Appointment> findByStatus(AppointmentStatus status);
    List<Appointment> findByDoctorAndAppointmentDateTimeBetween(User doctor, LocalDateTime start, LocalDateTime end);
    List<Appointment> findByPatientAndAppointmentDateTimeBetween(User patient, LocalDateTime start, LocalDateTime end);
    List<Appointment> findByDoctorAndAppointmentDateTime(User doctor, LocalDateTime appointmentDateTime);
    
    // Find appointments where user is either doctor or booked by
    @Query("SELECT a FROM Appointment a WHERE (a.doctor = ?1 OR a.appointmentBookedBy = ?1) AND a.appointmentDateTime >= ?2 ORDER BY a.appointmentDateTime ASC")
    List<Appointment> findUpcomingAppointmentsForUser(User user, LocalDateTime fromDateTime);
    
    // Find appointments where user is either doctor or booked by within date range
    @Query("SELECT a FROM Appointment a WHERE (a.doctor = ?1 OR a.appointmentBookedBy = ?1) AND a.appointmentDateTime BETWEEN ?2 AND ?3 ORDER BY a.appointmentDateTime ASC")
    List<Appointment> findAppointmentsForUserInDateRange(User user, LocalDateTime startDateTime, LocalDateTime endDateTime);
    
    // Find appointments where user is either doctor or booked by within a specific clinic
    @Query("SELECT a FROM Appointment a WHERE (a.doctor = ?1 OR a.appointmentBookedBy = ?1) AND a.clinic = ?2 AND a.appointmentDateTime >= ?3 ORDER BY a.appointmentDateTime ASC")
    List<Appointment> findUpcomingAppointmentsForUserInClinic(User user, ClinicModel clinic, LocalDateTime fromDateTime);
    
    // Pagination methods
    Page<Appointment> findAll(Pageable pageable);
    
    // Find appointments by clinic with pagination
    Page<Appointment> findByClinicOrderByAppointmentDateTimeDesc(ClinicModel clinic, Pageable pageable);
    
    // Find appointments by clinic and date range with pagination
    Page<Appointment> findByClinicAndAppointmentDateTimeBetweenOrderByAppointmentDateTimeDesc(
        ClinicModel clinic, LocalDateTime start, LocalDateTime end, Pageable pageable);
    
    // Find upcoming appointments for user in clinic with pagination
    @Query("SELECT a FROM Appointment a WHERE (a.doctor = ?1 OR a.appointmentBookedBy = ?1) AND a.clinic = ?2 AND a.appointmentDateTime >= ?3 ORDER BY a.appointmentDateTime ASC")
    Page<Appointment> findUpcomingAppointmentsForUserInClinicWithPagination(
        User user, ClinicModel clinic, LocalDateTime fromDateTime, Pageable pageable);
    
    // Find upcoming appointments where the user is the assigned doctor (for 'myAppointments')
    @Query("SELECT a FROM Appointment a WHERE a.doctor = ?1 AND a.clinic = ?2 AND a.appointmentDateTime >= ?3 ORDER BY a.appointmentDateTime ASC")
    Page<Appointment> findUpcomingAppointmentsForDoctorInClinicWithPagination(User doctor, ClinicModel clinic, LocalDateTime fromDateTime, Pageable pageable);
} 
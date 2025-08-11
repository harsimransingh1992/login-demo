package com.example.logindemo.repository;

import com.example.logindemo.model.AppointmentHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AppointmentHistoryRepository extends JpaRepository<AppointmentHistory, Long> {
    
    List<AppointmentHistory> findByAppointmentIdOrderByChangedAtDesc(Long appointmentId);
    
    List<AppointmentHistory> findByAppointmentIdAndActionOrderByChangedAtDesc(Long appointmentId, String action);
    
    // Get specific reschedule by number
    AppointmentHistory findByAppointmentIdAndActionAndRescheduleNumber(Long appointmentId, String action, Integer rescheduleNumber);
    
    // Get all reschedules for an appointment
    List<AppointmentHistory> findByAppointmentIdAndActionOrderByRescheduleNumberAsc(Long appointmentId, String action);
    
    // Count reschedules for an appointment
    long countByAppointmentIdAndAction(Long appointmentId, String action);
} 
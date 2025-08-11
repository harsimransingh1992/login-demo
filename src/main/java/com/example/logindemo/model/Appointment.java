package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;
import org.springframework.lang.Nullable;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "appointments")
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patient_id", nullable = true)
    private Patient patient;

    @Column(name = "patient_name")
    private String patientName;

    @Column(name = "patient_mobile")
    private String patientMobile;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "appointmentBookedBy_id", nullable = true)
    private User appointmentBookedBy;

    @Column(nullable = false)
    private LocalDateTime appointmentDateTime;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private AppointmentStatus status = AppointmentStatus.SCHEDULED;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "clinic_id")
    private ClinicModel clinic;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "doctor_id", nullable = true)
    private User doctor;

    @Column(name = "notes", length = 1000)
    private String notes;

    // Reschedule tracking fields
    @Column(name = "original_appointment_date_time")
    private LocalDateTime originalAppointmentDateTime;
    
    @Column(name = "rescheduled_count")
    private Integer rescheduledCount = 0;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "last_rescheduled_by_id")
    private User lastRescheduledBy;
    
    @Column(name = "last_rescheduled_at")
    private LocalDateTime lastRescheduledAt;
    
    @Column(name = "reschedule_reason", length = 500)
    private String rescheduleReason;
    
    // Helper methods for multiple reschedules
    public boolean isRescheduled() {
        return originalAppointmentDateTime != null;
    }
    
    public boolean canBeRescheduled() {
        // Business rule: max 3 reschedules allowed
        return (rescheduledCount == null || rescheduledCount < 3) && 
               (status == AppointmentStatus.SCHEDULED);
    }
    
    public String getRescheduleHistory() {
        if (rescheduledCount == null || rescheduledCount == 0) {
            return "Not rescheduled";
        }
        return String.format("Rescheduled %d time(s)", rescheduledCount);
    }
    
    public int getRemainingReschedules() {
        return Math.max(0, 3 - (rescheduledCount != null ? rescheduledCount : 0));
    }
    
    public boolean isAtMaxReschedules() {
        return rescheduledCount != null && rescheduledCount >= 3;
    }

} 
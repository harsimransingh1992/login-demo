package com.example.logindemo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "appointment_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentHistory {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "appointment_id", nullable = false)
    private Appointment appointment;
    
    @Column(name = "action", nullable = false)
    private String action; // 'CREATED', 'RESCHEDULED', 'CANCELLED', 'STATUS_CHANGED'
    
    @Column(name = "old_value")
    private String oldValue;
    
    @Column(name = "new_value")
    private String newValue;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by_id")
    private User changedBy;
    
    @Column(name = "changed_at")
    private LocalDateTime changedAt;
    
    @Column(name = "notes")
    private String notes;
    
    @Column(name = "reschedule_number")
    private Integer rescheduleNumber = 0; // Track which reschedule this is (1st, 2nd, 3rd, etc.)
    
    // Constructor for reschedule history
    public AppointmentHistory(Appointment appointment, String action, String oldValue, 
                            String newValue, User changedBy, String notes, int rescheduleNumber) {
        this.appointment = appointment;
        this.action = action;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.changedBy = changedBy;
        this.notes = notes;
        this.rescheduleNumber = rescheduleNumber;
        this.changedAt = LocalDateTime.now();
    }
    
    // Constructor for other actions
    public AppointmentHistory(Appointment appointment, String action, String oldValue, 
                            String newValue, User changedBy, String notes) {
        this(appointment, action, oldValue, newValue, changedBy, notes, 0);
    }
} 
package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Setter
@Getter
@Entity
@Table(name = "checkinrecord")
public class CheckInRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "check_in_time")
    private LocalDateTime checkInTime;

    @OneToOne
    private User checkInClinic;

    @Column(name = "check_out_time")
    private LocalDateTime checkOutTime;

    @ManyToOne
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "clinic_id")
    private ClinicModel clinic;

    @ManyToOne
    @JoinColumn(name = "assigned_doctor_id")
    private User assignedDoctor;

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private CheckInStatus status = CheckInStatus.WAITING;
}

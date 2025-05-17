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

    @Column
    private LocalDateTime  checkInTime;

    @OneToOne
    private User checkInClinic;

    @Column
    private LocalDateTime  checkOutTime;

    @ManyToOne
    private Patient patient;

}

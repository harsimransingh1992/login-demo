package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Setter
@Getter
@Entity
@Table(name = "doctordetails")
public class DoctorDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private String doctorName;

    @ManyToOne
    private User onboardClinic;

    @Column
    private String doctorMobileNumber;

    @Column
    private LocalDate doctorBirthday;

}

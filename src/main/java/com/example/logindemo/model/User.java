package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;
    
    @Column(nullable = false)
    private String firstName;
    
    @Column(nullable = false)
    private String lastName;
    
    @Column
    private String email;
    
    @Column
    private String phoneNumber;
    
    // New fields for dental professionals
    
    @Column
    private String specialization; // Orthodontist, Periodontist, etc.
    
    @Column
    private String licenseNumber; // Professional license number
    
    @Column
    private LocalDate licenseExpiryDate;
    
    @Column
    private String qualification; // BDS, MDS, PhD, etc.
    
    @Column
    private String designation; // Job title/position
    
    @Column
    private LocalDate joiningDate; // When they joined the clinic
    
    @Column
    private String emergencyContact;
    
    @Column
    private String address;
    
    @Column(length = 1000)
    private String bio; // Professional biography
    
    @Column
    private Boolean isActive = true;
    
    @Column
    private Boolean forcePasswordChange = false;
    
    @ManyToOne
    @JoinColumn(name = "clinic_id")
    private ClinicModel clinic;
    
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private UserRole role = UserRole.STAFF; // Default role
    
    @OneToMany(mappedBy = "owner")
    private List<ClinicModel> ownedClinics; // Changed from OneToOne to OneToMany
} 
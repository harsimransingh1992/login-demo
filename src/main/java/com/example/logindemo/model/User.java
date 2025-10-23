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
    
    @Column
    private Boolean canRefund = false;
    
    @Column
    private Boolean canApplyDiscount = false;

    @Column
    private Boolean canDeleteExamination = false;
    
    @ManyToOne
    @JoinColumn(name = "clinic_id")
    private ClinicModel clinic;
    
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private UserRole role = UserRole.STAFF; // Default role
    
    @OneToMany(mappedBy = "owner")
    private List<ClinicModel> ownedClinics; // Changed from OneToOne to OneToMany

    // Cross-clinic appointment access flags (now persisted)
    @Column(name = "has_cross_clinic_appt_access")
    private Boolean hasCrossClinicApptAccess = false;

    @ManyToMany
    @JoinTable(
        name = "user_accessible_clinics",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "clinic_id")
    )
    private List<ClinicModel> accessibleClinics;

    // Explicit getters/setters to ensure compilation when Lombok is unavailable
    public String getEmail() { return this.email; }
    public String getFirstName() { return this.firstName; }
    public String getUsername() { return this.username; }
    public void setPassword(String password) { this.password = password; }
    public void setForcePasswordChange(Boolean force) { this.forcePasswordChange = force; }
}
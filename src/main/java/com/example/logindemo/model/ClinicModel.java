package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "clinics")
public class ClinicModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String clinicId;
    
    @Column(nullable = false)
    private String clinicName;
    
    @Column
    @Enumerated(EnumType.STRING)
    private CityTier cityTier = CityTier.TIER1; // Default to Tier 1
    
    // Changed from DoctorDetail to User with a role filter in application code
    @OneToMany(mappedBy = "clinic")
    private List<User> doctors;
    
    // Reference to the User who created/owns this clinic
    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;
} 
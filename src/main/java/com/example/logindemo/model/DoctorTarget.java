package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Table(name = "doctor_targets")
public class DoctorTarget {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private CityTier cityTier;
    
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal monthlyRevenueTarget;
    
    @Column(nullable = false)
    private Integer monthlyPatientTarget;
    
    @Column(nullable = false)
    private Integer monthlyProcedureTarget;
    
    @Column
    private String description;
    
    @Column
    private Boolean isActive = true;
} 
package com.example.logindemo.model;

import javax.persistence.*;

import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "procedure_prices")
public class ProcedurePrice {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Enumerated(EnumType.STRING)
    private CityTier cityTier;
    
    private String procedureName;
    
    private Double price;

    @Enumerated(EnumType.STRING)
    private DentalDepartment dentalDepartment;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean active = true;
}

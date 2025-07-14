package com.example.logindemo.model;

import lombok.Getter;

/**
 * Enum representing different dental specializations
 */
@Getter
public enum DentalSpecialization {
    GENERAL_DENTISTRY("General Dentistry"),
    ORTHODONTICS("Orthodontics"),
    PERIODONTICS("Periodontics"),
    ENDODONTICS("Endodontics"),
    PROSTHODONTICS("Prosthodontics"),
    ORAL_MAXILLOFACIAL_SURGERY("Oral and Maxillofacial Surgery"),
    PEDODONTICS("Pedodontics"),
    COSMETIC_DENTISTRY("Cosmetic Dentistry");
    
    private final String displayName;
    
    DentalSpecialization(String displayName) {
        this.displayName = displayName;
    }

    @Override
    public String toString() {
        return displayName;
    }
} 
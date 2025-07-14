package com.example.logindemo.dto;

import com.example.logindemo.model.DentalSpecialization;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DentalSpecializationDTO {
    private String name;
    private String displayName;
    
    public static DentalSpecializationDTO fromEntity(DentalSpecialization specialization) {
        if (specialization == null) {
            return null;
        }
        
        DentalSpecializationDTO dto = new DentalSpecializationDTO();
        dto.setName(specialization.name());
        dto.setDisplayName(specialization.getDisplayName());
        return dto;
    }
    
    public DentalSpecialization toEntity() {
        if (name == null || name.isEmpty()) {
            return null;
        }
        
        try {
            return DentalSpecialization.valueOf(name);
        } catch (IllegalArgumentException e) {
            return DentalSpecialization.GENERAL_DENTISTRY; // Default value
        }
    }
} 
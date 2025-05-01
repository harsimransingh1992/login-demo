package com.example.logindemo.dto;

import com.example.logindemo.model.Occupation;
import lombok.Getter;
import lombok.Setter;

/**
 * DTO for Occupation data
 */
@Getter
@Setter
public class OccupationDTO {
    
    private String name;
    private String displayName;
    
    public OccupationDTO() {
    }
    
    public OccupationDTO(String name, String displayName) {
        this.name = name;
        this.displayName = displayName;
    }
    
    /**
     * Create a DTO from an Occupation enum
     */
    public static OccupationDTO fromEntity(Occupation occupation) {
        if (occupation == null) {
            return null;
        }
        return new OccupationDTO(occupation.name(), occupation.getDisplayName());
    }
    
    /**
     * Convert DTO to Occupation enum
     */
    public Occupation toEntity() {
        if (name == null) {
            return null;
        }
        return Occupation.valueOf(name);
    }
} 
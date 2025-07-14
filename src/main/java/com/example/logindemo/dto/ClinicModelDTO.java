package com.example.logindemo.dto;

import com.example.logindemo.model.CityTier;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ClinicModelDTO {
    private Long id;
    private String clinicId;
    private String clinicName;
    private CityTier cityTier;
    
    @JsonIgnoreProperties({"clinic", "ownedClinic"})
    private UserDTO owner;
} 
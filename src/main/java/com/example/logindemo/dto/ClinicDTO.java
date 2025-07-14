package com.example.logindemo.dto;

import com.example.logindemo.model.CityTier;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ClinicDTO {
    private Long id;
    private String clinicId;
    private String clinicName;
    private CityTier cityTier;
    
    @JsonIgnoreProperties({"clinic", "ownedClinic"})
    private UserDTO owner;
    
    @JsonBackReference
    private List<UserDTO> doctors;
} 
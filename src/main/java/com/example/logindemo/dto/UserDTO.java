package com.example.logindemo.dto;

import com.example.logindemo.model.UserRole;
import lombok.Getter;
import lombok.Setter;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.util.List;

@Getter
@Setter
public class UserDTO {
    private Long id;
    private String username;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    
    // New dental professional fields
    private String specialization;
    private String licenseNumber;
    private LocalDate licenseExpiryDate;
    private String qualification;
    private String designation;
    private LocalDate joiningDate;
    private String emergencyContact;
    private String address;
    private String bio;
    private Boolean isActive;
    private Boolean canRefund;
    private Boolean canApplyDiscount;
    private Boolean canDeleteExamination;
    
    // Cross-clinic scheduling access
    private Boolean hasCrossClinicApptAccess;
    // Form-binding list of accessible clinic IDs
    private List<Long> accessibleClinicIds;

    private UserRole role;
    @JsonManagedReference
    private ClinicDTO clinic;
    private ClinicDTO ownedClinic;
    
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
}

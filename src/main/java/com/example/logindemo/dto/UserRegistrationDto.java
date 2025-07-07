package com.example.logindemo.dto;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
public class UserRegistrationDto {
    private String username;
    private String password;
    private String confirmPassword;
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
    
    private Long clinicId;
} 
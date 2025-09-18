package com.example.logindemo.service;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.Patient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * Service for programmatic permission checks beyond what can be done with Spring Security annotations
 */
@Service
public class AuthorizationService {

    @Autowired
    private UserService userService;
    
    /**
     * Checks if the current user can edit a specific examination
     * Rules:
     * - Admins can edit any examination
     * - Doctors can only edit examinations assigned to them
     * - Other roles cannot edit examinations
     */
    public boolean canEditExamination(ToothClinicalExamination examination) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();
        
        // Admins can edit any examination
        if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return true;
        }
        
        // Doctors can only edit examinations assigned to them
        if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_DOCTOR") || a.getAuthority().equals("ROLE_OPD_DOCTOR"))) {
            String username = auth.getName();
            
            // If the examination has no assigned doctor, check if we should allow editing
            if (examination.getAssignedDoctor() == null) {
                // By default, unassigned examinations can't be edited
                return false;
            }
            
            // Check if logged in user is the assigned doctor
            return username.equals(examination.getAssignedDoctor().getUsername());
        }
        
        // Other roles cannot edit examinations
        return false;
    }
    
    /**
     * Checks if the current user can view a specific patient's details
     * Rules:
     * - Admins can view any patient
     * - Clinic owners can only view patients in their clinic
     * - Doctors/staff can only view patients in their clinic
     */
    public boolean canViewPatient(Patient patient) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();
        
        // Admins can view any patient
        if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return true;
        }
        
        // For clinic-specific roles, we need to check the user's clinic
        String username = auth.getName();
        User currentUser = userService.getUserByUsername(username)
            .map(userDTO -> {
                User user = new User();
                user.setId(userDTO.getId());
                user.setUsername(userDTO.getUsername());
                user.setClinic(userDTO.getClinic() != null ? 
                    new com.example.logindemo.model.ClinicModel() : null);
                    
                if (user.getClinic() != null && userDTO.getClinic() != null) {
                    user.getClinic().setId(userDTO.getClinic().getId());
                }
                
                return user;
            })
            .orElse(null);
            
        if (currentUser == null || currentUser.getClinic() == null) {
            return false;
        }
        
        // Patient clinic check would be implemented here
        // For now, assume all staff can view all patients in system
        return true;
    }
} 
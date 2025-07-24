package com.example.logindemo.model;

public enum UserRole {
    ADMIN("Administrator"),
    CLINIC_OWNER("Clinic Owner"),
    DOCTOR("Doctor"),
    STAFF("Staff"),
    RECEPTIONIST("Receptionist"),
    MODERATOR("Moderator");
    
    private final String displayName;
    
    UserRole(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
} 
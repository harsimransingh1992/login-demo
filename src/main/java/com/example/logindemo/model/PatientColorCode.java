package com.example.logindemo.model;

public enum PatientColorCode {
    CODE_BLUE("Code Blue", "#0066CC"),
    CODE_YELLOW("Code Yellow", "#FFD700"),
    NO_CODE("No Code", "#E0E0E0");
    
    private final String displayName;
    private final String hexColor;
    
    PatientColorCode(String displayName, String hexColor) {
        this.displayName = displayName;
        this.hexColor = hexColor;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public String getHexColor() {
        return hexColor;
    }
} 
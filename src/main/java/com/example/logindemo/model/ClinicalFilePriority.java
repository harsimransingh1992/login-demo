package com.example.logindemo.model;

/**
 * Enum representing the priority level of a clinical file.
 */
public enum ClinicalFilePriority {
    LOW("Low"),
    NORMAL("Normal"),
    HIGH("High"),
    URGENT("Urgent");
    
    private final String displayName;
    
    ClinicalFilePriority(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}

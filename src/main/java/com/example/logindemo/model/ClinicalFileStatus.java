package com.example.logindemo.model;

/**
 * Enum representing the status of a clinical file.
 */
public enum ClinicalFileStatus {
    ACTIVE("Active"),
    CLOSED("Closed"),
    ARCHIVED("Archived"),
    PENDING_REVIEW("Pending Review");
    
    private final String displayName;
    
    ClinicalFileStatus(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}

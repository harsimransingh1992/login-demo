package com.example.logindemo.model;

/**
 * Enum representing the treatment phase for media files
 */
public enum TreatmentPhase {
    PRE("pre", "Pre-Treatment"),
    POST("post", "Post-Treatment");
    
    private final String value;
    private final String displayName;
    
    TreatmentPhase(String value, String displayName) {
        this.value = value;
        this.displayName = displayName;
    }
    
    public String getValue() {
        return value;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    /**
     * Get TreatmentPhase from string value
     * @param value the string value ("pre" or "post")
     * @return the corresponding TreatmentPhase
     * @throws IllegalArgumentException if value is not valid
     */
    public static TreatmentPhase fromValue(String value) {
        if (value == null) {
            throw new IllegalArgumentException("Treatment phase value cannot be null");
        }
        
        String normalizedValue = value.toLowerCase().trim();
        for (TreatmentPhase phase : values()) {
            if (phase.value.equals(normalizedValue)) {
                return phase;
            }
        }
        
        throw new IllegalArgumentException("Invalid treatment phase: " + value + ". Must be 'pre' or 'post'");
    }
    
    /**
     * Check if a string value is valid
     * @param value the string value to check
     * @return true if valid, false otherwise
     */
    public static boolean isValid(String value) {
        try {
            fromValue(value);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
package com.example.logindemo.model;

/**
 * Enum representing common occupation categories
 */
public enum Occupation {
    BUSINESS_OWNER("Business Owner"),
    PROFESSIONAL("Professional"),
    HEALTHCARE("Healthcare"),
    EDUCATION("Education"),
    TECHNOLOGY("Technology"),
    FINANCE("Finance"),
    GOVERNMENT("Government"),
    RETAIL("Retail"),
    MANUFACTURING("Manufacturing"),
    STUDENT("Student"),
    HOMEMAKER("Homemaker"),
    RETIRED("Retired"),
    SELF_EMPLOYED("Self-Employed"),
    AGRICULTURE("Agriculture"),
    OTHER("Other");

    private final String displayName;

    Occupation(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    @Override
    public String toString() {
        return displayName;
    }
} 
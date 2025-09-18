package com.example.logindemo.model;

public enum RefundType {
    FULL("Full Refund"),
    PARTIAL("Partial Refund");

    private final String displayName;

    RefundType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static RefundType fromString(String text) {
        if (text == null || text.trim().isEmpty()) {
            return null;
        }
        try {
            return valueOf(text.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
package com.example.logindemo.model;

public enum PaymentNotes {
    FULL_PAYMENT("Full Payment"),
    PARTIAL_PAYMENT("Partial Payment"),
    ADVANCE_PAYMENT("Advance Payment"),
    REFUND("Refund"),
    ADJUSTMENT("Adjustment"),
    OTHER("Other");

    private final String displayName;

    PaymentNotes(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static PaymentNotes fromString(String text) {
        if (text == null || text.trim().isEmpty()) {
            return OTHER;
        }
        try {
            return valueOf(text.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return OTHER;
        }
    }
} 
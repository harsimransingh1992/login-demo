package com.example.logindemo.model;

public enum PaymentMode {
    CASH("Cash"),
    CARD("Card"),
    UPI("UPI"),
    NET_BANKING("Net Banking"),
    INSURANCE("Insurance"),
    EMI("EMI");

    private final String displayName;

    PaymentMode(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
} 
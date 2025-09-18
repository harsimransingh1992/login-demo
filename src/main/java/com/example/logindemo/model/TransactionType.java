package com.example.logindemo.model;

/**
 * Enum representing the type of payment transaction.
 * Following banking/payment processor patterns like CyberSource.
 */
public enum TransactionType {
    /**
     * A payment capture - money received from patient
     */
    CAPTURE("Payment Capture"),
    
    /**
     * A refund transaction - money returned to patient
     */
    REFUND("Refund"),
    
    /**
     * An authorization (for future use if needed)
     */
    AUTHORIZATION("Authorization"),
    
    /**
     * A void transaction (for future use if needed)
     */
    VOID("Void");
    
    private final String displayName;
    
    TransactionType(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}
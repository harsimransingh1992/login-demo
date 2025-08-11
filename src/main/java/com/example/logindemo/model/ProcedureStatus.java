package com.example.logindemo.model;

import java.util.Set;

/**
 * Enum representing the status of a dental procedure.
 * Similar to JIRA issue statuses for better workflow management.
 */
public enum ProcedureStatus {

    // Initial Phase
    OPEN("Open", "Procedure is created but not yet initiated"),

    // Payment Phase
    PAYMENT_PENDING("Payment Pending", "Awaiting payment verification"),
    PAYMENT_COMPLETED("Payment Completed", "Payment verified and accepted"),
    PAYMENT_DENIED("Payment Denied", "Payment failed or denied"),

    // Procedure Phase
    IN_PROGRESS("In Progress", "Procedure is currently ongoing"),
    ON_HOLD("On Hold", "Procedure is temporarily paused"),

    // Completion Phase
    COMPLETED("Completed", "Procedure completed successfully"),
    CANCELLED("Cancelled", "Procedure was cancelled before completion"),

    // Post-Procedure Phase
    FOLLOW_UP_SCHEDULED("Follow-Up Scheduled", "Follow-up appointment has been scheduled"),
    FOLLOW_UP_COMPLETED("Follow-Up Completed", "Follow-up has been completed"),

    // Closure
    CLOSED("Closed", "Procedure and follow-ups are fully completed, case closed"),
    
    // Reopening
    REOPEN("Reopen", "Case has been reopened for further treatment");

    private final String label;
    private final String description;

    ProcedureStatus(String label, String description) {
        this.label = label;
        this.description = description;
    }

    public String getLabel() {
        return label;
    }

    public String getDescription() {
        return description;
    }

    public Set<ProcedureStatus> getAllowedTransitions() {
        return switch (this) {
            case OPEN, PAYMENT_DENIED -> Set.of(PAYMENT_PENDING, CANCELLED);
            case PAYMENT_PENDING -> Set.of(PAYMENT_DENIED, CANCELLED);
            case PAYMENT_COMPLETED, ON_HOLD -> Set.of(IN_PROGRESS, CANCELLED);
            case IN_PROGRESS -> Set.of(ON_HOLD, COMPLETED, CANCELLED);
            case COMPLETED -> Set.of(FOLLOW_UP_SCHEDULED, CLOSED);
            case FOLLOW_UP_SCHEDULED -> Set.of(FOLLOW_UP_COMPLETED, CLOSED);
            case FOLLOW_UP_COMPLETED -> Set.of(CLOSED);
            case CLOSED -> Set.of(REOPEN);
            case REOPEN -> Set.of(IN_PROGRESS);
            case CANCELLED -> Set.of();
        };
    }
}

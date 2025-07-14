package com.example.logindemo.model;

/**
 * Enum representing the status of a follow-up appointment.
 */
public enum FollowUpStatus {
    SCHEDULED("Scheduled", "Follow-up appointment has been scheduled"),
    COMPLETED("Completed", "Follow-up appointment has been completed"),
    CANCELLED("Cancelled", "Follow-up appointment has been cancelled"),
    NO_SHOW("No Show", "Patient did not show up for the follow-up appointment"),
    RESCHEDULED("Rescheduled", "Follow-up was rescheduled to a new date");

    private final String label;
    private final String description;

    FollowUpStatus(String label, String description) {
        this.label = label;
        this.description = description;
    }

    public String getLabel() {
        return label;
    }

    public String getDescription() {
        return description;
    }
} 
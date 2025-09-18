package com.example.logindemo.model;

/**
 * Enum representing the status of a next sitting appointment.
 */
public enum FollowUpStatus {
    SCHEDULED("Scheduled", "Next sitting appointment has been scheduled"),
    COMPLETED("Completed", "Next sitting appointment has been completed"),
    CANCELLED("Cancelled", "Next sitting appointment has been cancelled"),
    NO_SHOW("No Show", "Patient did not show up for the next sitting appointment"),
    RESCHEDULED("Rescheduled", "Next sitting was rescheduled to a new date");

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
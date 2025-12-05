package com.example.logindemo.model;

public enum MembershipPlan {
    BASIC("Basic Membership Plan"),
    STANDARD("Standard Membership Plan"),
    PREMIUM("Premium Membership Plan");

    private final String displayName;

    MembershipPlan(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}

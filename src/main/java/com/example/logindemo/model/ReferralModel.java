package com.example.logindemo.model;

import lombok.Getter;

@Getter
public enum ReferralModel {
    REFERRAL("Referral from Friend/Family"),
    SEARCH("Search Engine"),
    SOCIAL("Social Media"),
    WALK_IN("Walk In"),
    OTHER("Other");

    private final String displayName;

    ReferralModel(String displayName) {
        this.displayName = displayName;
    }

}
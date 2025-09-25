package com.example.logindemo.model;

import lombok.Getter;

@Getter
public enum ReferralModel {
    REFERRAL("Referral from Friend/Family"),
    SEARCH("Search Engine"),
    SOCIAL("Social Media"),
    WALK_IN("Walk In"),
    OTHER("Other"),
    GOOGLE("Google"),
    WORD_OF_MOUTH("Word of Mouth"),
    PRM("Public Relationship Manager"),
    BNI("BNI"),
    STAFF_REFERENCE("Clinic Staff Reference"),
    SHARK_TANK("Shark Tank"),
    BIKRAM_REFERENCE("Bikramjeet Reference"),
    MEDICAL_STORE_REFERENCE("Medical Store Reference");

    private final String displayName;

    ReferralModel(String displayName) {
        this.displayName = displayName;
    }

}
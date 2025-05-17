package com.example.logindemo.model;

import lombok.Getter;

@Getter
public enum CityTier {
    TIER1("Tier 1 - Metro Cities"),
    TIER2("Tier 2 - Large Cities"),
    TIER3("Tier 3 - Small Cities"),
    TIER4("Tier 4 - Rural Areas");

    private final String displayName;

    CityTier(String displayName) {
        this.displayName = displayName;
    }
}

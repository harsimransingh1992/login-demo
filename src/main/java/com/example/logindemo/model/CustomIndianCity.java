package com.example.logindemo.model;

/**
 * Class to represent custom Indian cities that are not part of the enum
 */
public class CustomIndianCity implements IndianCityInterface {
    private final String displayName;
    private final IndianState state;
    
    public CustomIndianCity(String displayName, IndianState state) {
        this.displayName = displayName;
        this.state = state;
    }

    @Override
    public String getDisplayName() {
        return displayName;
    }

    @Override
    public IndianState getState() {
        return state;
    }
    
    @Override
    public String toString() {
        return displayName;
    }
} 
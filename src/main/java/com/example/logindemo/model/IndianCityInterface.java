package com.example.logindemo.model;

/**
 * Interface for Indian city objects, implemented by both IndianCity enum and custom city implementations.
 */
public interface IndianCityInterface {
    
    /**
     * Get the display name of the city
     * 
     * @return The city name
     */
    String getDisplayName();
    
    /**
     * Get the state this city belongs to
     * 
     * @return The Indian state
     */
    IndianState getState();
} 
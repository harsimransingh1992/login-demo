package com.example.logindemo.util;

import com.example.logindemo.model.IndianCity;
import com.example.logindemo.model.IndianCityInterface;
import com.example.logindemo.model.IndianState;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Utility class for location-related operations.
 */
@Component
public class LocationUtil {

    private static IndiaCitiesDataProvider citiesDataProvider;

    @Autowired
    public void setCitiesDataProvider(IndiaCitiesDataProvider citiesDataProvider) {
        LocationUtil.citiesDataProvider = citiesDataProvider;
    }

    /**
     * Get all Indian states sorted alphabetically.
     * 
     * @return List of all Indian states
     */
    public static List<IndianState> getAllStates() {
        return Arrays.stream(IndianState.values())
                .sorted(Comparator.comparing(IndianState::getDisplayName))
                .collect(Collectors.toList());
    }
    
    /**
     * Get all cities for a specific state sorted alphabetically.
     * 
     * @param state The state to get cities for
     * @return List of cities in the specified state
     */
    public static List<IndianCityInterface> getCitiesByState(IndianState state) {
        // First, check if we have the comprehensive data available
        if (citiesDataProvider != null) {
            // Convert string city names to IndianCity objects
            return citiesDataProvider.getCitiesByState(state).stream()
                .map(cityName -> createCityObject(cityName, state))
                .collect(Collectors.toList());
        }
        
        // Fallback to the enum values if the data provider is not available
        return Arrays.stream(IndianCity.values())
                .filter(city -> city.getState() == state)
                .sorted(Comparator.comparing(IndianCity::getDisplayName))
                .collect(Collectors.toList());
    }
    
    /**
     * Get a state by its name (case-insensitive).
     * 
     * @param stateName The name of the state
     * @return The matching state or null if not found
     */
    public static IndianState getStateByName(String stateName) {
        if (stateName == null || stateName.trim().isEmpty()) {
            return null;
        }
        
        return Arrays.stream(IndianState.values())
                .filter(state -> state.getDisplayName().equalsIgnoreCase(stateName.trim()))
                .findFirst()
                .orElse(null);
    }
    
    /**
     * Get a city by its name and state (case-insensitive).
     * 
     * @param cityName The name of the city
     * @param state The state the city belongs to
     * @return The matching city or null if not found
     */
    public static IndianCityInterface getCityByNameAndState(String cityName, IndianState state) {
        if (cityName == null || cityName.trim().isEmpty() || state == null) {
            return null;
        }
        
        // First check in the existing enum values
        IndianCity existingCity = Arrays.stream(IndianCity.values())
                .filter(city -> city.getState() == state && city.getDisplayName().equalsIgnoreCase(cityName.trim()))
                .findFirst()
                .orElse(null);
        
        if (existingCity != null) {
            return existingCity;
        }
        
        // If not found and we have the comprehensive data provider, create a dynamic city object
        if (citiesDataProvider != null && 
            citiesDataProvider.getCitiesByState(state).stream()
                .anyMatch(city -> city.equalsIgnoreCase(cityName.trim()))) {
            return createCityObject(cityName, state);
        }
        
        return null;
    }
    
    /**
     * Create a dynamic IndianCity object for cities not defined in the enum.
     * This uses a custom implementation of IndianCity to represent cities from our extended data.
     * 
     * @param cityName The name of the city
     * @param state The state
     * @return A custom IndianCity object
     */
    private static IndianCityInterface createCityObject(String cityName, IndianState state) {
        // Check if this city already exists in the enum
        for (IndianCity enumCity : IndianCity.values()) {
            if (enumCity.getState() == state && 
                enumCity.getDisplayName().equalsIgnoreCase(cityName.trim())) {
                return enumCity;
            }
        }
        
        // Create a dynamic city object for cities not in the enum
        return new IndianCityInterface() {
            @Override
            public String getDisplayName() {
                return cityName;
            }
            
            @Override
            public IndianState getState() {
                return state;
            }
            
            @Override
            public String toString() {
                return cityName;
            }
        };
    }
} 
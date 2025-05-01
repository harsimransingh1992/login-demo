package com.example.logindemo.controller;

import com.example.logindemo.model.IndianCity;
import com.example.logindemo.model.IndianState;
import com.example.logindemo.util.IndiaCitiesDataProvider;
import com.example.logindemo.util.LocationUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
@Slf4j
public class ApiController {

    @Autowired
    private IndiaCitiesDataProvider citiesDataProvider;

    @GetMapping("/cities")
    public ResponseEntity<List<Map<String, String>>> getCitiesByState(@RequestParam String state) {
        log.info("Fetching cities for state: {}", state);
        
        IndianState indianState = LocationUtil.getStateByName(state);
        if (indianState != null) {
            // Get cities directly from the data provider for better performance
            List<String> cityNames = citiesDataProvider.getCitiesByState(indianState);
            log.info("Found {} cities for state {}", cityNames.size(), state);
            
            // Convert to simple Map structure for reliable serialization
            List<Map<String, String>> cityMaps = cityNames.stream()
                .map(cityName -> Map.of(
                    "displayName", cityName,
                    "state", indianState.getDisplayName()
                ))
                .collect(Collectors.toList());
            
            return ResponseEntity.ok(cityMaps);
        }
        
        log.warn("No cities found for state: {}", state);
        return ResponseEntity.ok(new ArrayList<>());
    }
} 
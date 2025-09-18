package com.example.logindemo.controller;

import com.example.logindemo.model.IndianCity;
import com.example.logindemo.model.IndianState;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.CheckInRecord;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.service.UserService;
import com.example.logindemo.util.IndiaCitiesDataProvider;
import com.example.logindemo.util.LocationUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
@Slf4j
public class ApiController {

    @Autowired
    private IndiaCitiesDataProvider citiesDataProvider;

    @Resource(name="userRepository")
    private UserRepository userRepository;

    @Resource(name="patientRepository")
    private PatientRepository patientRepository;

    @Resource(name="checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;

    @Autowired
    private UserService userService;

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

    @GetMapping("/clinic-doctors")
    public ResponseEntity<List<Map<String, Object>>> getClinicDoctors() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();
            
            User currentUser = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
                
            ClinicModel clinic = currentUser.getClinic();
            if (clinic == null) {
                return ResponseEntity.ok(new ArrayList<>());
            }

            List<User> doctors = userRepository.findByClinicAndRoleIn(
                clinic, 
                List.of(UserRole.DOCTOR, UserRole.OPD_DOCTOR)
            );

            List<Map<String, Object>> doctorList = doctors.stream()
                .map(doctor -> {
                    Map<String, Object> doctorMap = new HashMap<>();
                    doctorMap.put("id", doctor.getId());
                    doctorMap.put("firstName", doctor.getFirstName());
                    doctorMap.put("lastName", doctor.getLastName());
                    doctorMap.put("username", doctor.getUsername());
                    return doctorMap;
                })
                .collect(Collectors.toList());

            return ResponseEntity.ok(doctorList);
        } catch (Exception e) {
            log.error("Error fetching clinic doctors: {}", e.getMessage(), e);
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    @PostMapping("/change-doctor-assignment")
    public ResponseEntity<Map<String, Object>> changeDoctorAssignment(@RequestBody Map<String, Object> request) {
        try {
            Long patientId = Long.parseLong(request.get("patientId").toString());
            String doctorIdStr = request.get("doctorId") != null ? request.get("doctorId").toString() : "";
            Long doctorId = doctorIdStr.isEmpty() ? null : Long.parseLong(doctorIdStr);

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();
            
            User currentUser = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

            // Get patient
            Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

            // Get current check-in record
            CheckInRecord checkInRecord = patient.getCurrentCheckInRecord();
            if (checkInRecord == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Patient is not currently checked in");
                return ResponseEntity.badRequest().body(errorResponse);
            }

            // Validate doctor belongs to same clinic if provided
            User assignedDoctor = null;
            if (doctorId != null) {
                assignedDoctor = userRepository.findById(doctorId).orElse(null);
                if (assignedDoctor == null || !assignedDoctor.getClinic().equals(currentUser.getClinic())) {
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("message", "Invalid doctor selection");
                    return ResponseEntity.badRequest().body(errorResponse);
                }
            }

            // Update the check-in record
            checkInRecord.setAssignedDoctor(assignedDoctor);
            checkInRecordRepository.save(checkInRecord);

            log.info("Doctor assignment updated for patient {} by user {}", patientId, username);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Doctor assignment updated successfully"
            ));

        } catch (Exception e) {
            log.error("Error changing doctor assignment: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Failed to update doctor assignment: " + e.getMessage()
            ));
        }
    }
} 
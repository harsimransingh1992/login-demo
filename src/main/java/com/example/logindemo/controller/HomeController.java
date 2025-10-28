package com.example.logindemo.controller;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.User;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Slf4j
@Controller
public class HomeController {

    @Resource(name="patientService")
    PatientService patientService;
    
    @Autowired
    UserService userService;

    @GetMapping("/")
    public String home(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated()) {
            try {
                // Get waiting patients
                List<PatientDTO> patients = patientService.getCheckedInPatients();
                log.info("Total Patient Waiting Count: {}", patients.size());
                log.info("Patients data: {}", patients);
                model.addAttribute("waitingPatients", patients);
                
                // Get minimal user information required for the welcome page
                String username = authentication.getName();
                log.info("Loading basic user information for: {}", username);
                
                // Get the logged-in user's clinic
                User loggedInUser = userService.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
                log.info("User clinic: {}", loggedInUser.getClinic());
                model.addAttribute("user", loggedInUser);
                
                return "welcome";
            } catch (Exception e) {
                log.error("Error loading welcome page: {}", e.getMessage(), e);
                model.addAttribute("errorMessage", "An error occurred while loading the dashboard.");
                model.addAttribute("waitingPatients", Collections.emptyList());
                model.addAttribute("username", authentication.getName());
                return "welcome";
            }
        }
        // Show the public marketing homepage for guests
        return "marketing/home";
    }
    
    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }
}
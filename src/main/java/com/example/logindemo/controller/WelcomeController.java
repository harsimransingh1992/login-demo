package com.example.logindemo.controller;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.PatientService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Controller
@Slf4j
public class WelcomeController {

    @Resource(name="patientService")
    PatientService patientService;
    
    @Autowired
    UserService userService;
    
    @Autowired
    UserRepository userRepository;

    @GetMapping("/welcome")
    public String showWelcomePage(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated()) {
            try {
                List<PatientDTO> waitingPatients = patientService.getCheckedInPatients();
                
                // Calculate pending payments for each patient
                for (PatientDTO patient : waitingPatients) {
                    try {
                        Double pendingAmount = patientService.calculatePendingPayments(Long.valueOf(patient.getId()));
                        patient.setPendingPayments(pendingAmount);
                    } catch (Exception e) {
                        log.warn("Could not calculate pending payments for patient {}: {}", patient.getId(), e.getMessage());
                        patient.setPendingPayments(0.0);
                    }
                }
                
                // Get the logged-in user's clinic and add clinic doctors
                String username = authentication.getName();
                User currentUser = userService.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
                
                ClinicModel userClinic = currentUser.getClinic();
                if (userClinic != null) {
                    List<User> clinicDoctors = userRepository.findByClinicAndRoleIn(
                        userClinic, 
                        List.of(UserRole.DOCTOR, UserRole.OPD_DOCTOR)
                    );
                    model.addAttribute("clinicDoctors", clinicDoctors);
                    model.addAttribute("currentUserClinic", userClinic);
                } else {
                    model.addAttribute("clinicDoctors", new ArrayList<>());
                }
                
                model.addAttribute("waitingPatients", waitingPatients);
                model.addAttribute("username", authentication.getName());
                model.addAttribute("currentUser", currentUser);
                return "welcome";
            } catch (Exception e) {
                log.error("Error loading welcome page: {}", e.getMessage(), e);
                model.addAttribute("errorMessage", "An error occurred while loading the dashboard.");
                model.addAttribute("username", authentication.getName());
                model.addAttribute("clinicDoctors", new ArrayList<>());
                return "welcome";
            }
        }
        return "redirect:/login";
    }
}
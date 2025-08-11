package com.example.logindemo.controller;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.service.PatientService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.annotation.Resource;
import java.util.List;
import java.util.Comparator;
import java.util.ArrayList;

@Controller
@Slf4j
public class WelcomeController {

    @Resource(name="patientService")
    PatientService patientService;

    @GetMapping("/welcome")
    public String showWelcomePage(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated()) {
            List<PatientDTO> waitingPatients = patientService.getCheckedInPatients();
            
            // Create a new modifiable list to avoid UnsupportedOperationException
            List<PatientDTO> sortedWaitingPatients = new ArrayList<>(waitingPatients);
            
            // Sort patients by check-in time (earliest first)
            sortedWaitingPatients.sort((p1, p2) -> {
                if (p1.getCurrentCheckInRecord() == null || p1.getCurrentCheckInRecord().getCheckInTime() == null) {
                    return 1; // Move patients without check-in time to the end
                }
                if (p2.getCurrentCheckInRecord() == null || p2.getCurrentCheckInRecord().getCheckInTime() == null) {
                    return -1; // Move patients without check-in time to the end
                }
                return p1.getCurrentCheckInRecord().getCheckInTime().compareTo(p2.getCurrentCheckInRecord().getCheckInTime());
            });
            
            log.info("Total Patient Waiting Count: {}", sortedWaitingPatients.size());
            model.addAttribute("waitingPatients", sortedWaitingPatients);
            model.addAttribute("username", authentication.getName());
            return "welcome";
        }
        return "redirect:/login";
    }
} 
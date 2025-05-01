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

@Controller
@Slf4j
public class WelcomeController {

    @Resource(name="patientService")
    PatientService patientService;

    @GetMapping("/welcome")
    public String showWelcomePage(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated()) {
            List<PatientDTO> waitingPatients = patientService.getCheckedInPatients();
            log.info("Total Patient Waiting Count: {}", waitingPatients.size());
            model.addAttribute("waitingPatients", waitingPatients);
            model.addAttribute("username", authentication.getName());
            return "welcome";
        }
        return "redirect:/login";
    }
} 
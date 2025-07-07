package com.example.logindemo.controller;

import com.example.logindemo.dto.UserRegistrationDto;
import com.example.logindemo.model.ReferralModel;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.ClinicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class RegistrationController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private ClinicService clinicService;

    @GetMapping("/register")
    public String showRegistrationPage(Model model) {
        model.addAttribute("referralModels", ReferralModel.values());
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("registrationDto", new UserRegistrationDto());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("registrationDto") UserRegistrationDto registrationDto, 
                              RedirectAttributes redirectAttributes,
                              Model model) {
        try {
            userService.registerNewUser(registrationDto);
            redirectAttributes.addFlashAttribute("success", "Registration successful! You can now login.");
            return "redirect:/login";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("clinics", clinicService.getAllClinics());
            model.addAttribute("referralModels", ReferralModel.values());
            return "register";
        }
    }
} 
package com.example.logindemo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }
    
    /**
     * Handles the redirect after logout to ensure proper context path
     */
    @GetMapping("/logout-success")
    public RedirectView logoutSuccess() {
        // Use RedirectView to handle context path automatically
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl("/login?logout");
        redirectView.setContextRelative(true);
        return redirectView;
    }
} 
package com.example.logindemo.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/historic-data")
public class HistoricDataController {

    @GetMapping
    @PreAuthorize("hasRole('RECEPTIONIST') or hasRole('ADMIN')")
    public String showHistoricDataHome(Model model) {
        // Placeholder for future aggregated metrics across models (payments, refunds, visits, etc.)
        // We'll start with Payments in the next steps
        model.addAttribute("pageTitle", "Historic Data");
        return "historic-data/index";
    }
}
package com.example.logindemo.controller;

import com.example.logindemo.dto.ReconciliationResponse;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.service.PaymentReconciliationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@Controller
@RequestMapping("/payments")
public class PaymentReconciliationController {

    @Autowired
    private PaymentReconciliationService reconciliationService;

    @GetMapping("/reconciliation")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    public String showReconciliationPage() {
        return "payments/reconciliation";
    }

    @GetMapping("/reconciliation/data")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public ResponseEntity<ReconciliationResponse> getReconciliationData(
            @RequestParam(required = false) String date) {
        LocalDate localDate;
        if (date != null && !date.isEmpty()) {
            localDate = LocalDate.parse(date);
        } else {
            localDate = LocalDate.now();
        }
        ReconciliationResponse response = reconciliationService.getReconciliationData(localDate);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reconcile")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    @ResponseBody
    public ResponseEntity<?> reconcilePayments(@RequestBody Map<String, String> request) {
        LocalDate date = LocalDate.parse(request.get("date"));
        boolean success = reconciliationService.reconcilePayments(date);
        return ResponseEntity.ok(Map.of("success", success));
    }

    @GetMapping("/reconciliation/print")
    @PreAuthorize("hasRole('RECEPTIONIST')")
    public String printReconciliation(
            @RequestParam(required = false) String date,
            org.springframework.ui.Model model) {
        LocalDate localDate = date != null ? LocalDate.parse(date) : LocalDate.now();
        ReconciliationResponse response = reconciliationService.getReconciliationData(localDate);
        
        model.addAttribute("reconciliationData", response);
        model.addAttribute("date", localDate);
        model.addAttribute("formattedDate", localDate.format(DateTimeFormatter.ofPattern("dd MMMM yyyy")));
        
        return "payments/reconciliation-print";
    }
} 
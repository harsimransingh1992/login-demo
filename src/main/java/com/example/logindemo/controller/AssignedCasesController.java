package com.example.logindemo.controller;

import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.ToothClinicalExaminationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.data.domain.Page;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Controller
public class AssignedCasesController {

    @Autowired
    private ToothClinicalExaminationService examinationService;

    @Autowired
    private UserRepository userRepository;

    @PreAuthorize("hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN','MODERATOR')")
    @GetMapping("/assigned-cases")
    public String assignedCasesPage(
            @RequestParam(value = "status", required = false) ProcedureStatus status,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "page", required = false, defaultValue = "0") int page,
            @RequestParam(value = "size", required = false, defaultValue = "10") int size,
            Model model
    ) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth != null ? auth.getName() : null;
        if (username == null) {
            model.addAttribute("errorMessage", "User authentication not found");
            return "access-denied";
        }
        User currentUser = userRepository.findByUsername(username).orElse(null);
        if (currentUser == null) {
            model.addAttribute("errorMessage", "User not found: " + username);
            return "access-denied";
        }

        LocalDateTime from = null;
        LocalDateTime to = null;
        try {
            if (startDate != null && !startDate.trim().isEmpty()) {
                LocalDate start = LocalDate.parse(startDate.trim());
                from = LocalDateTime.of(start, LocalTime.MIN);
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                LocalDate end = LocalDate.parse(endDate.trim());
                to = LocalDateTime.of(end, LocalTime.MAX);
            }
        } catch (Exception e) {
            model.addAttribute("dateParseError", "Invalid date format. Please use YYYY-MM-DD.");
        }

        Page<ToothClinicalExaminationDTO> casesPage = examinationService.getAssignedCases(
                currentUser.getId(), status, from, to, page, size
        );

        model.addAttribute("casesPage", casesPage);
        model.addAttribute("cases", casesPage.getContent());
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("totalPages", casesPage.getTotalPages());
        model.addAttribute("statusFilter", status != null ? status.name() : "");
        model.addAttribute("startDateFilter", startDate != null ? startDate : "");
        model.addAttribute("endDateFilter", endDate != null ? endDate : "");
        model.addAttribute("procedureStatuses", ProcedureStatus.values());

        return "doctor/assigned-cases";
    }
}
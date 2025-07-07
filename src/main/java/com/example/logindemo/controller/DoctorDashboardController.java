package com.example.logindemo.controller;

import com.example.logindemo.dto.DoctorTargetProgressDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.service.DoctorTargetService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.utils.PeriDeskUtils;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/doctor/dashboard")
public class DoctorDashboardController {
    @Autowired
    private ToothClinicalExaminationService examinationService;

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private DoctorTargetService doctorTargetService;

    @GetMapping
    public String showDashboard(
            @RequestParam(value = "from", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate from,
            @RequestParam(value = "to", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate to,
            Model model,
            Authentication authentication
    ) {
        User doctor = PeriDeskUtils.getCurrentUser();
        LocalDateTime fromDate = (from != null) ? from.atStartOfDay() : LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime toDate = (to != null) ? to.atTime(LocalTime.MAX) : LocalDate.now().atTime(LocalTime.MAX);

        List<ToothClinicalExamination> completedExams = examinationService.findByDoctorAndDateWithPayments(
                doctor, fromDate, toDate
        );
        int patientCount = completedExams.size();

        double totalRevenue = completedExams.stream()
            .mapToDouble(exam -> exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0)
            .sum();
        model.addAttribute("totalRevenue", totalRevenue);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        List<Map<String, Object>> examTableRows = new ArrayList<>();
        for (ToothClinicalExamination exam : completedExams) {
            Map<String, Object> row = new HashMap<>();
            row.put("patientName", (exam.getPatient() != null) ? (exam.getPatient().getFirstName() + " " + exam.getPatient().getLastName()) : "N/A");
            row.put("procedureName", (exam.getProcedure() != null) ? exam.getProcedure().getProcedureName() : "N/A");
            row.put("date", (exam.getExaminationDate() != null) ? exam.getExaminationDate().format(formatter) : "N/A");
            row.put("amount", (exam.getTotalPaidAmount() != null) ? exam.getTotalPaidAmount() : -1);
            examTableRows.add(row);
        }
        model.addAttribute("examTableRows", examTableRows);

        // Calculate target progress
        DoctorTargetProgressDTO targetProgress = doctorTargetService.calculateTargetProgress(doctor, fromDate.toLocalDate(), toDate.toLocalDate());
        model.addAttribute("targetProgress", targetProgress);

        model.addAttribute("from", fromDate.toLocalDate());
        model.addAttribute("to", toDate.toLocalDate());
        model.addAttribute("patientCount", patientCount);
        model.addAttribute("completedExams", completedExams);
        return "doctor/dashboard";
    }
} 
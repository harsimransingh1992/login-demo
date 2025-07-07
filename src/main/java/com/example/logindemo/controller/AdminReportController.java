package com.example.logindemo.controller;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.service.AdminReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/reports")
@PreAuthorize("hasRole('ADMIN')")
public class AdminReportController {

    @Autowired
    private AdminReportService adminReportService;

    @GetMapping("/admin/reporting")
    public String showReports(
            @RequestParam(required = false) LocalDateTime startDate,
            @RequestParam(required = false) LocalDateTime endDate,
            Model model) {
        
        // Set default date range if not provided
        if (startDate == null) {
            startDate = LocalDateTime.now().minusMonths(1);
        }
        if (endDate == null) {
            endDate = LocalDateTime.now();
        }

        // Get key metrics
        model.addAttribute("totalProcedures", adminReportService.getTotalProcedures(startDate, endDate));
        model.addAttribute("totalRevenue", adminReportService.getTotalRevenue(startDate, endDate));
        model.addAttribute("avgProcedureTime", adminReportService.getAverageProcedureTime(startDate, endDate));
        model.addAttribute("successRate", adminReportService.getSuccessRate(startDate, endDate));

        // Get procedure distribution
        model.addAttribute("procedureDistribution", adminReportService.getProcedureDistribution(startDate, endDate));

        // Get success rates by condition
        model.addAttribute("successRatesByCondition", adminReportService.getSuccessRatesByCondition(startDate, endDate));

        // Get revenue trends
        model.addAttribute("revenueTrends", adminReportService.getRevenueTrends(startDate, endDate));

        // Get payment mode distribution
        model.addAttribute("paymentModeDistribution", adminReportService.getPaymentModeDistribution(startDate, endDate));

        // Get doctor performance metrics
        model.addAttribute("doctorPerformance", adminReportService.getDoctorPerformance(startDate, endDate));

        // Get procedure status distribution
        model.addAttribute("procedureStatusDistribution", adminReportService.getProcedureStatusDistribution(startDate, endDate));

        // Get recent procedures
        model.addAttribute("recentProcedures", adminReportService.getRecentProcedures(10));

        return "admin/reports";
    }

    @GetMapping("/export")
    @PreAuthorize("hasRole('ADMIN')")
    public String exportReport(
            @RequestParam(required = false) LocalDateTime startDate,
            @RequestParam(required = false) LocalDateTime endDate,
            @RequestParam String format) {
        
        // Set default date range if not provided
        if (startDate == null) {
            startDate = LocalDateTime.now().minusMonths(1);
        }
        if (endDate == null) {
            endDate = LocalDateTime.now();
        }

        // Export report in the requested format
        return adminReportService.exportReport(startDate, endDate, format);
    }
} 
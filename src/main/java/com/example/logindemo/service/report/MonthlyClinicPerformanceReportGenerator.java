package com.example.logindemo.service.report;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Monthly Clinic Performance Report Generator
 * Generates comprehensive monthly performance reports including patient metrics,
 * appointment statistics, and revenue analysis
 */
@Component("monthlyClinicPerformanceReport")
public class MonthlyClinicPerformanceReportGenerator implements ReportGenerator {
    
    private static final Logger log = LoggerFactory.getLogger(MonthlyClinicPerformanceReportGenerator.class);
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Override
    public String generateReport(Map<String, Object> parameters) {
        log.info("Generating Monthly Clinic Performance Report with parameters: {}", parameters);
        
        LocalDate reportDate = getReportDate(parameters);
        LocalDate startDate = reportDate.withDayOfMonth(1);
        LocalDate endDate = reportDate.withDayOfMonth(reportDate.lengthOfMonth());
        
        StringBuilder report = new StringBuilder();
        
        // Report Header
        report.append("=".repeat(80)).append("\n");
        report.append("MONTHLY CLINIC PERFORMANCE REPORT\n");
        report.append("Report Period: ").append(startDate.format(DateTimeFormatter.ofPattern("MMMM yyyy"))).append("\n");
        report.append("Generated: ").append(LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))).append("\n");
        report.append("=".repeat(80)).append("\n\n");
        
        // Patient Registration Metrics
        generatePatientMetrics(report, startDate, endDate, parameters);
        
        // Appointment Statistics
        generateAppointmentStatistics(report, startDate, endDate, parameters);
        
        // Department Performance
        if (getBooleanParameter(parameters, "includeDepartmentBreakdown", true)) {
            generateDepartmentPerformance(report, startDate, endDate);
        }
        
        // Revenue Analysis
        if (getBooleanParameter(parameters, "includeRevenue", true)) {
            generateRevenueAnalysis(report, startDate, endDate);
        }
        
        // Trends and Comparisons
        if (getBooleanParameter(parameters, "includeTrends", false)) {
            generateTrendAnalysis(report, startDate, endDate);
        }
        
        report.append("\n").append("=".repeat(80)).append("\n");
        report.append("End of Monthly Clinic Performance Report\n");
        report.append("=".repeat(80));
        
        return report.toString();
    }
    
    private void generatePatientMetrics(StringBuilder report, LocalDate startDate, LocalDate endDate, Map<String, Object> parameters) {
        report.append("PATIENT REGISTRATION METRICS\n");
        report.append("-".repeat(40)).append("\n");
        
        // Total new patients
        String totalQuery = "SELECT COUNT(*) FROM patients WHERE DATE(created_at) BETWEEN ? AND ?";
        Integer totalPatients = jdbcTemplate.queryForObject(totalQuery, Integer.class, startDate, endDate);
        
        // Daily average
        int daysInMonth = endDate.getDayOfMonth();
        double dailyAverage = totalPatients != null ? (double) totalPatients / daysInMonth : 0;
        
        // Previous month comparison
        LocalDate prevStartDate = startDate.minusMonths(1);
        LocalDate prevEndDate = prevStartDate.withDayOfMonth(prevStartDate.lengthOfMonth());
        Integer prevMonthPatients = jdbcTemplate.queryForObject(totalQuery, Integer.class, prevStartDate, prevEndDate);
        
        report.append(String.format("Total New Patients: %d\n", totalPatients != null ? totalPatients : 0));
        report.append(String.format("Daily Average: %.1f patients/day\n", dailyAverage));
        report.append(String.format("Previous Month: %d patients\n", prevMonthPatients != null ? prevMonthPatients : 0));
        
        if (prevMonthPatients != null && prevMonthPatients > 0) {
            double growthRate = ((double) (totalPatients - prevMonthPatients) / prevMonthPatients) * 100;
            report.append(String.format("Growth Rate: %.1f%%\n", growthRate));
        }
        
        report.append("\n");
    }
    
    private void generateAppointmentStatistics(StringBuilder report, LocalDate startDate, LocalDate endDate, Map<String, Object> parameters) {
        report.append("APPOINTMENT STATISTICS\n");
        report.append("-".repeat(40)).append("\n");
        
        // Total appointments
        String totalAppQuery = "SELECT COUNT(*) FROM appointments WHERE DATE(appointment_date) BETWEEN ? AND ?";
        Integer totalAppointments = jdbcTemplate.queryForObject(totalAppQuery, Integer.class, startDate, endDate);
        
        // Completed appointments
        String completedQuery = totalAppQuery + " AND status = 'COMPLETED'";
        Integer completedAppointments = jdbcTemplate.queryForObject(completedQuery, Integer.class, startDate, endDate);
        
        // Cancelled appointments
        String cancelledQuery = totalAppQuery + " AND status = 'CANCELLED'";
        Integer cancelledAppointments = jdbcTemplate.queryForObject(cancelledQuery, Integer.class, startDate, endDate);
        
        report.append(String.format("Total Appointments: %d\n", totalAppointments != null ? totalAppointments : 0));
        report.append(String.format("Completed: %d\n", completedAppointments != null ? completedAppointments : 0));
        report.append(String.format("Cancelled: %d\n", cancelledAppointments != null ? cancelledAppointments : 0));
        
        if (totalAppointments != null && totalAppointments > 0) {
            double completionRate = ((double) completedAppointments / totalAppointments) * 100;
            double cancellationRate = ((double) cancelledAppointments / totalAppointments) * 100;
            report.append(String.format("Completion Rate: %.1f%%\n", completionRate));
            report.append(String.format("Cancellation Rate: %.1f%%\n", cancellationRate));
        }
        
        report.append("\n");
    }
    
    private void generateDepartmentPerformance(StringBuilder report, LocalDate startDate, LocalDate endDate) {
        report.append("DEPARTMENT PERFORMANCE\n");
        report.append("-".repeat(40)).append("\n");
        
        String deptQuery = """
            SELECT d.name as department_name, COUNT(p.id) as patient_count
            FROM departments d
            LEFT JOIN patients p ON d.id = p.department_id 
                AND DATE(p.created_at) BETWEEN ? AND ?
            GROUP BY d.id, d.name
            ORDER BY patient_count DESC
            """;
        
        try {
            List<Map<String, Object>> deptStats = jdbcTemplate.queryForList(deptQuery, startDate, endDate);
            
            for (Map<String, Object> dept : deptStats) {
                String deptName = (String) dept.get("department_name");
                Number patientCount = (Number) dept.get("patient_count");
                report.append(String.format("%-25s: %d patients\n", deptName, patientCount.intValue()));
            }
        } catch (Exception e) {
            report.append("Department data not available\n");
            log.warn("Could not retrieve department performance data", e);
        }
        
        report.append("\n");
    }
    
    private void generateRevenueAnalysis(StringBuilder report, LocalDate startDate, LocalDate endDate) {
        report.append("REVENUE ANALYSIS\n");
        report.append("-".repeat(40)).append("\n");
        
        // This is a placeholder - implement based on your billing/payment system
        report.append("Revenue analysis feature coming soon...\n");
        report.append("Integration with billing system required.\n\n");
    }
    
    private void generateTrendAnalysis(StringBuilder report, LocalDate startDate, LocalDate endDate) {
        report.append("TREND ANALYSIS\n");
        report.append("-".repeat(40)).append("\n");
        
        // Weekly breakdown
        String weeklyQuery = """
            SELECT 
                WEEK(created_at) as week_num,
                COUNT(*) as patient_count
            FROM patients 
            WHERE DATE(created_at) BETWEEN ? AND ?
            GROUP BY WEEK(created_at)
            ORDER BY week_num
            """;
        
        try {
            List<Map<String, Object>> weeklyStats = jdbcTemplate.queryForList(weeklyQuery, startDate, endDate);
            
            report.append("Weekly Patient Registration Trend:\n");
            for (Map<String, Object> week : weeklyStats) {
                Number weekNum = (Number) week.get("week_num");
                Number patientCount = (Number) week.get("patient_count");
                report.append(String.format("Week %d: %d patients\n", weekNum.intValue(), patientCount.intValue()));
            }
        } catch (Exception e) {
            report.append("Trend analysis data not available\n");
            log.warn("Could not retrieve trend analysis data", e);
        }
        
        report.append("\n");
    }
    
    private LocalDate getReportDate(Map<String, Object> parameters) {
        Object dateParam = parameters.get("reportDate");
        if (dateParam instanceof String) {
            try {
                return LocalDate.parse((String) dateParam);
            } catch (Exception e) {
                log.warn("Invalid date parameter: {}, using current date", dateParam);
            }
        }
        return LocalDate.now().minusMonths(1); // Default to last month
    }
    
    private boolean getBooleanParameter(Map<String, Object> parameters, String key, boolean defaultValue) {
        Object value = parameters.get(key);
        if (value instanceof Boolean) {
            return (Boolean) value;
        } else if (value instanceof String) {
            return Boolean.parseBoolean((String) value);
        }
        return defaultValue;
    }
    
    @Override
    public String getReportName() {
        return "Monthly Clinic Performance Report";
    }
    
    @Override
    public String getReportDescription() {
        return "Comprehensive monthly performance report including patient metrics, appointment statistics, department performance, and revenue analysis";
    }
    
    @Override
    public String[] getSupportedFormats() {
        return new String[]{"PDF", "CSV", "EXCEL"};
    }
    
    @Override
    public boolean supportsScheduling() {
        return true;
    }
    
    @Override
    public boolean validateParameters(Map<String, Object> parameters) {
        // Basic validation - can be extended based on requirements
        if (parameters == null) {
            return true; // Allow null parameters, use defaults
        }
        
        // Validate date format if provided
        Object dateParam = parameters.get("reportDate");
        if (dateParam instanceof String) {
            try {
                LocalDate.parse((String) dateParam);
            } catch (Exception e) {
                log.warn("Invalid date format in parameters: {}", dateParam);
                return false;
            }
        }
        
        return true;
    }
    
    @Override
    public Map<String, Object> getDefaultParameters() {
        return Map.of(
            "reportDate", LocalDate.now().minusMonths(1).toString(),
            "includeDepartmentBreakdown", true,
            "includeRevenue", true,
            "includeTrends", false
        );
    }
}
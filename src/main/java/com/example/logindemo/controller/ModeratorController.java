package com.example.logindemo.controller;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ClinicRevenueDTO;
import com.example.logindemo.service.ModeratorService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.MotivationQuoteService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.model.MotivationQuote;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import com.example.logindemo.dto.ClinicSummaryDashboardDTO;
import com.example.logindemo.model.Patient;
import com.example.logindemo.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.UserRepository;
import java.time.format.TextStyle;
import java.util.Locale;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("/moderator")
@PreAuthorize("hasRole('MODERATOR')")
@Slf4j
public class ModeratorController {

    @Autowired
    private ModeratorService moderatorService;

    @Autowired
    private UserService userService;

    @Autowired
    private MotivationQuoteService motivationQuoteService;

    @Autowired
    private ToothClinicalExaminationService toothClinicalExaminationService;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;
    @Autowired
    private ClinicRepository clinicRepository;
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/dashboard")
    public String showModeratorDashboard(Model model) {
        try {
            // Get current moderator
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            // Get accessible clinics
            List<ClinicModel> accessibleClinics = moderatorService.getAccessibleClinics(moderator);
            
            // Get summary statistics for business insights
            List<ToothClinicalExamination> allExaminations = moderatorService.getAllExaminationsAcrossClinics(moderator);
            List<ToothClinicalExamination> pendingPayments = moderatorService.getPendingPaymentsAcrossClinics(moderator);
            List<PatientDTO> allPatients = moderatorService.getAllPatientsAcrossClinics(moderator);

            // Calculate total doctors (isActive=true, role=DOCTOR)
            int totalDoctors = accessibleClinics.stream()
                .flatMap(clinic -> clinic.getDoctors() != null ? clinic.getDoctors().stream() : java.util.stream.Stream.empty())
                .filter(user -> user.getIsActive() != null && user.getIsActive())
                .filter(user -> user.getRole() == UserRole.DOCTOR)
                .map(User::getId) // prevent duplicates if any doctor is in multiple clinics
                .distinct()
                .toArray().length;

            // Fetch a random active motivation quote
            MotivationQuote motivationQuote = motivationQuoteService.getRandomQuote().orElse(null);
            if (motivationQuote != null) {
                log.info("Fetched random motivation quote: {} — {}", motivationQuote.getQuoteText(), motivationQuote.getAuthor());
            } else {
                log.warn("No active motivation quote found, using fallback.");
            }
            model.addAttribute("motivationQuote", motivationQuote);

            model.addAttribute("moderator", moderator);
            model.addAttribute("accessibleClinics", accessibleClinics);
            model.addAttribute("totalClinics", accessibleClinics.size());
            model.addAttribute("totalExaminations", allExaminations.size());
            model.addAttribute("totalPendingPayments", pendingPayments.size());
            model.addAttribute("totalPatients", allPatients.size());
            model.addAttribute("totalDoctors", totalDoctors);

            return "moderator/dashboard";
        } catch (Exception e) {
            log.error("Error loading moderator dashboard", e);
            model.addAttribute("error", "Error loading dashboard: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/clinics")
    public String showClinicRevenueInsights(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String month,
            @RequestParam(required = false) String clinicId,
            Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            java.time.LocalDateTime start = null;
            java.time.LocalDateTime end = null;
            if (month != null && !month.isEmpty()) {
                java.time.YearMonth ym = java.time.YearMonth.parse(month);
                start = ym.atDay(1).atStartOfDay();
                end = ym.atEndOfMonth().atTime(java.time.LocalTime.MAX);
            } else {
                if (startDate != null && !startDate.isEmpty()) {
                    start = java.time.LocalDate.parse(startDate).atStartOfDay();
                } else {
                    start = java.time.LocalDate.of(1970, 1, 1).atStartOfDay();
                }
                if (endDate != null && !endDate.isEmpty()) {
                    end = java.time.LocalDate.parse(endDate).atTime(java.time.LocalTime.MAX);
                } else {
                    end = java.time.LocalDateTime.now();
                }
                if ((startDate == null || startDate.isEmpty()) && (endDate == null || endDate.isEmpty())) {
                    start = null;
                    end = null;
                }
            }
            java.util.List<ClinicRevenueDTO> clinicRevenueList = java.util.Collections.emptyList();
            if (start != null && end != null) {
                clinicRevenueList = moderatorService.getClinicRevenueForPeriod(moderator, start, end, clinicId);
            }
            // Fetch all clinics for dropdown
            java.util.List<com.example.logindemo.model.ClinicModel> allClinics = moderatorService.getAccessibleClinics(moderator);
            model.addAttribute("clinicRevenueList", clinicRevenueList);
            model.addAttribute("allClinics", allClinics);
            model.addAttribute("selectedClinicId", clinicId);
            model.addAttribute("moderator", moderator);
            return "moderator/clinics";
        } catch (Exception e) {
            log.error("Error loading clinic revenue insights", e);
            model.addAttribute("error", "Error loading clinic revenue insights: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/patients")
    public String showPatientAnalytics(Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            List<PatientDTO> patients = moderatorService.getAllPatientsAcrossClinics(moderator);
            model.addAttribute("patients", patients);
            model.addAttribute("moderator", moderator);

            return "moderator/patients";
        } catch (Exception e) {
            log.error("Error loading patient analytics", e);
            model.addAttribute("error", "Error loading patient analytics: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/payments")
    public String showFinancialInsights(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            List<ToothClinicalExamination> payments;
            
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                LocalDateTime start = LocalDate.parse(startDate).atStartOfDay();
                LocalDateTime end = LocalDate.parse(endDate).atTime(LocalTime.MAX);
                payments = moderatorService.getExaminationsByDateRangeAcrossClinics(moderator, start, end);
            } else {
                payments = moderatorService.getPendingPaymentsAcrossClinics(moderator);
            }

            model.addAttribute("payments", payments);
            model.addAttribute("moderator", moderator);
            model.addAttribute("startDate", startDate);
            model.addAttribute("endDate", endDate);

            return "moderator/payments";
        } catch (Exception e) {
            log.error("Error loading financial insights", e);
            model.addAttribute("error", "Error loading financial insights: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/analytics")
    public String showBusinessAnalytics(Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            // Get data for analytics
            List<ClinicModel> clinics = moderatorService.getAccessibleClinics(moderator);
            List<ToothClinicalExamination> allExaminations = moderatorService.getAllExaminationsAcrossClinics(moderator);
            List<PatientDTO> allPatients = moderatorService.getAllPatientsAcrossClinics(moderator);

            model.addAttribute("moderator", moderator);
            model.addAttribute("clinics", clinics);
            model.addAttribute("examinations", allExaminations);
            model.addAttribute("patients", allPatients);

            return "moderator/analytics";
        } catch (Exception e) {
            log.error("Error loading business analytics", e);
            model.addAttribute("error", "Error loading business analytics: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/doctors-performance")
    public String showDoctorsPerformance(
            @RequestParam(value = "clinicId", required = false) String clinicId,
            @RequestParam(value = "month", required = false) String month,
            @RequestParam(value = "year", required = false) String year,
            Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            // Get all accessible clinics
            List<ClinicModel> clinics = moderatorService.getAccessibleClinics(moderator);
            model.addAttribute("clinics", clinics);
            model.addAttribute("selectedClinicId", clinicId);
            model.addAttribute("selectedMonth", month);
            model.addAttribute("selectedYear", year);

            String validationError = null;
            List<User> doctors = List.of();
            List<Map<String, Object>> doctorStats = List.of();
            ClinicModel selectedClinic = null;
            boolean showStats = false;
            if (clinicId != null && !clinicId.isEmpty() && year != null && !year.isEmpty()) {
                showStats = true;
                ClinicModel clinicForStats = clinics.stream()
                    .filter(c -> clinicId.equals(c.getClinicId()))
                    .findFirst().orElse(null);
                selectedClinic = clinicForStats;
                if (clinicForStats != null && clinicForStats.getDoctors() != null) {
                    doctors = clinicForStats.getDoctors().stream()
                        .filter(user -> user.getIsActive() != null && user.getIsActive())
                        .filter(user -> user.getRole() == UserRole.DOCTOR)
                        .toList();
                    int selectedYearInt = Integer.parseInt(year);
                    Integer selectedMonthInt = (month != null && !month.isEmpty()) ? Integer.parseInt(month) : null;
                    final ClinicModel finalClinic = clinicForStats;
                    // Build a map of patientId -> their earliest examination (across all clinics)
                    List<ToothClinicalExamination> allExams = moderatorService.getAllExaminationsAcrossClinics(moderator);
                    Map<Long, ToothClinicalExamination> patientFirstExamMap = new java.util.HashMap<>();
                    for (ToothClinicalExamination exam : allExams) {
                        if (exam.getPatient() != null) {
                            Long pid = exam.getPatient().getId();
                            ToothClinicalExamination existing = patientFirstExamMap.get(pid);
                            if (existing == null || (exam.getExaminationDate() != null && existing.getExaminationDate() != null && exam.getExaminationDate().isBefore(existing.getExaminationDate()))) {
                                patientFirstExamMap.put(pid, exam);
                            }
                        }
                    }
                    doctorStats = doctors.stream().map(doctor -> {
                        Map<String, Object> stats = new java.util.HashMap<>();
                        stats.put("doctor", doctor);
                        List<ToothClinicalExamination> exams = moderatorService.findByDoctorClinicYearMonth(
                                doctor, finalClinic, selectedYearInt, selectedMonthInt);
                        double revenue = exams.stream()
                                .flatMap(exam -> exam.getPaymentEntries() != null ? exam.getPaymentEntries().stream() : java.util.stream.Stream.empty())
                                .mapToDouble(entry -> entry.getAmount() != null ? entry.getAmount() : 0.0)
                                .sum();
                        stats.put("revenue", String.format("\u20B9 %.2f", revenue));
                        // Calculate unique patients
                        long uniquePatients = exams.stream()
                            .filter(exam -> exam.getPatient() != null)
                            .map(exam -> exam.getPatient().getId())
                            .distinct()
                            .count();
                        stats.put("uniquePatients", uniquePatients);
                        // Calculate total (non-unique) patients
                        long totalPatients = exams.stream()
                            .filter(exam -> exam.getPatient() != null)
                            .count();
                        stats.put("totalPatients", totalPatients);
                        // Count procedures (examinations with non-null procedure)
                        long procedureCount = exams.stream()
                            .filter(exam -> exam.getProcedure() != null)
                            .count();
                        stats.put("procedures", procedureCount);
                        // Count new patients: those whose first exam is with this doctor in this period
                        java.time.LocalDateTime periodStart = (selectedMonthInt != null)
                            ? java.time.LocalDateTime.of(selectedYearInt, selectedMonthInt, 1, 0, 0)
                            : java.time.LocalDateTime.of(selectedYearInt, 1, 1, 0, 0);
                        java.time.LocalDateTime periodEnd = (selectedMonthInt != null)
                            ? periodStart.withDayOfMonth(periodStart.toLocalDate().lengthOfMonth()).withHour(23).withMinute(59).withSecond(59)
                            : java.time.LocalDateTime.of(selectedYearInt, 12, 31, 23, 59, 59);
                        long newPatients = exams.stream()
                            .filter(exam -> exam.getPatient() != null)
                            .map(exam -> exam.getPatient().getId())
                            .distinct()
                            .filter(pid -> {
                                ToothClinicalExamination firstExam = patientFirstExamMap.get(pid);
                                return firstExam != null
                                    && firstExam.getAssignedDoctor() != null
                                    && firstExam.getAssignedDoctor().getId().equals(doctor.getId())
                                    && firstExam.getExaminationDate() != null
                                    && !firstExam.getExaminationDate().isBefore(periodStart)
                                    && !firstExam.getExaminationDate().isAfter(periodEnd);
                            })
                            .count();
                        stats.put("newPatients", newPatients);
                        return stats;
                    }).toList();
                }
            } else if ((clinicId != null && !clinicId.isEmpty()) || (month != null && !month.isEmpty()) || (year != null && !year.isEmpty())) {
                if (clinicId == null || clinicId.isEmpty() || year == null || year.isEmpty()) {
                    validationError = "Please select a clinic and year to view performance.";
                }
            }
            model.addAttribute("doctorStats", doctorStats);
            model.addAttribute("selectedClinic", selectedClinic);
            model.addAttribute("validationError", validationError);
            model.addAttribute("showStats", showStats);
            return "moderator/doctors-performance";
        } catch (Exception e) {
            log.error("Error loading doctors performance dashboard", e);
            model.addAttribute("error", "Error loading doctors performance: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/pending-payments")
    public String showPendingPaymentsDashboard(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String clinicId,
            Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            java.time.LocalDateTime start = null;
            java.time.LocalDateTime end = null;
            if (startDate != null && !startDate.isEmpty()) {
                start = java.time.LocalDate.parse(startDate).atStartOfDay();
            }
            if (endDate != null && !endDate.isEmpty()) {
                end = java.time.LocalDate.parse(endDate).atTime(java.time.LocalTime.MAX);
            }
            if (start == null && end == null) {
                start = null;
                end = null;
            }
            java.util.List<com.example.logindemo.dto.PendingPaymentClinicDTO> pendingPayments =
                moderatorService.getPendingPaymentsByClinic(start, end, clinicId);
            java.util.List<com.example.logindemo.model.ClinicModel> allClinics = moderatorService.getAccessibleClinics(moderator);
            model.addAttribute("pendingPayments", pendingPayments);
            model.addAttribute("allClinics", allClinics);
            model.addAttribute("selectedClinicId", clinicId);
            model.addAttribute("moderator", moderator);
            return "moderator/pending-payments";
        } catch (Exception e) {
            log.error("Error loading pending payments dashboard", e);
            model.addAttribute("error", "Error loading pending payments dashboard: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/department-revenue")
    public String showDepartmentRevenueDashboard(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String clinicId,
            @RequestParam(required = false) String department,
            Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            java.time.LocalDateTime start = null;
            java.time.LocalDateTime end = null;
            if (startDate != null && !startDate.isEmpty()) {
                start = java.time.LocalDate.parse(startDate).atStartOfDay();
            }
            if (endDate != null && !endDate.isEmpty()) {
                end = java.time.LocalDate.parse(endDate).atTime(java.time.LocalTime.MAX);
            }
            if (start == null && end == null) {
                start = null;
                end = null;
            }
            java.util.List<com.example.logindemo.dto.DepartmentRevenueDTO> departmentRevenue =
                moderatorService.getDepartmentRevenueMetrics(start, end, clinicId, department);
            // Summary metrics for dashboard cards
            double totalRevenue = departmentRevenue.stream().mapToDouble(d -> d.getRevenue() != null ? d.getRevenue() : 0.0).sum();
            int totalPatients = departmentRevenue.stream().mapToInt(d -> d.getPatientCount()).sum();
            int totalProcedures = departmentRevenue.stream().mapToInt(d -> d.getProcedureCount()).sum();
            int totalDoctors = departmentRevenue.stream().mapToInt(d -> d.getDoctorCount()).sum();
            double totalPending = departmentRevenue.stream().mapToDouble(d -> d.getPendingRevenue() != null ? d.getPendingRevenue() : 0.0).sum();
            String topDepartment = departmentRevenue.stream().max(java.util.Comparator.comparingDouble(d -> d.getRevenue() != null ? d.getRevenue() : 0.0)).map(d -> d.getDepartmentName()).orElse("-");
            java.util.List<com.example.logindemo.model.ClinicModel> allClinics = moderatorService.getAccessibleClinics(moderator);
            model.addAttribute("departmentRevenue", departmentRevenue);
            model.addAttribute("allClinics", allClinics);
            model.addAttribute("selectedClinicId", clinicId);
            model.addAttribute("selectedDepartment", department);
            model.addAttribute("moderator", moderator);
            model.addAttribute("totalRevenue", totalRevenue);
            model.addAttribute("totalPatients", totalPatients);
            model.addAttribute("totalProcedures", totalProcedures);
            model.addAttribute("totalDoctors", totalDoctors);
            model.addAttribute("totalPending", totalPending);
            model.addAttribute("topDepartment", topDepartment);
            return "moderator/department-revenue";
        } catch (Exception e) {
            log.error("Error loading department revenue dashboard", e);
            model.addAttribute("error", "Error loading department revenue dashboard: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/clinics-dashboard")
    public String showClinicsSummaryDashboard(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            java.time.LocalDateTime start = null;
            java.time.LocalDateTime end = null;
            if (startDate != null && !startDate.isEmpty()) {
                start = java.time.LocalDate.parse(startDate).atStartOfDay();
            }
            if (endDate != null && !endDate.isEmpty()) {
                end = java.time.LocalDate.parse(endDate).atTime(java.time.LocalTime.MAX);
            }
            if (start == null && end == null) {
                start = null;
                end = null;
            }
            java.util.List<com.example.logindemo.dto.ClinicSummaryDashboardDTO> clinicsSummary =
                moderatorService.getClinicsSummaryDashboard(start, end);
            double totalRevenue = clinicsSummary.stream().mapToDouble(c -> c.getRevenue() != null ? c.getRevenue() : 0.0).sum();
            int totalPatients = clinicsSummary.stream().mapToInt(c -> c.getPatientCount()).sum();
            int totalCheckins = clinicsSummary.stream().mapToInt(c -> c.getTotalCheckins()).sum();
            double avgTurnaround = clinicsSummary.stream()
                .filter(c -> c.getAverageTurnaroundMinutes() != null && c.getAverageTurnaroundMinutes() > 0)
                .mapToDouble(c -> c.getAverageTurnaroundMinutes()).average().orElse(0.0);
            model.addAttribute("clinicsSummary", clinicsSummary);
            model.addAttribute("totalRevenue", totalRevenue);
            model.addAttribute("totalPatients", totalPatients);
            model.addAttribute("totalCheckins", totalCheckins);
            model.addAttribute("averageTurnaroundMinutes", avgTurnaround > 0 ? avgTurnaround : null);
            model.addAttribute("moderator", moderator);
            return "moderator/clinics-dashboard";
        } catch (Exception e) {
            log.error("Error loading clinics summary dashboard", e);
            model.addAttribute("error", "Error loading clinics summary dashboard: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/customer-insights")
    public String showCustomerInsights(Model model) {
        List<Patient> patients = patientRepository.findAll();
        LocalDate now = LocalDate.now();
        // Total Patients
        int totalPatients = patients.size();
        // New Patients This Month
        int newPatientsThisMonth = (int) patients.stream().filter(p -> {
            if (p.getRegistrationDate() == null) return false;
            LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            return reg.getYear() == now.getYear() && reg.getMonthValue() == now.getMonthValue();
        }).count();
        // Returning Patients This Month (registered before this month, but have check-ins/exams this month)
        int returningPatientsThisMonth = (int) patients.stream().filter(p -> {
            if (p.getRegistrationDate() == null) return false;
            LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            if (reg.getYear() == now.getYear() && reg.getMonthValue() == now.getMonthValue()) return false;
            // Check for check-ins or exams this month
            boolean checkin = p.getPatientCheckIns() != null && p.getPatientCheckIns().stream().anyMatch(ci -> {
                if (ci.getCheckInTime() == null) return false;
                LocalDate ciDate = ci.getCheckInTime().toLocalDate();
                return ciDate.getYear() == now.getYear() && ciDate.getMonthValue() == now.getMonthValue();
            });
            boolean exam = p.getToothClinicalExaminations() != null && p.getToothClinicalExaminations().stream().anyMatch(e -> {
                if (e.getExaminationDate() == null) return false;
                LocalDate exDate = e.getExaminationDate().toLocalDate();
                return exDate.getYear() == now.getYear() && exDate.getMonthValue() == now.getMonthValue();
            });
            return checkin || exam;
        }).count();
        // Age Distribution
        Map<String, Long> ageDistribution = patients.stream().collect(Collectors.groupingBy(p -> {
            int age = p.getAge();
            if (age < 18) return "<18";
            else if (age < 31) return "18-30";
            else if (age < 46) return "31-45";
            else if (age < 61) return "46-60";
            else return "60+";
        }, Collectors.counting()));
        // Gender Distribution
        Map<String, Long> genderDistribution = patients.stream().collect(Collectors.groupingBy(Patient::getGender, Collectors.counting()));
        // Top 5 Cities
        Map<String, Long> cityCounts = patients.stream().filter(p -> p.getCity() != null && !p.getCity().isEmpty()).collect(Collectors.groupingBy(Patient::getCity, Collectors.counting()));
        List<Map.Entry<String, Long>> topCities = cityCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // Top 5 States
        Map<String, Long> stateCounts = patients.stream().filter(p -> p.getState() != null && !p.getState().isEmpty()).collect(Collectors.groupingBy(Patient::getState, Collectors.counting()));
        List<Map.Entry<String, Long>> topStates = stateCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // Registrations Over Time (by month)
        Map<String, Long> registrationsOverTime = patients.stream().filter(p -> p.getRegistrationDate() != null).collect(Collectors.groupingBy(p -> {
            LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            return reg.getYear() + "-" + String.format("%02d", reg.getMonthValue());
        }, Collectors.counting()));
        // Occupation Distribution
        Map<String, Long> occupationDistribution = patients.stream().filter(p -> p.getOccupation() != null).collect(Collectors.groupingBy(p -> p.getOccupation().name(), Collectors.counting()));
        // Referral Source Distribution
        Map<String, Long> referralSourceDistribution = patients.stream().filter(p -> p.getReferralModel() != null).collect(Collectors.groupingBy(p -> p.getReferralModel().name(), Collectors.counting()));
        // % with Emergency Contact
        long withEmergencyContact = patients.stream().filter(p -> p.getEmergencyContactName() != null && !p.getEmergencyContactName().isEmpty() && p.getEmergencyContactPhoneNumber() != null && !p.getEmergencyContactPhoneNumber().isEmpty()).count();
        double percentWithEmergencyContact = totalPatients > 0 ? (withEmergencyContact * 100.0 / totalPatients) : 0.0;
        // % with Complete Contact Info (phone + email)
        long withCompleteContact = patients.stream().filter(p -> p.getPhoneNumber() != null && !p.getPhoneNumber().isEmpty() && p.getEmail() != null && !p.getEmail().isEmpty()).count();
        double percentWithCompleteContactInfo = totalPatients > 0 ? (withCompleteContact * 100.0 / totalPatients) : 0.0;
        // Registration Trends Stats
        String peakMonth = "-";
        long peakValue = 0;
        String lowestMonth = "-";
        long lowestValue = Long.MAX_VALUE;
        String currentMonthKey = now.getYear() + "-" + String.format("%02d", now.getMonthValue());
        long currentMonthValue = registrationsOverTime.getOrDefault(currentMonthKey, 0L);
        String prevMonthKey = now.minusMonths(1).getYear() + "-" + String.format("%02d", now.minusMonths(1).getMonthValue());
        long prevMonthValue = registrationsOverTime.getOrDefault(prevMonthKey, 0L);
        for (Map.Entry<String, Long> entry : registrationsOverTime.entrySet()) {
            if (entry.getValue() > peakValue) {
                peakValue = entry.getValue();
                peakMonth = entry.getKey();
            }
            if (entry.getValue() < lowestValue) {
                lowestValue = entry.getValue();
                lowestMonth = entry.getKey();
            }
        }
        if (lowestValue == Long.MAX_VALUE) lowestValue = 0;
        double percentChange = prevMonthValue > 0 ? ((currentMonthValue - prevMonthValue) * 100.0 / prevMonthValue) : 0.0;
        // 1. Average Age of Patients Registered in Last 12 Months
        LocalDate twelveMonthsAgo = now.minusMonths(12);
        List<Patient> last12MonthsPatients = patients.stream().filter(p -> {
            if (p.getRegistrationDate() == null) return false;
            LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            return !reg.isBefore(twelveMonthsAgo);
        }).toList();
        double averageAgeLast12Months = last12MonthsPatients.stream().mapToInt(Patient::getAge).average().orElse(0.0);
        // 2. Gender Distribution (already present as genderDistribution)
        // 3. Most Common Occupation
        String mostCommonOccupation = "-";
        if (!occupationDistribution.isEmpty()) {
            mostCommonOccupation = occupationDistribution.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey).orElse("-");
        }
        // 5. Average Time Between Registration and First Check-in
        double avgTimeToFirstCheckin = patients.stream()
            .filter(p -> p.getRegistrationDate() != null && p.getPatientCheckIns() != null && !p.getPatientCheckIns().isEmpty())
            .mapToLong(p -> {
                LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                LocalDate firstCheckin = p.getPatientCheckIns().stream()
                    .filter(ci -> ci.getCheckInTime() != null)
                    .map(ci -> ci.getCheckInTime().toLocalDate())
                    .min(LocalDate::compareTo)
                    .orElse(reg);
                return java.time.Duration.between(reg.atStartOfDay(), firstCheckin.atStartOfDay()).toDays();
            })
            .average().orElse(0.0);
        // 7. Patient Growth Rate vs Previous Year
        int currentYear = now.getYear();
        int prevYear = currentYear - 1;
        long currentYearCount = patients.stream().filter(p -> {
            if (p.getRegistrationDate() == null) return false;
            LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            return reg.getYear() == currentYear;
        }).count();
        long prevYearCount = patients.stream().filter(p -> {
            if (p.getRegistrationDate() == null) return false;
            LocalDate reg = p.getRegistrationDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            return reg.getYear() == prevYear;
        }).count();
        double patientGrowthRate = prevYearCount > 0 ? ((currentYearCount - prevYearCount) * 100.0 / prevYearCount) : 0.0;
        // 8. Clinics with Highest Patient Registration
        Map<String, Long> clinicCounts = patients.stream().filter(p -> p.getRegisteredClinic() != null && p.getRegisteredClinic().getClinicName() != null)
            .collect(Collectors.groupingBy(p -> p.getRegisteredClinic().getClinicName(), Collectors.counting()));
        List<Map.Entry<String, Long>> topClinics = clinicCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // 9. Users (Staff) Who Registered Most Patients
        Map<String, Long> staffCounts = patients.stream().filter(p -> p.getCreatedBy() != null && p.getCreatedBy().getFirstName() != null)
            .collect(Collectors.groupingBy(p -> p.getCreatedBy().getFirstName() + (p.getCreatedBy().getLastName() != null ? (" " + p.getCreatedBy().getLastName()) : ""), Collectors.counting()));
        List<Map.Entry<String, Long>> topStaff = staffCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // 10. Patients Checked In More Than Once
        long patientsCheckedInMoreThanOnce = patients.stream().filter(p -> p.getPatientCheckIns() != null && p.getPatientCheckIns().size() > 1).count();
        // 11. Average Number of Check-ins per Patient
        double avgCheckinsPerPatient = patients.stream().mapToInt(p -> p.getPatientCheckIns() != null ? p.getPatientCheckIns().size() : 0).average().orElse(0.0);
        // 12. Patients Currently Checked In
        long patientsCurrentlyCheckedIn = patients.stream().filter(p -> Boolean.TRUE.equals(p.getCheckedIn())).count();
        // 13. Top 10 Recently Checked-in Patients
        List<Patient> top10RecentCheckins = patients.stream()
            .filter(p -> p.getCurrentCheckInRecord() != null && p.getCurrentCheckInRecord().getCheckInTime() != null)
            .sorted((a, b) -> b.getCurrentCheckInRecord().getCheckInTime().compareTo(a.getCurrentCheckInRecord().getCheckInTime()))
            .limit(10)
            .toList();
        // 16. Patients with Emergency Contact Info
        long patientsWithEmergencyContact = patients.stream().filter(p -> p.getEmergencyContactName() != null && !p.getEmergencyContactName().isEmpty() && p.getEmergencyContactPhoneNumber() != null && !p.getEmergencyContactPhoneNumber().isEmpty()).count();
        double percentWithEmergencyContact2 = totalPatients > 0 ? (patientsWithEmergencyContact * 100.0 / totalPatients) : 0.0;
        // 17. Patients Provided Email vs Missing
        long patientsWithEmail = patients.stream().filter(p -> p.getEmail() != null && !p.getEmail().isEmpty()).count();
        double percentWithEmail = totalPatients > 0 ? (patientsWithEmail * 100.0 / totalPatients) : 0.0;
        // 18. Patients with Profile Picture
        long patientsWithProfilePicture = patients.stream().filter(p -> p.getProfilePicturePath() != null && !p.getProfilePicturePath().isEmpty()).count();
        double percentWithProfilePicture = totalPatients > 0 ? (patientsWithProfilePicture * 100.0 / totalPatients) : 0.0;
        model.addAttribute("totalPatients", totalPatients);
        model.addAttribute("newPatientsThisMonth", newPatientsThisMonth);
        model.addAttribute("returningPatientsThisMonth", returningPatientsThisMonth);
        model.addAttribute("ageDistribution", ageDistribution);
        model.addAttribute("genderDistribution", genderDistribution);
        model.addAttribute("topCities", topCities);
        model.addAttribute("topStates", topStates);
        model.addAttribute("registrationsOverTime", registrationsOverTime);
        model.addAttribute("occupationDistribution", occupationDistribution);
        model.addAttribute("referralSourceDistribution", referralSourceDistribution);
        model.addAttribute("percentWithEmergencyContact", percentWithEmergencyContact);
        model.addAttribute("percentWithCompleteContactInfo", percentWithCompleteContactInfo);
        model.addAttribute("peakMonth", peakMonth);
        model.addAttribute("peakValue", peakValue);
        model.addAttribute("lowestMonth", lowestMonth);
        model.addAttribute("lowestValue", lowestValue);
        model.addAttribute("currentMonthValue", currentMonthValue);
        model.addAttribute("percentChange", percentChange);
        model.addAttribute("averageAgeLast12Months", averageAgeLast12Months);
        model.addAttribute("mostCommonOccupation", mostCommonOccupation);
        model.addAttribute("avgTimeToFirstCheckin", avgTimeToFirstCheckin);
        model.addAttribute("patientGrowthRate", patientGrowthRate);
        model.addAttribute("topClinics", topClinics);
        model.addAttribute("topStaff", topStaff);
        model.addAttribute("patientsCheckedInMoreThanOnce", patientsCheckedInMoreThanOnce);
        model.addAttribute("avgCheckinsPerPatient", avgCheckinsPerPatient);
        model.addAttribute("patientsCurrentlyCheckedIn", patientsCurrentlyCheckedIn);
        model.addAttribute("top10RecentCheckins", top10RecentCheckins);
        model.addAttribute("patientsWithEmergencyContact", patientsWithEmergencyContact);
        model.addAttribute("percentWithEmergencyContact2", percentWithEmergencyContact2);
        model.addAttribute("patientsWithEmail", patientsWithEmail);
        model.addAttribute("percentWithEmail", percentWithEmail);
        model.addAttribute("patientsWithProfilePicture", patientsWithProfilePicture);
        model.addAttribute("percentWithProfilePicture", percentWithProfilePicture);
        return "moderator/customer-insights";
    }

    @GetMapping("/tooth-exam-insights")
    public String showToothExamInsights(Model model) {
        // 1. Examinations per clinic per month
        List<ToothClinicalExamination> exams = toothClinicalExaminationRepository.findAll();
        Map<String, Map<String, Long>> examsPerClinicPerMonth = new java.util.HashMap<>();
        for (ToothClinicalExamination exam : exams) {
            String clinic = (exam.getExaminationClinic() != null && exam.getExaminationClinic().getClinicName() != null) ? exam.getExaminationClinic().getClinicName() : "Unknown";
            String month = (exam.getExaminationDate() != null) ? exam.getExaminationDate().getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + exam.getExaminationDate().getYear() : "Unknown";
            examsPerClinicPerMonth.computeIfAbsent(clinic, k -> new java.util.HashMap<>());
            Map<String, Long> monthMap = examsPerClinicPerMonth.get(clinic);
            monthMap.put(month, monthMap.getOrDefault(month, 0L) + 1);
        }
        // Serialize to JSON for JS
        String examsPerClinicPerMonthJson = "{}";
        try {
            ObjectMapper mapper = new ObjectMapper();
            examsPerClinicPerMonthJson = mapper.writeValueAsString(examsPerClinicPerMonth);
        } catch (Exception e) { /* ignore for now */ }
        // 2. Top 5 most commonly advised procedures
        Map<String, Long> procedureCounts = exams.stream()
            .filter(e -> e.getProcedure() != null && e.getProcedure().getProcedureName() != null)
            .collect(Collectors.groupingBy(e -> e.getProcedure().getProcedureName(), Collectors.counting()));
        List<Map.Entry<String, Long>> topProcedures = procedureCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // 3. Doctors who perform the most procedures
        Map<String, Long> doctorCounts = exams.stream()
            .filter(e -> e.getAssignedDoctor() != null && e.getAssignedDoctor().getFirstName() != null)
            .collect(Collectors.groupingBy(e -> e.getAssignedDoctor().getFirstName() + (e.getAssignedDoctor().getLastName() != null ? (" " + e.getAssignedDoctor().getLastName()) : ""), Collectors.counting()));
        List<Map.Entry<String, Long>> topDoctors = doctorCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // 4. Average procedure duration (in minutes)
        double avgProcedureDuration = exams.stream()
            .filter(e -> e.getProcedureStartTime() != null && e.getProcedureEndTime() != null)
            .mapToLong(e -> java.time.Duration.between(e.getProcedureStartTime(), e.getProcedureEndTime()).toMinutes())
            .average().orElse(0.0);
        // 5. Most frequently recorded tooth conditions
        Map<String, Long> toothConditionCounts = exams.stream()
            .filter(e -> e.getToothCondition() != null)
            .collect(Collectors.groupingBy(e -> e.getToothCondition().toString(), Collectors.counting()));
        List<Map.Entry<String, Long>> mostCommonToothConditions = toothConditionCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(5).collect(Collectors.toList());
        // 6. Tooth numbers examined most often
        Map<String, Long> toothNumberCounts = exams.stream()
            .filter(e -> e.getToothNumber() != null)
            .collect(Collectors.groupingBy(e -> e.getToothNumber().toString(), Collectors.counting()));
        List<Map.Entry<String, Long>> mostExaminedToothNumbers = toothNumberCounts.entrySet().stream().sorted(Map.Entry.<String, Long>comparingByValue().reversed()).limit(10).collect(Collectors.toList());
        // 7. Bleeding on probing and plaque presence
        long bleedingOnProbingCount = exams.stream().filter(e -> e.getBleedingOnProbing() != null && !"NONE".equals(e.getBleedingOnProbing().toString())).count();
        long plaquePresenceCount = exams.stream().filter(e -> e.getPlaqueScore() != null && !"LOW".equals(e.getPlaqueScore().toString())).count();
        // 8. Average pocket depth and recession by age group
        Map<String, List<Double>> pocketDepthByAgeGroup = new java.util.HashMap<>();
        Map<String, List<Double>> recessionByAgeGroup = new java.util.HashMap<>();
        for (ToothClinicalExamination exam : exams) {
            if (exam.getPatient() != null && exam.getPatient().getDateOfBirth() != null) {
                int age = exam.getPatient().getAge();
                String ageGroup = age < 18 ? "<18" : age < 31 ? "18-30" : age < 46 ? "31-45" : age < 61 ? "46-60" : "60+";
                if (exam.getPocketDepth() != null) {
                    pocketDepthByAgeGroup.computeIfAbsent(ageGroup, k -> new java.util.ArrayList<>()).add((double) exam.getPocketDepth().ordinal());
                }
                if (exam.getGingivalRecession() != null) {
                    recessionByAgeGroup.computeIfAbsent(ageGroup, k -> new java.util.ArrayList<>()).add((double) exam.getGingivalRecession().ordinal());
                }
            }
        }
        Map<String, Double> avgPocketDepthByAgeGroup = new java.util.HashMap<>();
        for (String group : pocketDepthByAgeGroup.keySet()) {
            List<Double> vals = pocketDepthByAgeGroup.get(group);
            avgPocketDepthByAgeGroup.put(group, vals.stream().mapToDouble(Double::doubleValue).average().orElse(0.0));
        }
        Map<String, Double> avgRecessionByAgeGroup = new java.util.HashMap<>();
        for (String group : recessionByAgeGroup.keySet()) {
            List<Double> vals = recessionByAgeGroup.get(group);
            avgRecessionByAgeGroup.put(group, vals.stream().mapToDouble(Double::doubleValue).average().orElse(0.0));
        }
        // Convert Map.Entry lists to List<Map<String, Object>> for JSON serialization
        List<Map<String, Object>> toothConditionList = mostCommonToothConditions.stream()
            .map(e -> {
                Map<String, Object> m = new HashMap<>();
                m.put("key", e.getKey());
                m.put("value", e.getValue());
                return m;
            })
            .collect(Collectors.toList());
        List<Map<String, Object>> toothNumberList = mostExaminedToothNumbers.stream()
            .map(e -> {
                Map<String, Object> m = new HashMap<>();
                m.put("key", e.getKey());
                m.put("value", e.getValue());
                return m;
            })
            .collect(Collectors.toList());
        // Serialize tooth-level chart data to JSON for JSP
        String mostCommonToothConditionsJson = "[]";
        String mostExaminedToothNumbersJson = "[]";
        String avgPocketDepthByAgeGroupJson = "{}";
        String avgRecessionByAgeGroupJson = "{}";
        try {
            ObjectMapper mapper = new ObjectMapper();
            mostCommonToothConditionsJson = mapper.writeValueAsString(toothConditionList);
            mostExaminedToothNumbersJson = mapper.writeValueAsString(toothNumberList);
            avgPocketDepthByAgeGroupJson = mapper.writeValueAsString(avgPocketDepthByAgeGroup);
            avgRecessionByAgeGroupJson = mapper.writeValueAsString(avgRecessionByAgeGroup);
        } catch (Exception e) { /* ignore for now */ }
        model.addAttribute("examsPerClinicPerMonth", examsPerClinicPerMonth);
        model.addAttribute("examsPerClinicPerMonthJson", examsPerClinicPerMonthJson);
        model.addAttribute("topProcedures", topProcedures);
        model.addAttribute("topDoctors", topDoctors);
        model.addAttribute("avgProcedureDuration", avgProcedureDuration);
        model.addAttribute("mostCommonToothConditions", mostCommonToothConditions);
        model.addAttribute("mostExaminedToothNumbers", mostExaminedToothNumbers);
        model.addAttribute("bleedingOnProbingCount", bleedingOnProbingCount);
        model.addAttribute("plaquePresenceCount", plaquePresenceCount);
        model.addAttribute("avgPocketDepthByAgeGroup", avgPocketDepthByAgeGroup);
        model.addAttribute("avgRecessionByAgeGroup", avgRecessionByAgeGroup);
        model.addAttribute("mostCommonToothConditionsJson", mostCommonToothConditionsJson);
        model.addAttribute("mostExaminedToothNumbersJson", mostExaminedToothNumbersJson);
        model.addAttribute("avgPocketDepthByAgeGroupJson", avgPocketDepthByAgeGroupJson);
        model.addAttribute("avgRecessionByAgeGroupJson", avgRecessionByAgeGroupJson);
        return "moderator/tooth-exam-insights";
    }

    // API endpoints for business insights
    @GetMapping("/api/clinics")
    @ResponseBody
    public Map<String, Object> getClinicsApi() {
        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            List<ClinicModel> clinics = moderatorService.getAccessibleClinics(moderator);
            
            response.put("success", true);
            response.put("clinics", clinics);
            response.put("count", clinics.size());
        } catch (Exception e) {
            log.error("Error in clinics API", e);
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @GetMapping("/api/payments")
    @ResponseBody
    public Map<String, Object> getPaymentsApi(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            List<ToothClinicalExamination> payments;
            
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                LocalDateTime start = LocalDate.parse(startDate).atStartOfDay();
                LocalDateTime end = LocalDate.parse(endDate).atTime(LocalTime.MAX);
                payments = moderatorService.getExaminationsByDateRangeAcrossClinics(moderator, start, end);
            } else {
                payments = moderatorService.getPendingPaymentsAcrossClinics(moderator);
            }
            
            response.put("success", true);
            response.put("payments", payments);
            response.put("count", payments.size());
        } catch (Exception e) {
            log.error("Error in payments API", e);
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @GetMapping("/api/analytics")
    @ResponseBody
    public Map<String, Object> getAnalyticsApi() {
        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User moderator = userService.getUserByUsername(auth.getName())
                .map(userDTO -> modelMapper.map(userDTO, User.class))
                .orElseThrow(() -> new RuntimeException("Moderator not found"));

            // Get comprehensive analytics data
            List<ClinicModel> clinics = moderatorService.getAccessibleClinics(moderator);
            List<ToothClinicalExamination> examinations = moderatorService.getAllExaminationsAcrossClinics(moderator);
            List<PatientDTO> patients = moderatorService.getAllPatientsAcrossClinics(moderator);
            List<ToothClinicalExamination> pendingPayments = moderatorService.getPendingPaymentsAcrossClinics(moderator);
            
            response.put("success", true);
            response.put("analytics", Map.of(
                "totalClinics", clinics.size(),
                "totalExaminations", examinations.size(),
                "totalPatients", patients.size(),
                "pendingPayments", pendingPayments.size()
            ));
        } catch (Exception e) {
            log.error("Error in analytics API", e);
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }
} 
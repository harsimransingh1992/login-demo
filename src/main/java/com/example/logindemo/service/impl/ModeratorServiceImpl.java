package com.example.logindemo.service.impl;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ClinicRevenueDTO;
import com.example.logindemo.dto.PendingPaymentClinicDTO;
import com.example.logindemo.dto.DepartmentRevenueDTO;
import com.example.logindemo.dto.ClinicSummaryDashboardDTO;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.PaymentEntryRepository;
import com.example.logindemo.repository.AppointmentRepository;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.service.ModeratorService;
import com.example.logindemo.service.PatientService;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Set;
import java.util.HashSet;
import com.example.logindemo.model.Patient;
import java.sql.Timestamp;
import com.example.logindemo.model.AppointmentStatus;

@Service
@Slf4j
public class ModeratorServiceImpl implements ModeratorService {

    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Autowired
    private PatientService patientService;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private PaymentEntryRepository paymentEntryRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private CheckInRecordRepository checkInRecordRepository;

    @Override
    public List<ClinicModel> getAccessibleClinics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to clinics", moderator.getUsername());
            return List.of();
        }
        
        // Moderators can access all clinics for business insights
        List<ClinicModel> allClinics = clinicRepository.findAll();
        log.info("Moderator {} accessed {} clinics for business insights", moderator.getUsername(), allClinics.size());
        return allClinics;
    }

    @Override
    public boolean canAccessClinic(User moderator, ClinicModel clinic) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to clinic {}", moderator.getUsername(), clinic.getClinicId());
            return false;
        }
        
        // Moderators can access any clinic for business insights
        log.debug("Moderator {} can access clinic {} for business insights", moderator.getUsername(), clinic.getClinicId());
        return true;
    }

    @Override
    public List<PatientDTO> getAllPatientsAcrossClinics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to patients", moderator.getUsername());
            return List.of();
        }
        
        // Get all patients from all clinics for business analytics
        List<PatientDTO> allPatients = patientRepository.findAll().stream()
            .map(patient -> modelMapper.map(patient, PatientDTO.class))
            .collect(Collectors.toList());
        
        log.info("Moderator {} accessed {} patients across all clinics for business analytics", moderator.getUsername(), allPatients.size());
        return allPatients;
    }

    @Override
    public List<ToothClinicalExamination> getAllExaminationsAcrossClinics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to examinations", moderator.getUsername());
            return List.of();
        }
        
        // Get all examinations from all clinics for performance analysis
        List<ToothClinicalExamination> allExaminations = examinationRepository.findAll();
        
        log.info("Moderator {} accessed {} examinations across all clinics for performance analysis", moderator.getUsername(), allExaminations.size());
        return allExaminations;
    }

    @Override
    public List<ToothClinicalExamination> getExaminationsByDateRangeAcrossClinics(User moderator, LocalDateTime startDate, LocalDateTime endDate) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to examinations", moderator.getUsername());
            return List.of();
        }
        
        // Get examinations within date range from all clinics for trend analysis
        List<ToothClinicalExamination> examinations = examinationRepository.findByExaminationDateBetween(startDate, endDate);
        
        log.info("Moderator {} accessed {} examinations between {} and {} across all clinics for trend analysis", 
            moderator.getUsername(), examinations.size(), startDate, endDate);
        return examinations;
    }

    @Override
    public List<ToothClinicalExamination> getPendingPaymentsAcrossClinics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to pending payments", moderator.getUsername());
            return List.of();
        }
        
        // Get all examinations and filter for pending payments for financial insights
        List<ToothClinicalExamination> allExaminations = examinationRepository.findAll();
        List<ToothClinicalExamination> pendingPayments = allExaminations.stream()
            .filter(exam -> exam.getTotalProcedureAmount() != null &&
                           (exam.getTotalPaidAmount() == null || exam.getTotalProcedureAmount() > exam.getTotalPaidAmount()))
            .collect(Collectors.toList());
        
        log.info("Moderator {} accessed {} pending payments across all clinics for financial insights", moderator.getUsername(), pendingPayments.size());
        return pendingPayments;
    }

    @Override
    public Map<String, Object> getBusinessAnalytics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to business analytics", moderator.getUsername());
            return Map.of();
        }
        
        Map<String, Object> analytics = new HashMap<>();
        
        // Get basic metrics
        List<ClinicModel> clinics = clinicRepository.findAll();
        List<ToothClinicalExamination> examinations = examinationRepository.findAll();
        List<PatientDTO> patients = getAllPatientsAcrossClinics(moderator);
        List<ToothClinicalExamination> pendingPayments = getPendingPaymentsAcrossClinics(moderator);
        
        // Calculate business metrics
        double totalRevenue = examinations.stream()
            .mapToDouble(exam -> exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0)
            .sum();
        
        double pendingRevenue = pendingPayments.stream()
            .mapToDouble(exam -> {
                double totalAmount = exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0;
                double paidAmount = exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0;
                return totalAmount - paidAmount;
            })
            .sum();
        
        // Calculate average patients per clinic
        double avgPatientsPerClinic = clinics.isEmpty() ? 0 : (double) patients.size() / clinics.size();
        
        // Calculate average procedures per patient
        double avgProceduresPerPatient = patients.isEmpty() ? 0 : (double) examinations.size() / patients.size();
        
        analytics.put("totalClinics", clinics.size());
        analytics.put("totalPatients", patients.size());
        analytics.put("totalExaminations", examinations.size());
        analytics.put("pendingPayments", pendingPayments.size());
        analytics.put("totalRevenue", totalRevenue);
        analytics.put("pendingRevenue", pendingRevenue);
        analytics.put("avgPatientsPerClinic", avgPatientsPerClinic);
        analytics.put("avgProceduresPerPatient", avgProceduresPerPatient);
        
        log.info("Moderator {} accessed business analytics with {} clinics, {} patients, {} examinations", 
            moderator.getUsername(), clinics.size(), patients.size(), examinations.size());
        
        return analytics;
    }

    @Override
    public Map<String, Object> getClinicPerformanceMetrics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to clinic performance metrics", moderator.getUsername());
            return Map.of();
        }
        
        Map<String, Object> performanceMetrics = new HashMap<>();
        List<ClinicModel> clinics = clinicRepository.findAll();
        List<ToothClinicalExamination> allExaminations = examinationRepository.findAll();
        
        // Calculate clinic-specific metrics
        Map<String, Object> clinicMetrics = new HashMap<>();
        for (ClinicModel clinic : clinics) {
            Map<String, Object> metrics = new HashMap<>();
            
            // Count examinations for this clinic
            long clinicExaminations = allExaminations.stream()
                .filter(exam -> exam.getExaminationClinic() != null && 
                               exam.getExaminationClinic().getId().equals(clinic.getId()))
                .count();
            
            // Calculate revenue for this clinic
            double clinicRevenue = allExaminations.stream()
                .filter(exam -> exam.getExaminationClinic() != null && 
                               exam.getExaminationClinic().getId().equals(clinic.getId()))
                .mapToDouble(exam -> exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0)
                .sum();
            
            metrics.put("examinations", clinicExaminations);
            metrics.put("revenue", clinicRevenue);
            clinicMetrics.put(clinic.getClinicId(), metrics);
        }
        
        performanceMetrics.put("clinicMetrics", clinicMetrics);
        performanceMetrics.put("totalClinics", clinics.size());
        
        log.info("Moderator {} accessed clinic performance metrics for {} clinics", moderator.getUsername(), clinics.size());
        
        return performanceMetrics;
    }

    @Override
    public Map<String, Object> getPatientAnalytics(User moderator) {
        // Verify the user is actually a moderator
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to patient analytics", moderator.getUsername());
            return Map.of();
        }
        
        Map<String, Object> patientAnalytics = new HashMap<>();
        List<PatientDTO> patients = getAllPatientsAcrossClinics(moderator);
        List<ToothClinicalExamination> examinations = getAllExaminationsAcrossClinics(moderator);
        
        // Calculate patient demographics and trends
        long totalPatients = patients.size();
        long totalExaminations = examinations.size();
        
        // Calculate average age (if available)
        double avgAge = patients.stream()
            .filter(p -> p.getAge() != null)
            .mapToDouble(p -> p.getAge())
            .average()
            .orElse(0.0);
        
        // Calculate gender distribution
        long malePatients = patients.stream()
            .filter(p -> "Male".equalsIgnoreCase(p.getGender()))
            .count();
        long femalePatients = patients.stream()
            .filter(p -> "Female".equalsIgnoreCase(p.getGender()))
            .count();
        
        patientAnalytics.put("totalPatients", totalPatients);
        patientAnalytics.put("totalExaminations", totalExaminations);
        patientAnalytics.put("avgAge", avgAge);
        patientAnalytics.put("malePatients", malePatients);
        patientAnalytics.put("femalePatients", femalePatients);
        patientAnalytics.put("avgExaminationsPerPatient", totalPatients > 0 ? (double) totalExaminations / totalPatients : 0.0);
        
        log.info("Moderator {} accessed patient analytics for {} patients with {} examinations", 
            moderator.getUsername(), totalPatients, totalExaminations);
        
        return patientAnalytics;
    }

    @Override
    public List<ClinicRevenueDTO> getClinicRevenueForPeriod(User moderator, java.time.LocalDateTime start, java.time.LocalDateTime end, String clinicId) {
        if (moderator.getRole() != UserRole.MODERATOR) {
            log.warn("User {} is not a moderator, denying access to revenue insights", moderator.getUsername());
            return List.of();
        }
        // Fetch all clinics
        List<ClinicModel> allClinics = clinicRepository.findAll();
        // If filtering by clinicId, filter the list
        if (clinicId != null && !clinicId.isEmpty()) {
            allClinics = allClinics.stream()
                .filter(c -> clinicId.equals(c.getClinicId()))
                .collect(java.util.stream.Collectors.toList());
        }
        // Fetch all payments in the date range
        List<com.example.logindemo.model.PaymentEntry> payments = paymentEntryRepository.findByPaymentDateBetween(start, end);
        // Group payments by clinicId and sum revenue
        java.util.Map<String, Double> revenueByClinicId = new java.util.HashMap<>();
        for (var payment : payments) {
            if (payment.getExamination() != null && payment.getExamination().getExaminationClinic() != null) {
                String cId = payment.getExamination().getExaminationClinic().getClinicId();
                revenueByClinicId.put(cId, revenueByClinicId.getOrDefault(cId, 0.0) + (payment.getAmount() != null ? payment.getAmount() : 0.0));
            }
        }
        // Build DTOs for all clinics
        java.util.List<ClinicRevenueDTO> result = new java.util.ArrayList<>();
        // Calculate the number of days in the selected period (inclusive)
        java.time.LocalDate startDate = start.toLocalDate();
        java.time.LocalDate endDate = end.toLocalDate();
        long daysInPeriod = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
        for (ClinicModel clinic : allClinics) {
            double collectedRevenue = revenueByClinicId.getOrDefault(clinic.getClinicId(), 0.0);
            int doctorCount = (clinic.getDoctors() != null) ? 
                (int) clinic.getDoctors().stream()
                    .filter(doctor -> doctor.getRole() == UserRole.DOCTOR)
                    .count() : 0;
            // Calculate to-be-collected revenue: sum totalProcedureAmount for unique examinations with payments in this clinic
            Set<Long> seenExamIds = new HashSet<>();
            double toBeCollectedRevenue = payments.stream()
                .map(payment -> payment.getExamination())
                .filter(exam -> exam != null && exam.getExaminationClinic() != null && exam.getExaminationClinic().getClinicId().equals(clinic.getClinicId()))
                .filter(exam -> seenExamIds.add(exam.getId())) // only unique examinations
                .mapToDouble(exam -> exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0)
                .sum();
            // Calculate pending revenue
            double pendingRevenue = toBeCollectedRevenue - collectedRevenue;
            // Calculate YTD projected revenue
            double ytdProjectedRevenue = (daysInPeriod > 0) ? (toBeCollectedRevenue / daysInPeriod) * 365.0 : 0.0;
            ClinicRevenueDTO dto = new ClinicRevenueDTO(clinic.getClinicName(), clinic.getClinicId(), clinic.getCityTier(), collectedRevenue, doctorCount);
            dto.setToBeCollectedRevenue(toBeCollectedRevenue);
            dto.setPendingRevenue(pendingRevenue);
            dto.setYtdProjectedRevenue(ytdProjectedRevenue);
            result.add(dto);
        }
        return result;
    }

    @Override
    public List<ToothClinicalExamination> findByDoctorClinicYearMonth(User doctor, ClinicModel clinic, int year, Integer month) {
        LocalDateTime start = (month != null)
            ? LocalDateTime.of(year, month, 1, 0, 0)
            : LocalDateTime.of(year, 1, 1, 0, 0);
        LocalDateTime end = (month != null)
            ? start.withDayOfMonth(start.toLocalDate().lengthOfMonth()).withHour(23).withMinute(59).withSecond(59)
            : LocalDateTime.of(year, 12, 31, 23, 59, 59);

        return examinationRepository.findAll().stream()
            .filter(exam -> exam.getAssignedDoctor() != null && exam.getAssignedDoctor().getId().equals(doctor.getId()))
            .filter(exam -> exam.getExaminationClinic() != null && exam.getExaminationClinic().getClinicId().equals(clinic.getClinicId()))
            .filter(exam -> exam.getExaminationDate() != null &&
                !exam.getExaminationDate().isBefore(start) &&
                !exam.getExaminationDate().isAfter(end))
            .collect(Collectors.toList());
    }

    // New method: Get pending payments grouped by clinic
    public List<PendingPaymentClinicDTO> getPendingPaymentsByClinic(java.time.LocalDateTime start, java.time.LocalDateTime end, String clinicId) {
        List<ClinicModel> clinics = clinicRepository.findAll();
        if (clinicId != null && !clinicId.isEmpty()) {
            clinics = clinics.stream().filter(c -> clinicId.equals(c.getClinicId())).toList();
        }
        // Use paymentDate for filtering
        List<com.example.logindemo.model.PaymentEntry> paymentsInRange = (start != null && end != null)
            ? paymentEntryRepository.findByPaymentDateBetween(start, end)
            : paymentEntryRepository.findAll();
        // Collect unique examinations with at least one payment in the period
        java.util.Set<Long> examIdsWithPayment = new java.util.HashSet<>();
        java.util.Map<Long, ToothClinicalExamination> examMap = new java.util.HashMap<>();
        for (com.example.logindemo.model.PaymentEntry payment : paymentsInRange) {
            ToothClinicalExamination exam = payment.getExamination();
            if (exam != null) {
                examIdsWithPayment.add(exam.getId());
                examMap.put(exam.getId(), exam);
            }
        }
        List<PendingPaymentClinicDTO> result = new java.util.ArrayList<>();
        for (ClinicModel clinic : clinics) {
            // Only consider exams with at least one payment in the period and belonging to this clinic
            java.util.List<ToothClinicalExamination> examsForClinic = examIdsWithPayment.stream()
                .map(examMap::get)
                .filter(exam -> exam != null && exam.getExaminationClinic() != null && exam.getExaminationClinic().getClinicId().equals(clinic.getClinicId()))
                .toList();
            // Pending = totalProcedureAmount - totalPaidAmount (all time)
            java.util.List<ToothClinicalExamination> pendingExams = examsForClinic.stream()
                .filter(exam -> exam.getTotalProcedureAmount() != null &&
                        (exam.getTotalPaidAmount() == null || exam.getTotalProcedureAmount() > exam.getTotalPaidAmount()))
                .toList();
            double totalPending = pendingExams.stream()
                .mapToDouble(exam -> {
                    double total = exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0;
                    double paid = exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0;
                    return total - paid;
                })
                .sum();
            result.add(new PendingPaymentClinicDTO(
                clinic.getClinicName(),
                clinic.getClinicId(),
                clinic.getCityTier(),
                totalPending,
                pendingExams.size()
            ));
        }
        return result;
    }

    // New method: Get department-wise revenue metrics
    public java.util.List<DepartmentRevenueDTO> getDepartmentRevenueMetrics(java.time.LocalDateTime start, java.time.LocalDateTime end, String clinicId, String department) {
        // Use paymentDate for filtering
        java.util.List<com.example.logindemo.model.PaymentEntry> paymentsInRange = (start != null && end != null)
            ? paymentEntryRepository.findByPaymentDateBetween(start, end)
            : paymentEntryRepository.findAll();
        // Collect unique examinations with at least one payment in the period
        java.util.Map<Long, ToothClinicalExamination> examMap = new java.util.HashMap<>();
        for (com.example.logindemo.model.PaymentEntry payment : paymentsInRange) {
            ToothClinicalExamination exam = payment.getExamination();
            if (exam != null) {
                examMap.put(exam.getId(), exam);
            }
        }
        // Filter by clinic and department if provided
        java.util.List<ToothClinicalExamination> filteredExams = examMap.values().stream()
            .filter(exam -> exam.getAssignedDoctor() != null)
            .filter(exam -> clinicId == null || clinicId.isEmpty() || (exam.getExaminationClinic() != null && clinicId.equals(exam.getExaminationClinic().getClinicId())))
            .filter(exam -> department == null || department.isEmpty() || (exam.getAssignedDoctor().getSpecialization() != null && department.equalsIgnoreCase(exam.getAssignedDoctor().getSpecialization())))
            .toList();
        // Group by department
        java.util.Map<String, java.util.List<ToothClinicalExamination>> byDept = filteredExams.stream()
            .collect(java.util.stream.Collectors.groupingBy(exam -> {
                String spec = exam.getAssignedDoctor().getSpecialization();
                return spec != null && !spec.isEmpty() ? spec : "(Unspecified)";
            }));
        java.util.List<DepartmentRevenueDTO> result = new java.util.ArrayList<>();
        for (var entry : byDept.entrySet()) {
            String deptName = entry.getKey();
            java.util.List<ToothClinicalExamination> exams = entry.getValue();
            // Revenue: sum of all payments in the period for these exams
            double revenue = paymentsInRange.stream()
                .filter(p -> p.getExamination() != null && exams.contains(p.getExamination()))
                .mapToDouble(p -> p.getAmount() != null ? p.getAmount() : 0.0)
                .sum();
            // Patient count: unique patients
            int patientCount = (int) exams.stream()
                .filter(exam -> exam.getPatient() != null)
                .map(exam -> exam.getPatient().getId())
                .distinct()
                .count();
            // Procedure count: exams with non-null procedure
            int procedureCount = (int) exams.stream()
                .filter(exam -> exam.getProcedure() != null)
                .count();
            // Doctor count: unique doctors in this department
            int doctorCount = (int) exams.stream()
                .map(exam -> exam.getAssignedDoctor().getId())
                .distinct()
                .count();
            // Pending revenue: sum of (totalProcedureAmount - totalPaidAmount) for exams with pending
            double pendingRevenue = exams.stream()
                .filter(exam -> exam.getTotalProcedureAmount() != null && (exam.getTotalPaidAmount() == null || exam.getTotalProcedureAmount() > exam.getTotalPaidAmount()))
                .mapToDouble(exam -> {
                    double total = exam.getTotalProcedureAmount() != null ? exam.getTotalProcedureAmount() : 0.0;
                    double paid = exam.getTotalPaidAmount() != null ? exam.getTotalPaidAmount() : 0.0;
                    return total - paid;
                })
                .sum();
            result.add(new DepartmentRevenueDTO(deptName, revenue, patientCount, procedureCount, doctorCount, pendingRevenue));
        }
        return result;
    }

    // New method: Get clinics summary dashboard (revenue, patients)
    public java.util.List<ClinicSummaryDashboardDTO> getClinicsSummaryDashboard(java.time.LocalDateTime start, java.time.LocalDateTime end) {
        java.util.List<ClinicModel> clinics = clinicRepository.findAll();
        java.util.List<com.example.logindemo.model.PaymentEntry> paymentsInRange = (start != null && end != null)
            ? paymentEntryRepository.findByPaymentDateBetween(start, end)
            : paymentEntryRepository.findAll();
        java.util.Map<Long, java.util.Set<Long>> clinicToPatientIds = new java.util.HashMap<>();
        java.util.Map<Long, Double> clinicToRevenue = new java.util.HashMap<>();
        for (com.example.logindemo.model.PaymentEntry payment : paymentsInRange) {
            ToothClinicalExamination exam = payment.getExamination();
            if (exam != null && exam.getExaminationClinic() != null && exam.getPatient() != null) {
                Long clinicId = exam.getExaminationClinic().getId();
                clinicToPatientIds.computeIfAbsent(clinicId, k -> new java.util.HashSet<>()).add(exam.getPatient().getId());
                clinicToRevenue.put(clinicId, clinicToRevenue.getOrDefault(clinicId, 0.0) + (payment.getAmount() != null ? payment.getAmount() : 0.0));
            }
        }
        java.util.List<Patient> allPatients = patientRepository.findAll();
        java.util.Map<Long, Integer> clinicToRegisteredCount = new java.util.HashMap<>();
        if (start != null && end != null) {
            java.util.Date startDate = java.sql.Timestamp.valueOf(start);
            java.util.Date endDate = java.sql.Timestamp.valueOf(end);
            java.util.List<Object[]> regCounts = patientRepository.countRegisteredByClinicAndDate(startDate, endDate);
            for (Object[] row : regCounts) {
                Long cId = (Long) row[0];
                Integer count = ((Number) row[1]).intValue();
                clinicToRegisteredCount.put(cId, count);
            }
        }
        // --- New: Appointment status counts ---
        java.util.List<com.example.logindemo.model.Appointment> allAppointments = appointmentRepository.findAll();
        java.util.Map<Long, Integer> clinicToTotalAppointments = new java.util.HashMap<>();
        java.util.Map<Long, Integer> clinicToNoShow = new java.util.HashMap<>();
        java.util.Map<Long, Integer> clinicToCancelled = new java.util.HashMap<>();
        for (com.example.logindemo.model.Appointment appt : allAppointments) {
            if (appt.getClinic() != null) {
                Long cId = appt.getClinic().getId();
                // Filter by date if needed
                boolean inRange = true;
                if (start != null && end != null && appt.getAppointmentDateTime() != null) {
                    inRange = !appt.getAppointmentDateTime().isBefore(start) && !appt.getAppointmentDateTime().isAfter(end);
                }
                if (inRange) {
                    clinicToTotalAppointments.put(cId, clinicToTotalAppointments.getOrDefault(cId, 0) + 1);
                    if (appt.getStatus() == AppointmentStatus.NO_SHOW) {
                        clinicToNoShow.put(cId, clinicToNoShow.getOrDefault(cId, 0) + 1);
                    }
                    if (appt.getStatus() == AppointmentStatus.CANCELLED) {
                        clinicToCancelled.put(cId, clinicToCancelled.getOrDefault(cId, 0) + 1);
                    }
                }
            }
        }
        // --- End new ---
        java.util.List<ClinicSummaryDashboardDTO> result = new java.util.ArrayList<>();
        for (ClinicModel clinic : clinics) {
            Long cId = clinic.getId();
            double revenue = clinicToRevenue.getOrDefault(cId, 0.0);
            int patientCount = clinicToPatientIds.getOrDefault(cId, java.util.Collections.emptySet()).size();
            int patientRegisteredCount;
            if (start != null && end != null) {
                patientRegisteredCount = clinicToRegisteredCount.getOrDefault(cId, 0);
            } else {
                // fallback: count all patients registered at this clinic
                patientRegisteredCount = (int) allPatients.stream()
                    .filter(p -> p.getRegisteredClinic() != null && p.getRegisteredClinic().getId().equals(cId))
                    .count();
            }
            int totalAppointments = clinicToTotalAppointments.getOrDefault(cId, 0);
            int noShowCount = clinicToNoShow.getOrDefault(cId, 0);
            int cancelledCount = clinicToCancelled.getOrDefault(cId, 0);
            // --- New: Check-in and turnaround time ---
            java.util.List<com.example.logindemo.model.CheckInRecord> checkIns = (start != null && end != null)
                ? checkInRecordRepository.findByClinic_IdAndCheckInTimeBetween(cId, start, end)
                : checkInRecordRepository.findAll().stream().filter(c -> c.getClinic() != null && c.getClinic().getId().equals(cId)).toList();
            int totalCheckins = checkIns.size();
            double avgTurnaround = checkIns.stream()
                .filter(r -> r.getCheckInTime() != null && r.getCheckOutTime() != null)
                .mapToLong(r -> java.time.Duration.between(r.getCheckInTime(), r.getCheckOutTime()).toMinutes())
                .average().orElse(0.0);
            ClinicSummaryDashboardDTO dto = new ClinicSummaryDashboardDTO(
                clinic.getClinicName(),
                clinic.getClinicId(),
                clinic.getCityTier(),
                revenue,
                patientCount,
                patientRegisteredCount,
                totalAppointments,
                noShowCount,
                cancelledCount,
                totalCheckins,
                avgTurnaround > 0 ? avgTurnaround : null
            );
            result.add(dto);
        }
        return result;
    }
} 
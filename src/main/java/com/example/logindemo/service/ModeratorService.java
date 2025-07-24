package com.example.logindemo.service;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.ClinicRevenueDTO;
import com.example.logindemo.dto.PendingPaymentClinicDTO;
import com.example.logindemo.dto.DepartmentRevenueDTO;
import com.example.logindemo.dto.ClinicSummaryDashboardDTO;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface ModeratorService {
    
    /**
     * Get all clinics that a moderator can access for business insights
     * @param moderator the moderator user
     * @return list of accessible clinics
     */
    List<ClinicModel> getAccessibleClinics(User moderator);
    
    /**
     * Check if a moderator can access a specific clinic for business insights
     * @param moderator the moderator user
     * @param clinic the clinic to check access for
     * @return true if access is allowed, false otherwise
     */
    boolean canAccessClinic(User moderator, ClinicModel clinic);
    
    /**
     * Get all patients across accessible clinics for business analytics
     * @param moderator the moderator user
     * @return list of patients from all accessible clinics
     */
    List<PatientDTO> getAllPatientsAcrossClinics(User moderator);
    
    /**
     * Get all examinations across accessible clinics for performance analysis
     * @param moderator the moderator user
     * @return list of examinations from all accessible clinics
     */
    List<ToothClinicalExamination> getAllExaminationsAcrossClinics(User moderator);
    
    /**
     * Get examinations by date range across accessible clinics for trend analysis
     * @param moderator the moderator user
     * @param startDate start date for filtering
     * @param endDate end date for filtering
     * @return list of examinations within date range from all accessible clinics
     */
    List<ToothClinicalExamination> getExaminationsByDateRangeAcrossClinics(User moderator, LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Get pending payments across accessible clinics for financial insights
     * @param moderator the moderator user
     * @return list of pending payment examinations from all accessible clinics
     */
    List<ToothClinicalExamination> getPendingPaymentsAcrossClinics(User moderator);
    
    /**
     * Get business analytics summary across all accessible clinics
     * @param moderator the moderator user
     * @return map containing business metrics and KPIs
     */
    Map<String, Object> getBusinessAnalytics(User moderator);
    
    /**
     * Get clinic performance metrics for business intelligence
     * @param moderator the moderator user
     * @return map containing clinic-specific performance data
     */
    Map<String, Object> getClinicPerformanceMetrics(User moderator);
    
    /**
     * Get patient analytics and demographics for business insights
     * @param moderator the moderator user
     * @return map containing patient analytics data
     */
    Map<String, Object> getPatientAnalytics(User moderator);
    
    /**
     * Get revenue for each clinic in the given period (date range), optionally filtered by clinicId
     * @param moderator the moderator user
     * @param start start date/time (inclusive)
     * @param end end date/time (inclusive)
     * @param clinicId optional clinicId to filter
     * @return list of clinic revenue DTOs
     */
    List<ClinicRevenueDTO> getClinicRevenueForPeriod(User moderator, java.time.LocalDateTime start, java.time.LocalDateTime end, String clinicId);

    // Backward compatible method
    default List<ClinicRevenueDTO> getClinicRevenueForPeriod(User moderator, java.time.LocalDateTime start, java.time.LocalDateTime end) {
        return getClinicRevenueForPeriod(moderator, start, end, null);
    }

    // Add: Find all examinations for a doctor, clinic, and date range (year, and optional month)
    List<ToothClinicalExamination> findByDoctorClinicYearMonth(User doctor, ClinicModel clinic, int year, Integer month);

    java.util.List<PendingPaymentClinicDTO> getPendingPaymentsByClinic(java.time.LocalDateTime start, java.time.LocalDateTime end, String clinicId);

    java.util.List<DepartmentRevenueDTO> getDepartmentRevenueMetrics(java.time.LocalDateTime start, java.time.LocalDateTime end, String clinicId, String department);

    java.util.List<ClinicSummaryDashboardDTO> getClinicsSummaryDashboard(java.time.LocalDateTime start, java.time.LocalDateTime end);
} 
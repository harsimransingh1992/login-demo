package com.example.logindemo.service.impl;

import com.example.logindemo.dto.DoctorTargetProgressDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.DoctorTargetRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.DoctorTargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;

@Service
public class DoctorTargetServiceImpl implements DoctorTargetService {

    @Autowired
    private DoctorTargetRepository doctorTargetRepository;

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Override
    public DoctorTargetProgressDTO calculateTargetProgress(User doctor, LocalDate from, LocalDate to) {
        DoctorTargetProgressDTO progress = new DoctorTargetProgressDTO();
        
        // Get doctor's clinic tier
        CityTier clinicTier = doctor.getClinic().getCityTier();
        
        // Get target for this tier
        DoctorTarget target = doctorTargetRepository.findByCityTierAndIsActiveTrue(clinicTier)
                .orElse(getDefaultTarget(clinicTier));
        
        // Calculate current month's data
        YearMonth currentMonth = YearMonth.now();
        LocalDate monthStart = currentMonth.atDay(1);
        LocalDate monthEnd = currentMonth.atEndOfMonth();
        
        // Get current month's examinations for this doctor
        List<ToothClinicalExamination> monthExaminations = examinationRepository
                .findByAssignedDoctorAndExaminationDateBetween(doctor, monthStart.atStartOfDay(), monthEnd.atTime(23, 59, 59));
        
        // Calculate current values
        BigDecimal currentRevenue = monthExaminations.stream()
                .map(exam -> exam.getTotalPaidAmount() != null ? BigDecimal.valueOf(exam.getTotalPaidAmount()) : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        int currentPatients = (int) monthExaminations.stream()
                .map(exam -> exam.getPatient().getId())
                .distinct()
                .count();
        
        int currentProcedures = monthExaminations.size();
        
        // Calculate progress percentages
        BigDecimal revenueProgress = target.getMonthlyRevenueTarget().compareTo(BigDecimal.ZERO) > 0 
                ? currentRevenue.multiply(BigDecimal.valueOf(100)).divide(target.getMonthlyRevenueTarget(), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;
        
        BigDecimal patientProgress = target.getMonthlyPatientTarget() > 0 
                ? BigDecimal.valueOf(Math.round(currentPatients * 100.0 / target.getMonthlyPatientTarget()))
                : BigDecimal.ZERO;
        
        BigDecimal procedureProgress = target.getMonthlyProcedureTarget() > 0 
                ? BigDecimal.valueOf(Math.round(currentProcedures * 100.0 / target.getMonthlyProcedureTarget()))
                : BigDecimal.ZERO;
        
        // Calculate remaining amounts
        BigDecimal remainingRevenue = target.getMonthlyRevenueTarget().subtract(currentRevenue).max(BigDecimal.ZERO);
        int remainingPatients = Math.max(0, target.getMonthlyPatientTarget() - currentPatients);
        int remainingProcedures = Math.max(0, target.getMonthlyProcedureTarget() - currentProcedures);
        
        // Calculate days remaining in month
        int daysRemainingInMonth = Math.max(0, monthEnd.getDayOfMonth() - LocalDate.now().getDayOfMonth());
        
        // Calculate daily averages needed
        BigDecimal dailyAverageNeeded = daysRemainingInMonth > 0 
                ? remainingRevenue.divide(BigDecimal.valueOf(daysRemainingInMonth), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;
        
        BigDecimal dailyPatientsNeeded = daysRemainingInMonth > 0 
                ? BigDecimal.valueOf(remainingPatients).divide(BigDecimal.valueOf(daysRemainingInMonth), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;
        
        BigDecimal dailyProceduresNeeded = daysRemainingInMonth > 0 
                ? BigDecimal.valueOf(remainingProcedures).divide(BigDecimal.valueOf(daysRemainingInMonth), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;
        
        // Generate motivational message
        String motivationalMessage = generateMotivationalMessage(revenueProgress, patientProgress, procedureProgress);
        
        // Set all values
        progress.setMonthlyRevenueTarget(target.getMonthlyRevenueTarget());
        progress.setCurrentRevenue(currentRevenue);
        progress.setRevenueProgress(revenueProgress);
        progress.setRemainingRevenue(remainingRevenue);
        progress.setDailyAverageNeeded(dailyAverageNeeded);
        
        progress.setMonthlyPatientTarget(target.getMonthlyPatientTarget());
        progress.setCurrentPatients(currentPatients);
        progress.setPatientProgress(patientProgress);
        progress.setRemainingPatients(remainingPatients);
        progress.setDailyPatientsNeeded(dailyPatientsNeeded);
        
        progress.setMonthlyProcedureTarget(target.getMonthlyProcedureTarget());
        progress.setCurrentProcedures(currentProcedures);
        progress.setProcedureProgress(procedureProgress);
        progress.setRemainingProcedures(remainingProcedures);
        progress.setDailyProceduresNeeded(dailyProceduresNeeded);
        
        progress.setDaysRemainingInMonth(daysRemainingInMonth);
        progress.setMotivationalMessage(motivationalMessage);
        
        return progress;
    }
    
    private DoctorTarget getDefaultTarget(CityTier tier) {
        DoctorTarget defaultTarget = new DoctorTarget();
        defaultTarget.setCityTier(tier);
        
        switch (tier) {
            case TIER1:
                defaultTarget.setMonthlyRevenueTarget(new BigDecimal("500000"));
                defaultTarget.setMonthlyPatientTarget(100);
                defaultTarget.setMonthlyProcedureTarget(150);
                break;
            case TIER2:
                defaultTarget.setMonthlyRevenueTarget(new BigDecimal("300000"));
                defaultTarget.setMonthlyPatientTarget(75);
                defaultTarget.setMonthlyProcedureTarget(100);
                break;
            case TIER3:
                defaultTarget.setMonthlyRevenueTarget(new BigDecimal("200000"));
                defaultTarget.setMonthlyPatientTarget(50);
                defaultTarget.setMonthlyProcedureTarget(75);
                break;
            default:
                defaultTarget.setMonthlyRevenueTarget(new BigDecimal("100000"));
                defaultTarget.setMonthlyPatientTarget(25);
                defaultTarget.setMonthlyProcedureTarget(50);
        }
        
        return defaultTarget;
    }
    
    private String generateMotivationalMessage(BigDecimal revenueProgress, BigDecimal patientProgress, BigDecimal procedureProgress) {
        BigDecimal avgProgress = revenueProgress.add(patientProgress).add(procedureProgress).divide(BigDecimal.valueOf(3), 0, RoundingMode.HALF_UP);
        
        if (avgProgress.compareTo(BigDecimal.valueOf(100)) >= 0) {
            return "Excellent! You've exceeded your monthly targets! 🎉";
        } else if (avgProgress.compareTo(BigDecimal.valueOf(80)) >= 0) {
            return "Great job! You're on track to meet your targets! 👍";
        } else if (avgProgress.compareTo(BigDecimal.valueOf(60)) >= 0) {
            return "Good progress! Keep up the momentum! 💪";
        } else if (avgProgress.compareTo(BigDecimal.valueOf(40)) >= 0) {
            return "You're making progress! Focus on your daily goals! 📈";
        } else {
            return "Let's work together to reach your targets! Every day counts! ��";
        }
    }
    
    // CRUD operations for target management
    @Override
    public List<DoctorTarget> getAllTargets() {
        return doctorTargetRepository.findAll();
    }
    
    @Override
    public DoctorTarget getTargetById(Long id) {
        return doctorTargetRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Target not found with ID: " + id));
    }
    
    @Override
    public DoctorTarget getTargetByCityTier(String cityTier) {
        try {
            CityTier tier = CityTier.valueOf(cityTier);
            return doctorTargetRepository.findByCityTierAndIsActiveTrue(tier)
                    .orElse(getDefaultTarget(tier));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid city tier: " + cityTier);
        }
    }
    
    @Override
    public DoctorTarget createTarget(DoctorTarget target) {
        // Check if a target already exists for this city tier
        Optional<DoctorTarget> existingTarget = doctorTargetRepository.findByCityTierAndIsActiveTrue(target.getCityTier());
        if (existingTarget.isPresent()) {
            throw new RuntimeException("A target already exists for city tier: " + target.getCityTier());
        }
        
        target.setIsActive(true);
        return doctorTargetRepository.save(target);
    }
    
    @Override
    public DoctorTarget updateTarget(Long id, DoctorTarget target) {
        DoctorTarget existingTarget = getTargetById(id);
        
        existingTarget.setCityTier(target.getCityTier());
        existingTarget.setMonthlyRevenueTarget(target.getMonthlyRevenueTarget());
        existingTarget.setMonthlyPatientTarget(target.getMonthlyPatientTarget());
        existingTarget.setMonthlyProcedureTarget(target.getMonthlyProcedureTarget());
        existingTarget.setDescription(target.getDescription());
        existingTarget.setIsActive(target.getIsActive());
        
        return doctorTargetRepository.save(existingTarget);
    }
    
    @Override
    public void deleteTarget(Long id) {
        DoctorTarget target = getTargetById(id);
        doctorTargetRepository.delete(target);
    }
    
    @Override
    public void activateTarget(Long id) {
        DoctorTarget target = getTargetById(id);
        target.setIsActive(true);
        doctorTargetRepository.save(target);
    }
    
    @Override
    public void deactivateTarget(Long id) {
        DoctorTarget target = getTargetById(id);
        target.setIsActive(false);
        doctorTargetRepository.save(target);
    }
} 
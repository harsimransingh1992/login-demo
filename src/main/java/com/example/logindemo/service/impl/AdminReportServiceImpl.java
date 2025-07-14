package com.example.logindemo.service.impl;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.AdminReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminReportServiceImpl implements AdminReportService {

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Override
    public Long getTotalProcedures(LocalDateTime startDate, LocalDateTime endDate) {
        return examinationRepository.countByExaminationDateBetween(startDate, endDate);
    }

    @Override
    public Double getTotalRevenue(LocalDateTime startDate, LocalDateTime endDate) {
        return examinationRepository.findByExaminationDateBetween(startDate, endDate)
                .stream()
                .mapToDouble(exam -> exam.getPaymentEntries() == null ? 0.0 :
                    exam.getPaymentEntries().stream()
                        .filter(e -> e.getAmount() != null)
                        .mapToDouble(PaymentEntry::getAmount)
                        .sum())
                .sum();
    }

    @Override
    public Double getAverageProcedureTime(LocalDateTime startDate, LocalDateTime endDate) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByExaminationDateBetween(startDate, endDate);
        return examinations.stream()
                .filter(exam -> exam.getProcedureStartTime() != null && exam.getProcedureEndTime() != null)
                .mapToDouble(exam -> ChronoUnit.MINUTES.between(exam.getProcedureStartTime(), exam.getProcedureEndTime()))
                .average()
                .orElse(0.0);
    }

    @Override
    public Double getSuccessRate(LocalDateTime startDate, LocalDateTime endDate) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByExaminationDateBetween(startDate, endDate);
        long totalProcedures = examinations.size();
        if (totalProcedures == 0) return 0.0;
        
        long successfulProcedures = examinations.stream()
                .filter(exam -> exam.getPaymentEntries() != null &&
                    exam.getPaymentEntries().stream().anyMatch(e -> e.getAmount() != null && e.getAmount() > 0))
                .count();
        
        return (double) successfulProcedures / totalProcedures * 100;
    }

    @Override
    public Map<String, Long> getProcedureDistribution(LocalDateTime startDate, LocalDateTime endDate) {
        return examinationRepository.findByExaminationDateBetween(startDate, endDate)
                .stream()
                .collect(Collectors.groupingBy(
                        exam -> exam.getProcedure() != null ? exam.getProcedure().getProcedureName() : "Unknown",
                        Collectors.counting()
                ));
    }

    @Override
    public Map<String, Double> getSuccessRatesByCondition(LocalDateTime startDate, LocalDateTime endDate) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByExaminationDateBetween(startDate, endDate);
        Map<String, List<ToothClinicalExamination>> conditionGroups = examinations.stream()
                .collect(Collectors.groupingBy(exam -> exam.getToothCondition() != null ? exam.getToothCondition().toString() : "Unknown"));

        return conditionGroups.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> {
                            List<ToothClinicalExamination> groupExams = entry.getValue();
                            long successful = groupExams.stream()
                                    .filter(exam -> exam.getPaymentEntries() != null &&
                                        exam.getPaymentEntries().stream().anyMatch(e -> e.getAmount() != null && e.getAmount() > 0))
                                    .count();
                            return (double) successful / groupExams.size() * 100;
                        }
                ));
    }

    @Override
    public Map<LocalDateTime, Double> getRevenueTrends(LocalDateTime startDate, LocalDateTime endDate) {
        return examinationRepository.findByExaminationDateBetween(startDate, endDate)
                .stream()
                .collect(Collectors.groupingBy(
                        exam -> exam.getExaminationDate().truncatedTo(ChronoUnit.DAYS),
                        Collectors.summingDouble(exam -> exam.getPaymentEntries() == null ? 0.0 :
                            exam.getPaymentEntries().stream()
                                .filter(e -> e.getAmount() != null)
                                .mapToDouble(PaymentEntry::getAmount)
                                .sum())
                ));
    }

    @Override
    public Map<String, Double> getPaymentModeDistribution(LocalDateTime startDate, LocalDateTime endDate) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByExaminationDateBetween(startDate, endDate);
        double totalAmount = examinations.stream()
                .mapToDouble(exam -> exam.getPaymentEntries() == null ? 0.0 :
                    exam.getPaymentEntries().stream()
                        .filter(e -> e.getAmount() != null)
                        .mapToDouble(PaymentEntry::getAmount)
                        .sum())
                .sum();

        Map<String, Double> modeTotals = examinations.stream()
                .flatMap(exam -> exam.getPaymentEntries() != null ? exam.getPaymentEntries().stream() : java.util.stream.Stream.empty())
                .filter(e -> e.getPaymentMode() != null && e.getAmount() != null)
                .collect(Collectors.groupingBy(
                        e -> e.getPaymentMode().toString(),
                        Collectors.summingDouble(PaymentEntry::getAmount)
                ));

        // Convert to percentage
        return modeTotals.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> totalAmount == 0.0 ? 0.0 : (entry.getValue() / totalAmount) * 100
                ));
    }

    @Override
    public Map<String, Map<String, Object>> getDoctorPerformance(LocalDateTime startDate, LocalDateTime endDate) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByExaminationDateBetween(startDate, endDate);
        
        return examinations.stream()
                .collect(Collectors.groupingBy(
                        exam -> exam.getAssignedDoctor() != null ? exam.getAssignedDoctor().getUsername() : "Unknown",
                        Collectors.collectingAndThen(
                                Collectors.toList(),
                                doctorExams -> {
                                    Map<String, Object> metrics = new HashMap<>();
                                    metrics.put("totalProcedures", (long) doctorExams.size());
                                    metrics.put("successRate", calculateDoctorSuccessRate(doctorExams));
                                    metrics.put("averageTime", calculateDoctorAverageTime(doctorExams));
                                    metrics.put("revenue", calculateDoctorRevenue(doctorExams));
                                    return metrics;
                                }
                        )
                ));
    }

    @Override
    public Map<String, Long> getProcedureStatusDistribution(LocalDateTime startDate, LocalDateTime endDate) {
        return examinationRepository.findByExaminationDateBetween(startDate, endDate)
                .stream()
                .collect(Collectors.groupingBy(
                        exam -> exam.getProcedureStatus() != null ? exam.getProcedureStatus().toString() : "Unknown",
                        Collectors.counting()
                ));
    }

    @Override
    public List<Map<String, Object>> getRecentProcedures(int limit) {
        return examinationRepository.findTop10ByOrderByExaminationDateDesc()
                .stream()
                .map(exam -> {
                    Map<String, Object> procedureData = new HashMap<>();
                    procedureData.put("date", exam.getExaminationDate());
                    procedureData.put("patientName", exam.getPatient() != null ? 
                        exam.getPatient().getFirstName() + " " + exam.getPatient().getLastName() : "Unknown");
                    procedureData.put("procedureName", exam.getProcedure() != null ? exam.getProcedure().getProcedureName() : "Unknown");
                    procedureData.put("doctorName", exam.getAssignedDoctor() != null ? exam.getAssignedDoctor().getUsername() : "Unknown");
                    procedureData.put("status", exam.getProcedureStatus());
                    procedureData.put("amount", exam.getPaymentEntries() == null ? 0.0 :
                        exam.getPaymentEntries().stream()
                            .filter(e -> e.getAmount() != null)
                            .mapToDouble(PaymentEntry::getAmount)
                            .sum());
                    return procedureData;
                })
                .collect(Collectors.toList());
    }

    @Override
    public String exportReport(LocalDateTime startDate, LocalDateTime endDate, String format) {
        // TODO: Implement report export functionality
        // This would generate a report in the specified format (PDF, Excel, etc.)
        return "Report exported successfully";
    }

    private Double calculateDoctorSuccessRate(List<ToothClinicalExamination> examinations) {
        long total = examinations.size();
        if (total == 0) return 0.0;
        
        long successful = examinations.stream()
                .filter(exam -> exam.getPaymentEntries() != null &&
                    exam.getPaymentEntries().stream().anyMatch(e -> e.getAmount() != null && e.getAmount() > 0))
                .count();
        
        return (double) successful / total * 100;
    }

    private Double calculateDoctorAverageTime(List<ToothClinicalExamination> examinations) {
        return examinations.stream()
                .filter(exam -> exam.getProcedureStartTime() != null && exam.getProcedureEndTime() != null)
                .mapToDouble(exam -> ChronoUnit.MINUTES.between(exam.getProcedureStartTime(), exam.getProcedureEndTime()))
                .average()
                .orElse(0.0);
    }

    private Double calculateDoctorRevenue(List<ToothClinicalExamination> examinations) {
        return examinations.stream()
                .mapToDouble(exam -> exam.getPaymentEntries() == null ? 0.0 :
                    exam.getPaymentEntries().stream()
                        .filter(e -> e.getAmount() != null)
                        .mapToDouble(PaymentEntry::getAmount)
                        .sum())
                .sum();
    }
} 
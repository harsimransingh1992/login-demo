package com.example.logindemo.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface AdminReportService {
    Long getTotalProcedures(LocalDateTime startDate, LocalDateTime endDate);
    Double getTotalRevenue(LocalDateTime startDate, LocalDateTime endDate);
    Double getAverageProcedureTime(LocalDateTime startDate, LocalDateTime endDate);
    Double getSuccessRate(LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Long> getProcedureDistribution(LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Double> getSuccessRatesByCondition(LocalDateTime startDate, LocalDateTime endDate);
    Map<LocalDateTime, Double> getRevenueTrends(LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Double> getPaymentModeDistribution(LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Map<String, Object>> getDoctorPerformance(LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Long> getProcedureStatusDistribution(LocalDateTime startDate, LocalDateTime endDate);
    List<Map<String, Object>> getRecentProcedures(int limit);
    String exportReport(LocalDateTime startDate, LocalDateTime endDate, String format);
} 
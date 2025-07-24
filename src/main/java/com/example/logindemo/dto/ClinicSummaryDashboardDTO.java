package com.example.logindemo.dto;

import com.example.logindemo.model.CityTier;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClinicSummaryDashboardDTO {
    private String clinicName;
    private String clinicId;
    private CityTier cityTier;
    private Double revenue;
    private int patientCount;
    private int patientRegisteredCount;
    private int checkinCount;
    private int noShowCount;
    private int cancelledCount;
    private int totalCheckins;
    private Double averageTurnaroundMinutes;
} 
package com.example.logindemo.dto;

import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
public class DoctorTargetProgressDTO {
    private BigDecimal monthlyRevenueTarget;
    private BigDecimal currentRevenue;
    private BigDecimal revenueProgress;
    private BigDecimal remainingRevenue;
    private BigDecimal dailyAverageNeeded;
    
    private Integer monthlyPatientTarget;
    private Integer currentPatients;
    private BigDecimal patientProgress;
    private Integer remainingPatients;
    private BigDecimal dailyPatientsNeeded;
    
    private Integer monthlyProcedureTarget;
    private Integer currentProcedures;
    private BigDecimal procedureProgress;
    private Integer remainingProcedures;
    private BigDecimal dailyProceduresNeeded;
    
    private Integer daysRemainingInMonth;
    private String motivationalMessage;
} 
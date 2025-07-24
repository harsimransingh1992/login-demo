package com.example.logindemo.dto;

import com.example.logindemo.model.CityTier;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PendingPaymentClinicDTO {
    private String clinicName;
    private String clinicId;
    private CityTier cityTier;
    private Double totalPendingAmount;
    private int pendingCasesCount;
} 
package com.example.logindemo.dto;

import com.example.logindemo.model.CityTier;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClinicRevenueDTO {
    private String clinicName;
    private String clinicId;
    private CityTier cityTier;
    private Double collectedRevenue;
    private int doctorCount;
    private Double toBeCollectedRevenue;
    private Double ytdProjectedRevenue;
    private Double pendingRevenue;

    public ClinicRevenueDTO(String clinicName, String clinicId, CityTier cityTier, Double collectedRevenue, int doctorCount) {
        this.clinicName = clinicName;
        this.clinicId = clinicId;
        this.cityTier = cityTier;
        this.collectedRevenue = collectedRevenue;
        this.doctorCount = doctorCount;
    }
} 
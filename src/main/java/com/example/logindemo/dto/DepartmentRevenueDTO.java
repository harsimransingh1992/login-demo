package com.example.logindemo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DepartmentRevenueDTO {
    private String departmentName;
    private Double revenue;
    private int patientCount;
    private int procedureCount;
    private int doctorCount;
    private Double pendingRevenue;
} 
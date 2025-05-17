package com.example.logindemo.dto;

import com.example.logindemo.model.CityTier;
import com.example.logindemo.model.DentalDepartment;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProcedurePriceDTO {
    private Long id;
    private CityTier cityTier;
    private String procedureName;
    private Double price;
    private DentalDepartment dentalDepartment;
} 
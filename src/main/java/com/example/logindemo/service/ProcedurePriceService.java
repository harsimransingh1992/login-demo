package com.example.logindemo.service;

import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.model.CityTier;
import java.util.List;

public interface ProcedurePriceService {
    List<ProcedurePriceDTO> getAllProcedures();
    ProcedurePriceDTO getProcedureById(Long id);
    List<ProcedurePriceDTO> getProceduresByTier(String cityTierStr);
    List<ProcedurePriceDTO> getProceduresByTier(CityTier cityTier);

} 
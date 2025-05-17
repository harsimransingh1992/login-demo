package com.example.logindemo.service;

import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.CityTier;
import com.example.logindemo.repository.ProcedurePriceRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@Component("procedurePriceService")
public class ProcedurePriceServiceImpl implements ProcedurePriceService {

    @Resource(name = "procedurePriceRepository")
    private ProcedurePriceRepository procedurePriceRepository;
    
    @Resource(name = "modelMapper")
    private ModelMapper modelMapper;

    @Override
    public List<ProcedurePriceDTO> getAllProcedures() {
        log.info("Fetching all procedures");
        return procedurePriceRepository.findAll().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public ProcedurePriceDTO getProcedureById(Long id) {
        log.info("Fetching procedure with ID: {}", id);
        Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(id);
        return procedure.map(this::convertToDTO).orElse(null);
    }

    @Override
    public List<ProcedurePriceDTO> getProceduresByTier(String cityTierStr) {
        try {
            CityTier cityTier = CityTier.valueOf(cityTierStr);
            log.info("Fetching procedures for city tier: {}", cityTier);
            return procedurePriceRepository.findByCityTier(cityTier).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        } catch (IllegalArgumentException e) {
            log.error("Invalid city tier: {}", cityTierStr);
            return List.of();
        }
    }
    
    @Override
    public List<ProcedurePriceDTO> getProceduresByTier(CityTier cityTier) {
        log.info("Fetching procedures for city tier: {}", cityTier);
        
        // Directly use the provided city tier without conversion
        List<ProcedurePrice> procedures = procedurePriceRepository.findByCityTier(cityTier);
        
        return procedures.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    private ProcedurePriceDTO convertToDTO(ProcedurePrice procedure) {
        return modelMapper.map(procedure, ProcedurePriceDTO.class);
    }
} 
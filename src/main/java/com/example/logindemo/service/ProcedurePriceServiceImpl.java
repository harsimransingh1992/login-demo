package com.example.logindemo.service;

import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.ProcedurePriceHistory;
import com.example.logindemo.model.CityTier;
import com.example.logindemo.repository.ProcedurePriceRepository;
import com.example.logindemo.repository.ProcedurePriceHistoryRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@Component("procedurePriceService")
public class ProcedurePriceServiceImpl implements ProcedurePriceService {

    @Resource(name = "procedurePriceRepository")
    private ProcedurePriceRepository procedurePriceRepository;
    
    @Resource(name = "procedurePriceHistoryRepository")
    private ProcedurePriceHistoryRepository priceHistoryRepository;
    
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
    
    @Override
    @Transactional
    public ProcedurePriceDTO updateProcedurePrice(Long id, ProcedurePriceDTO procedureDTO, String changeReason) {
        log.info("Updating procedure price for ID: {}", id);
        Optional<ProcedurePrice> existingProcedure = procedurePriceRepository.findById(id);
        
        if (!existingProcedure.isPresent()) {
            log.error("Procedure not found with ID: {}", id);
            throw new RuntimeException("Procedure not found");
        }
        
        ProcedurePrice procedure = existingProcedure.get();
        Double oldPrice = procedure.getPrice();
        Double newPrice = procedureDTO.getPrice();
        
        // Only create history if price has changed
        if (!oldPrice.equals(newPrice)) {
            // End the current price history record
            Optional<ProcedurePriceHistory> currentHistory = priceHistoryRepository
                .findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
                    procedure, LocalDateTime.now());
            
            if (currentHistory.isPresent()) {
                ProcedurePriceHistory history = currentHistory.get();
                history.setEffectiveUntil(LocalDateTime.now());
                priceHistoryRepository.save(history);
            }
            
            // Create new price history record
            ProcedurePriceHistory newHistory = new ProcedurePriceHistory();
            newHistory.setProcedure(procedure);
            newHistory.setPrice(newPrice);
            newHistory.setEffectiveFrom(LocalDateTime.now());
            newHistory.setChangeReason(changeReason);
            priceHistoryRepository.save(newHistory);
            
            log.info("Created price history record for procedure {}: {} -> {}", 
                id, oldPrice, newPrice);
        }
        
        // Update the procedure
        procedure.setProcedureName(procedureDTO.getProcedureName());
        procedure.setCityTier(procedureDTO.getCityTier());
        procedure.setPrice(newPrice);
        procedure.setDentalDepartment(procedureDTO.getDentalDepartment());
        
        ProcedurePrice updatedProcedure = procedurePriceRepository.save(procedure);
        return convertToDTO(updatedProcedure);
    }

    @Override
    public Double getHistoricalPrice(Long procedureId, LocalDateTime date) {
        Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(procedureId);
        if (!procedure.isPresent()) {
            throw new RuntimeException("Procedure not found");
        }
        
        Optional<ProcedurePriceHistory> history = priceHistoryRepository
            .findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
                procedure.get(), date);
        
        return history.map(ProcedurePriceHistory::getPrice)
            .orElse(procedure.get().getPrice());
    }
    
    private ProcedurePriceDTO convertToDTO(ProcedurePrice procedure) {
        return modelMapper.map(procedure, ProcedurePriceDTO.class);
    }
} 
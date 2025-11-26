package com.example.logindemo.repository;

import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.CityTier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Component;

import java.util.List;

@Repository
@Component("procedurePriceRepository")
public interface ProcedurePriceRepository extends JpaRepository<ProcedurePrice, Long> {
    List<ProcedurePrice> findByCityTier(CityTier cityTier);
    List<ProcedurePrice> findByProcedureNameContainingIgnoreCase(String procedureName);
    List<ProcedurePrice> findByCityTierAndActiveTrue(CityTier cityTier);
    List<ProcedurePrice> findByProcedureNameContainingIgnoreCaseAndActiveTrue(String procedureName);
    List<ProcedurePrice> findAllByActiveTrue();
} 

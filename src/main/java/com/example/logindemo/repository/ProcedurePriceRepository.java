package com.example.logindemo.repository;

import com.example.logindemo.model.ProcedurePrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProcedurePriceRepository extends JpaRepository<ProcedurePrice, Long> {
    List<ProcedurePrice> findByProcedureNameContainingIgnoreCase(String procedureName);
} 
package com.example.logindemo.repository;

import com.example.logindemo.model.ProcedurePriceHistory;
import com.example.logindemo.model.ProcedurePrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcedurePriceHistoryRepository extends JpaRepository<ProcedurePriceHistory, Long> {
    
    List<ProcedurePriceHistory> findByProcedureOrderByEffectiveFromDesc(ProcedurePrice procedure);
    
    Optional<ProcedurePriceHistory> findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
        ProcedurePrice procedure, LocalDateTime date);
    
    List<ProcedurePriceHistory> findByProcedureAndEffectiveFromBetween(
        ProcedurePrice procedure, LocalDateTime startDate, LocalDateTime endDate);
} 
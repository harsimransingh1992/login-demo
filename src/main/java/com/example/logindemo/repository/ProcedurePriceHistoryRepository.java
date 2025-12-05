package com.example.logindemo.repository;

import com.example.logindemo.model.ProcedurePriceHistory;
import com.example.logindemo.model.ProcedurePrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcedurePriceHistoryRepository extends JpaRepository<ProcedurePriceHistory, Long> {
    
    List<ProcedurePriceHistory> findByProcedureOrderByEffectiveFromDesc(ProcedurePrice procedure);
    List<ProcedurePriceHistory> findByProcedureOrderByEffectiveFromAsc(ProcedurePrice procedure);
    
    Optional<ProcedurePriceHistory> findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
        ProcedurePrice procedure, LocalDateTime date);
    
    List<ProcedurePriceHistory> findByProcedureAndEffectiveFromBetween(
        ProcedurePrice procedure, LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT h FROM ProcedurePriceHistory h " +
           "WHERE h.procedure = :procedure " +
           "AND h.effectiveFrom <= :date " +
           "AND (h.effectiveUntil IS NULL OR h.effectiveUntil >= :date) " +
           "ORDER BY h.effectiveFrom DESC")
    List<ProcedurePriceHistory> findActiveByProcedureAndDate(@Param("procedure") ProcedurePrice procedure,
                                                             @Param("date") LocalDateTime date);
} 

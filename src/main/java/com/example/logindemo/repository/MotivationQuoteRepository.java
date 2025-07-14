package com.example.logindemo.repository;

import com.example.logindemo.model.MotivationQuote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MotivationQuoteRepository extends JpaRepository<MotivationQuote, Long> {
    
    /**
     * Find all active quotes
     */
    List<MotivationQuote> findByIsActiveTrue();
    
    /**
     * Find active quotes by category
     */
    List<MotivationQuote> findByCategoryAndIsActiveTrue(String category);
    
    /**
     * Get a random active quote
     */
    @Query(value = "SELECT * FROM motivation_quotes WHERE is_active = true ORDER BY RAND() LIMIT 1", nativeQuery = true)
    Optional<MotivationQuote> findRandomActiveQuote();
    
    /**
     * Get a random active quote by category
     */
    @Query(value = "SELECT * FROM motivation_quotes WHERE category = ?1 AND is_active = true ORDER BY RAND() LIMIT 1", nativeQuery = true)
    Optional<MotivationQuote> findRandomActiveQuoteByCategory(String category);
    
    /**
     * Count active quotes
     */
    long countByIsActiveTrue();
} 
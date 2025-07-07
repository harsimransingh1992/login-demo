package com.example.logindemo.service;

import com.example.logindemo.model.MotivationQuote;
import java.util.List;
import java.util.Optional;

public interface MotivationQuoteService {
    
    /**
     * Get a random motivation quote
     */
    Optional<MotivationQuote> getRandomQuote();
    
    /**
     * Get a random motivation quote by category
     */
    Optional<MotivationQuote> getRandomQuoteByCategory(String category);
    
    /**
     * Get all active quotes
     */
    List<MotivationQuote> getAllActiveQuotes();
    
    /**
     * Get quotes by category
     */
    List<MotivationQuote> getQuotesByCategory(String category);
    
    /**
     * Save a new quote
     */
    MotivationQuote saveQuote(MotivationQuote quote);
    
    /**
     * Update an existing quote
     */
    MotivationQuote updateQuote(Long id, MotivationQuote quote);
    
    /**
     * Delete a quote (soft delete by setting isActive to false)
     */
    void deleteQuote(Long id);
    
    /**
     * Get quote by ID
     */
    Optional<MotivationQuote> getQuoteById(Long id);
} 
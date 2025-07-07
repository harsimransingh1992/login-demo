package com.example.logindemo.service.impl;

import com.example.logindemo.model.MotivationQuote;
import com.example.logindemo.repository.MotivationQuoteRepository;
import com.example.logindemo.service.MotivationQuoteService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MotivationQuoteServiceImpl implements MotivationQuoteService {
    
    private final MotivationQuoteRepository motivationQuoteRepository;
    
    @Override
    public Optional<MotivationQuote> getRandomQuote() {
        log.debug("Getting random motivation quote");
        return motivationQuoteRepository.findRandomActiveQuote();
    }
    
    @Override
    public Optional<MotivationQuote> getRandomQuoteByCategory(String category) {
        log.debug("Getting random motivation quote for category: {}", category);
        return motivationQuoteRepository.findRandomActiveQuoteByCategory(category);
    }
    
    @Override
    public List<MotivationQuote> getAllActiveQuotes() {
        log.debug("Getting all active motivation quotes");
        return motivationQuoteRepository.findByIsActiveTrue();
    }
    
    @Override
    public List<MotivationQuote> getQuotesByCategory(String category) {
        log.debug("Getting motivation quotes for category: {}", category);
        return motivationQuoteRepository.findByCategoryAndIsActiveTrue(category);
    }
    
    @Override
    @Transactional
    public MotivationQuote saveQuote(MotivationQuote quote) {
        log.info("Saving new motivation quote: {}", quote.getQuoteText());
        quote.setCreatedAt(LocalDateTime.now());
        quote.setUpdatedAt(LocalDateTime.now());
        quote.setIsActive(true);
        return motivationQuoteRepository.save(quote);
    }
    
    @Override
    @Transactional
    public MotivationQuote updateQuote(Long id, MotivationQuote quoteDetails) {
        log.info("Updating motivation quote with ID: {}", id);
        
        Optional<MotivationQuote> existingQuote = motivationQuoteRepository.findById(id);
        if (existingQuote.isEmpty()) {
            throw new RuntimeException("Motivation quote not found with ID: " + id);
        }
        
        MotivationQuote quote = existingQuote.get();
        quote.setQuoteText(quoteDetails.getQuoteText());
        quote.setAuthor(quoteDetails.getAuthor());
        quote.setCategory(quoteDetails.getCategory());
        quote.setIsActive(quoteDetails.getIsActive());
        quote.setUpdatedAt(LocalDateTime.now());
        
        return motivationQuoteRepository.save(quote);
    }
    
    @Override
    @Transactional
    public void deleteQuote(Long id) {
        log.info("Soft deleting motivation quote with ID: {}", id);
        
        Optional<MotivationQuote> quote = motivationQuoteRepository.findById(id);
        if (quote.isPresent()) {
            MotivationQuote existingQuote = quote.get();
            existingQuote.setIsActive(false);
            existingQuote.setUpdatedAt(LocalDateTime.now());
            motivationQuoteRepository.save(existingQuote);
        } else {
            throw new RuntimeException("Motivation quote not found with ID: " + id);
        }
    }
    
    @Override
    public Optional<MotivationQuote> getQuoteById(Long id) {
        log.debug("Getting motivation quote by ID: {}", id);
        return motivationQuoteRepository.findById(id);
    }
} 
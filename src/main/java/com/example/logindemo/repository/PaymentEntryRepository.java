package com.example.logindemo.repository;

import com.example.logindemo.model.PaymentEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
 
@Repository
public interface PaymentEntryRepository extends JpaRepository<PaymentEntry, Long> {
} 
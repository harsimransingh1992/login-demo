package com.example.logindemo.repository;

import com.example.logindemo.model.PaymentEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
 
@Repository
public interface PaymentEntryRepository extends JpaRepository<PaymentEntry, Long> {
    List<PaymentEntry> findByPaymentDateBetween(LocalDateTime start, LocalDateTime end);
    
    List<PaymentEntry> findByExaminationIdOrderByPaymentDateDesc(Long examinationId);
    
    List<PaymentEntry> findByExaminationPatientIdOrderByPaymentDateDesc(Long patientId);
    
    List<PaymentEntry> findByOriginalPaymentId(Long originalPaymentId);
} 
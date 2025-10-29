package com.example.logindemo.repository;

import com.example.logindemo.model.PaymentEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
 
@Repository
public interface PaymentEntryRepository extends JpaRepository<PaymentEntry, Long> {
    List<PaymentEntry> findByPaymentDateBetween(LocalDateTime start, LocalDateTime end);
    
    List<PaymentEntry> findByExaminationIdOrderByPaymentDateDesc(Long examinationId);
    
    List<PaymentEntry> findByExaminationPatientIdOrderByPaymentDateDesc(Long patientId);
    
    List<PaymentEntry> findByOriginalPaymentId(Long originalPaymentId);

    // Fetch-join examination and its clinic to avoid LazyInitializationException in reporting
    @Query("SELECT pe FROM PaymentEntry pe JOIN FETCH pe.examination e JOIN FETCH e.examinationClinic WHERE pe.paymentDate BETWEEN :start AND :end")
    List<PaymentEntry> findAllWithExaminationClinicByPaymentDateBetween(@Param("start") LocalDateTime start,
                                                                        @Param("end") LocalDateTime end);
}
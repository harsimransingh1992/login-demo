package com.example.logindemo.repository;

import com.example.logindemo.model.DiscountEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("discountEntryRepository")
public interface DiscountEntryRepository extends JpaRepository<DiscountEntry, Long> {
    List<DiscountEntry> findByExaminationIdOrderByAppliedAtAsc(Long examinationId);
    List<DiscountEntry> findByExaminationIdAndActiveTrueOrderByAppliedAtAsc(Long examinationId);
}
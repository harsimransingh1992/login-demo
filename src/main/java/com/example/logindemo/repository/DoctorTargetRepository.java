package com.example.logindemo.repository;

import com.example.logindemo.model.CityTier;
import com.example.logindemo.model.DoctorTarget;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DoctorTargetRepository extends JpaRepository<DoctorTarget, Long> {
    Optional<DoctorTarget> findByCityTierAndIsActiveTrue(CityTier cityTier);
} 
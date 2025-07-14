package com.example.logindemo.repository;

import com.example.logindemo.model.ClinicModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ClinicRepository extends JpaRepository<ClinicModel, Long> {
    Optional<ClinicModel> findByClinicId(String clinicId);
    boolean existsByClinicId(String clinicId);
    Optional<ClinicModel> findByClinicName(String clinicName);
    Optional<ClinicModel> findByOwnerId(Long ownerId);
} 
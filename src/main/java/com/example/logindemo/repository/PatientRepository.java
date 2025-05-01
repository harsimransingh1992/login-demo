package com.example.logindemo.repository;

import com.example.logindemo.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Component("patientRepository")
public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(String firstName, String lastName);
    List<Patient> findByPhoneNumberContaining(String phoneNumber);
    List<Patient> findByCheckedInTrue();
    Patient getPatientsById(Long patientId);
} 
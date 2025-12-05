package com.example.logindemo.repository;

import com.example.logindemo.model.Patient;
import com.example.logindemo.model.ClinicModel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
@Component("patientRepository")
public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(String firstName, String lastName);
    List<Patient> findByPhoneNumberContaining(String phoneNumber);
    List<Patient> findByCheckedInTrue();
    List<Patient> findByCheckedInTrueAndCurrentCheckInRecord_Clinic(ClinicModel clinic);
    
    // Optimized query with JOIN FETCH to avoid N+1 problem
    // Ensures: 1) Patient is checked in, 2) Has a current check-in record, 3) Patient is checked in at the current clinic (allows cross-clinic check-ins)
    @Query("SELECT DISTINCT p FROM Patient p " +
           "LEFT JOIN FETCH p.currentCheckInRecord cir " +
           "LEFT JOIN FETCH cir.assignedDoctor " +
           "WHERE p.checkedIn = true " +
           "AND p.currentCheckInRecord IS NOT NULL " +
           "AND cir.clinic = :clinic " +
           "ORDER BY cir.checkInTime ASC")
    List<Patient> findCheckedInPatientsWithDetailsOptimized(@org.springframework.data.repository.query.Param("clinic") ClinicModel clinic);
    
    Patient getPatientsById(Long patientId);
    
    // Method to find patients with the same first name and phone number
    boolean existsByFirstNameIgnoreCaseAndPhoneNumber(String firstName, String phoneNumber);
    
    // Method to count patients registered between two dates
    long countByRegistrationDateBetween(Date startDate, Date endDate);
    
    // Method to find a patient by registration code
    Optional<Patient> findByRegistrationCode(String registrationCode);
    
    // Method to find patients by partial registration code match
    List<Patient> findByRegistrationCodeContainingIgnoreCase(String registrationCode);
    
    // Pagination methods
    Page<Patient> findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCase(String firstName, String lastName, Pageable pageable);
    Page<Patient> findByFirstNameContainingIgnoreCaseAndLastNameContainingIgnoreCase(String firstName, String lastName, Pageable pageable);
    Page<Patient> findByPhoneNumberContaining(String phoneNumber, Pageable pageable);
    Page<Patient> findByRegistrationCodeContainingIgnoreCase(String registrationCode, Pageable pageable);
    
    // Search by examination ID with pagination (custom query)
    @Query("SELECT DISTINCT p FROM Patient p JOIN p.toothClinicalExaminations e WHERE e.id = :examinationId")
    Page<Patient> findByExaminationId(Long examinationId, Pageable pageable);

    boolean existsByMembershipNumber(String membershipNumber);
    Optional<Patient> findByMembershipNumber(String membershipNumber);

    // Count patients registered at each clinic in a date range, grouped by clinic
    @org.springframework.data.jpa.repository.Query("SELECT p.registeredClinic.id, COUNT(p) FROM Patient p WHERE p.registeredClinic IS NOT NULL AND p.registrationDate BETWEEN :start AND :end GROUP BY p.registeredClinic.id")
    java.util.List<Object[]> countRegisteredByClinicAndDate(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);
}

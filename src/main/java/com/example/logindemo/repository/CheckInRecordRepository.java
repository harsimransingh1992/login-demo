package com.example.logindemo.repository;

import com.example.logindemo.model.CheckInRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
@Component("checkInRecordRepository")
public interface CheckInRecordRepository extends JpaRepository<CheckInRecord, Long> {
    List<CheckInRecord> findAllByOrderByCheckInTimeDesc();
    
    // Alternative method with explicit query to ensure all records are retrieved
    @Query("SELECT c FROM CheckInRecord c ORDER BY c.checkInTime DESC")
    List<CheckInRecord> findAllRecordsWithExplicitQuery();
    
    // Pagination method for all records
    @Query("SELECT c FROM CheckInRecord c ORDER BY c.checkInTime DESC")
    Page<CheckInRecord> findAllWithPagination(Pageable pageable);
    
    // Filter by patient ID
    List<CheckInRecord> findByPatientIdOrderByCheckInTimeDesc(Long patientId);
    
    // Filter by date range
    List<CheckInRecord> findByCheckInTimeBetweenOrderByCheckInTimeDesc(LocalDateTime startTime, LocalDateTime endTime);
    
    // Filter by date range with pagination
    Page<CheckInRecord> findByCheckInTimeBetweenOrderByCheckInTimeDesc(LocalDateTime startTime, LocalDateTime endTime, Pageable pageable);
    
    // Filter by start date (after)
    List<CheckInRecord> findByCheckInTimeAfterOrderByCheckInTimeDesc(LocalDateTime startTime);
    
    // Filter by start date (after) with pagination
    Page<CheckInRecord> findByCheckInTimeAfterOrderByCheckInTimeDesc(LocalDateTime startTime, Pageable pageable);
    
    // Filter by end date (before)
    List<CheckInRecord> findByCheckInTimeBeforeOrderByCheckInTimeDesc(LocalDateTime endTime);
    
    // Filter by end date (before) with pagination
    Page<CheckInRecord> findByCheckInTimeBeforeOrderByCheckInTimeDesc(LocalDateTime endTime, Pageable pageable);
    
    // Filter by patient ID and date range
    List<CheckInRecord> findByPatientIdAndCheckInTimeBetweenOrderByCheckInTimeDesc(Long patientId, LocalDateTime startTime, LocalDateTime endTime);
    
    // Filter by patient ID and start date
    List<CheckInRecord> findByPatientIdAndCheckInTimeAfterOrderByCheckInTimeDesc(Long patientId, LocalDateTime startTime);
    
    // Filter by patient ID and end date
    List<CheckInRecord> findByPatientIdAndCheckInTimeBeforeOrderByCheckInTimeDesc(Long patientId, LocalDateTime endTime);
    
    // Filter by patient registration code
    List<CheckInRecord> findByPatientRegistrationCodeOrderByCheckInTimeDesc(String registrationCode);
    
    // Filter by patient registration code with pagination
    Page<CheckInRecord> findByPatientRegistrationCodeOrderByCheckInTimeDesc(String registrationCode, Pageable pageable);
    
    // Filter by patient registration code and date range
    List<CheckInRecord> findByPatientRegistrationCodeAndCheckInTimeBetweenOrderByCheckInTimeDesc(String registrationCode, LocalDateTime startTime, LocalDateTime endTime);
    
    // Filter by patient registration code and date range with pagination
    Page<CheckInRecord> findByPatientRegistrationCodeAndCheckInTimeBetweenOrderByCheckInTimeDesc(String registrationCode, LocalDateTime startTime, LocalDateTime endTime, Pageable pageable);
    
    // Filter by patient registration code and start date
    List<CheckInRecord> findByPatientRegistrationCodeAndCheckInTimeAfterOrderByCheckInTimeDesc(String registrationCode, LocalDateTime startTime);
    
    // Filter by patient registration code and start date with pagination
    Page<CheckInRecord> findByPatientRegistrationCodeAndCheckInTimeAfterOrderByCheckInTimeDesc(String registrationCode, LocalDateTime startTime, Pageable pageable);
    
    // Filter by patient registration code and end date
    List<CheckInRecord> findByPatientRegistrationCodeAndCheckInTimeBeforeOrderByCheckInTimeDesc(String registrationCode, LocalDateTime endTime);
    
    // Filter by patient registration code and end date with pagination
    Page<CheckInRecord> findByPatientRegistrationCodeAndCheckInTimeBeforeOrderByCheckInTimeDesc(String registrationCode, LocalDateTime endTime, Pageable pageable);
}

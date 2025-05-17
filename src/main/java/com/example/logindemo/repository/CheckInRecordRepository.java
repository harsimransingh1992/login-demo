package com.example.logindemo.repository;

import com.example.logindemo.model.CheckInRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Component("checkInRecordRepository")
public interface CheckInRecordRepository extends JpaRepository<CheckInRecord, Long> {
    List<CheckInRecord> findAllByOrderByCheckInTimeDesc();
    
    // Alternative method with explicit query to ensure all records are retrieved
    @Query("SELECT c FROM CheckInRecord c ORDER BY c.checkInTime DESC")
    List<CheckInRecord> findAllRecordsWithExplicitQuery();
}

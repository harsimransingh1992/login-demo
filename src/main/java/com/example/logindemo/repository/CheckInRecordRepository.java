package com.example.logindemo.repository;

import com.example.logindemo.model.CheckInRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

@Repository
@Component("checkInRecordRepository")
public interface CheckInRecordRepository extends JpaRepository<CheckInRecord, Long> {

}

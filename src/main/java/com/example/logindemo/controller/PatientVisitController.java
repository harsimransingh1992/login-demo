package com.example.logindemo.controller;

import com.example.logindemo.model.CheckInRecord;
import com.example.logindemo.repository.CheckInRecordRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.annotation.Resource;
import java.util.List;

@Controller
@Slf4j
public class PatientVisitController {

    @Resource(name = "checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;

    @GetMapping("/visits")
    public String showPatientVisits(Model model) {
        // Try the explicit query first
        List<CheckInRecord> visits = checkInRecordRepository.findAllRecordsWithExplicitQuery();
        log.info("Retrieved {} visit records using explicit query", visits.size());
        
        // If no records found, try the default method
        if (visits.isEmpty()) {
            visits = checkInRecordRepository.findAllByOrderByCheckInTimeDesc();
            log.info("Retrieved {} visit records using default query", visits.size());
        }
        
        // If still no records, try findAll() as a fallback
        if (visits.isEmpty()) {
            visits = checkInRecordRepository.findAll();
            log.info("Retrieved {} visit records using findAll()", visits.size());
        }
        
        // Log details of first few records if available
        if (!visits.isEmpty()) {
            for (int i = 0; i < Math.min(visits.size(), 3); i++) {
                CheckInRecord visit = visits.get(i);
                log.info("Visit #{}: ID={}, PatientID={}, ClinicID={}, CheckInTime={}", 
                    i+1, visit.getId(), 
                    visit.getPatient() != null ? visit.getPatient().getId() : "null",
                    visit.getCheckInClinic() != null ? visit.getCheckInClinic().getId() : "null",
                    visit.getCheckInTime());
            }
        } else {
            log.warn("No visit records found in database using any method");
        }
        
        model.addAttribute("visits", visits);
        return "visits/list";
    }
} 
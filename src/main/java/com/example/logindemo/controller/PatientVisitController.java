package com.example.logindemo.controller;

import com.example.logindemo.model.CheckInRecord;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.repository.CheckInRecordRepository;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Controller
@Slf4j
public class PatientVisitController {

    @Resource(name = "checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;

    @GetMapping("/visits")
    public String showPatientVisits(
            @RequestParam(required = false) String patientRegistrationCode,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) Boolean searchWithinClinic,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(defaultValue = "checkInTime") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            Model model) {
        
        // Use pageSize if provided, otherwise use size (for backward compatibility)
        int actualSize = pageSize != 20 ? pageSize : size;
        
        // Get current user's clinic
        ClinicModel currentClinic = null;
        try {
            currentClinic = PeriDeskUtils.getCurrentClinicModel();
            model.addAttribute("currentClinic", currentClinic);
        } catch (Exception e) {
            log.warn("Could not get current clinic: {}", e.getMessage());
        }
        
        // Create pageable object with sorting
        Pageable pageable = PageRequest.of(
            page, 
            actualSize, 
            Sort.by(
                "desc".equalsIgnoreCase(direction) ? 
                Sort.Direction.DESC : 
                Sort.Direction.ASC, 
                sort
            )
        );
        
        Page<CheckInRecord> visitsPage;
        
        // Apply filters if provided
        if (patientRegistrationCode != null || (startDate != null && !startDate.isEmpty()) || (endDate != null && !endDate.isEmpty()) || (searchWithinClinic != null && searchWithinClinic)) {
            visitsPage = applyFiltersWithPagination(patientRegistrationCode, startDate, endDate, searchWithinClinic, currentClinic, pageable);
            log.info("Retrieved {} visit records with filters: patientRegistrationCode={}, startDate={}, endDate={}, searchWithinClinic={}, page={}, size={}", 
                visitsPage.getTotalElements(), patientRegistrationCode, startDate, endDate, searchWithinClinic, page, actualSize);
        } else {
            // Get all visits with pagination if no filters
            visitsPage = checkInRecordRepository.findAllWithPagination(pageable);
            log.info("Retrieved {} visit records using pagination, page={}, size={}", visitsPage.getTotalElements(), page, actualSize);
        }
        
        // Log details of first few records if available
        if (!visitsPage.getContent().isEmpty()) {
            for (int i = 0; i < Math.min(visitsPage.getContent().size(), 3); i++) {
                CheckInRecord visit = visitsPage.getContent().get(i);
                log.info("Visit #{}: ID={}, PatientID={}, ClinicID={}, CheckInTime={}", 
                    i+1, visit.getId(), 
                    visit.getPatient() != null ? visit.getPatient().getId() : "null",
                    visit.getClinic() != null ? visit.getClinic().getId() : "null",
                    visit.getCheckInTime());
            }
        } else {
            log.warn("No visit records found in database using pagination");
        }
        
        model.addAttribute("visits", visitsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", visitsPage.getTotalPages());
        model.addAttribute("totalItems", visitsPage.getTotalElements());
        model.addAttribute("pageSize", actualSize);
        model.addAttribute("sort", sort);
        model.addAttribute("direction", direction);
        model.addAttribute("patientRegistrationCode", patientRegistrationCode);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("searchWithinClinic", searchWithinClinic);
        
        return "visits/list";
    }
    
    private Page<CheckInRecord> applyFiltersWithPagination(String patientRegistrationCode, String startDate, String endDate, Boolean searchWithinClinic, ClinicModel currentClinic, Pageable pageable) {
        LocalDateTime startDateTime = null;
        LocalDateTime endDateTime = null;
        
        // Parse start date
        if (startDate != null && !startDate.isEmpty()) {
            try {
                LocalDate start = LocalDate.parse(startDate);
                startDateTime = start.atStartOfDay();
            } catch (Exception e) {
                log.warn("Invalid start date format: {}", startDate);
            }
        }
        
        // Parse end date
        if (endDate != null && !endDate.isEmpty()) {
            try {
                LocalDate end = LocalDate.parse(endDate);
                endDateTime = end.atTime(LocalTime.MAX); // End of day
            } catch (Exception e) {
                log.warn("Invalid end date format: {}", endDate);
            }
        }
        
        // Get records with pagination based on filters
        Page<CheckInRecord> recordsPage = getAllRecordsWithFiltersAndPagination(patientRegistrationCode, startDateTime, endDateTime, pageable);
        
        // Apply clinic filter if requested and current clinic is available
        if (searchWithinClinic != null && searchWithinClinic && currentClinic != null) {
            // Filter the page content by clinic
            List<CheckInRecord> filteredContent = recordsPage.getContent().stream()
                .filter(record -> record.getClinic() != null && record.getClinic().getId().equals(currentClinic.getId()))
                .collect(java.util.stream.Collectors.toList());
            
            // Create a new page with filtered content
            // Note: This is a simplified approach. For better performance, the clinic filter should be applied at the database level
            recordsPage = new org.springframework.data.domain.PageImpl<>(
                filteredContent, 
                pageable, 
                recordsPage.getTotalElements()
            );
            
            log.info("Applied clinic filter for clinic: {} (ID: {}), filtered to {} records", 
                currentClinic.getClinicName(), currentClinic.getId(), filteredContent.size());
        }
        
        return recordsPage;
    }
    
    private Page<CheckInRecord> getAllRecordsWithFiltersAndPagination(String patientRegistrationCode, LocalDateTime startDateTime, LocalDateTime endDateTime, Pageable pageable) {
        // Apply filters based on what's provided with pagination
        if (patientRegistrationCode != null && !patientRegistrationCode.isEmpty() && startDateTime != null && endDateTime != null) {
            return checkInRecordRepository.findByPatientRegistrationCodeAndCheckInTimeBetweenOrderByCheckInTimeDesc(patientRegistrationCode, startDateTime, endDateTime, pageable);
        } else if (patientRegistrationCode != null && !patientRegistrationCode.isEmpty() && startDateTime != null) {
            return checkInRecordRepository.findByPatientRegistrationCodeAndCheckInTimeAfterOrderByCheckInTimeDesc(patientRegistrationCode, startDateTime, pageable);
        } else if (patientRegistrationCode != null && !patientRegistrationCode.isEmpty() && endDateTime != null) {
            return checkInRecordRepository.findByPatientRegistrationCodeAndCheckInTimeBeforeOrderByCheckInTimeDesc(patientRegistrationCode, endDateTime, pageable);
        } else if (patientRegistrationCode != null && !patientRegistrationCode.isEmpty()) {
            return checkInRecordRepository.findByPatientRegistrationCodeOrderByCheckInTimeDesc(patientRegistrationCode, pageable);
        } else if (startDateTime != null && endDateTime != null) {
            return checkInRecordRepository.findByCheckInTimeBetweenOrderByCheckInTimeDesc(startDateTime, endDateTime, pageable);
        } else if (startDateTime != null) {
            return checkInRecordRepository.findByCheckInTimeAfterOrderByCheckInTimeDesc(startDateTime, pageable);
        } else if (endDateTime != null) {
            return checkInRecordRepository.findByCheckInTimeBeforeOrderByCheckInTimeDesc(endDateTime, pageable);
        } else {
            return checkInRecordRepository.findAllWithPagination(pageable);
        }
    }
} 
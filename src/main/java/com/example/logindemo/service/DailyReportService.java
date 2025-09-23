package com.example.logindemo.service;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PatientRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
public class DailyReportService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ClinicRepository clinicRepository;

    /**
     * Generate daily patient registration report for all clinics
     * @return formatted report string with patient registration numbers
     */
    public String generateDailyPatientRegistrationReport() {
        try {
            // Get yesterday's date range (from 00:00:00 to 23:59:59)
            LocalDate yesterday = LocalDate.now().minusDays(1);
            Date startDate = Date.from(yesterday.atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date endDate = Date.from(yesterday.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());

            log.info("Generating daily report for date: {}", yesterday);

            // Get all clinics
            List<ClinicModel> allClinics = clinicRepository.findAll();
            
            // Get patient registration counts by clinic for yesterday
            List<Object[]> registrationCounts = patientRepository.countRegisteredByClinicAndDate(startDate, endDate);
            
            // Convert to map for easy lookup
            Map<Long, Long> clinicRegistrationMap = registrationCounts.stream()
                .collect(Collectors.toMap(
                    row -> (Long) row[0],  // clinic ID
                    row -> (Long) row[1]   // count
                ));

            // Build the report
            StringBuilder report = new StringBuilder();
            report.append("DAILY PATIENT REGISTRATION REPORT\n");
            report.append("Date: ").append(yesterday).append("\n");
            report.append("=====================================\n\n");

            long totalRegistrations = 0;
            int clinicsWithRegistrations = 0;

            for (ClinicModel clinic : allClinics) {
                Long registrationCount = clinicRegistrationMap.getOrDefault(clinic.getId(), 0L);
                
                report.append("Clinic: ").append(clinic.getClinicName())
                      .append(" (ID: ").append(clinic.getClinicId()).append(")\n");
                report.append("New Patient Registrations: ").append(registrationCount).append("\n\n");
                
                totalRegistrations += registrationCount;
                if (registrationCount > 0) {
                    clinicsWithRegistrations++;
                }
            }

            // Summary section
            report.append("=====================================\n");
            report.append("SUMMARY\n");
            report.append("=====================================\n");
            report.append("Total Clinics: ").append(allClinics.size()).append("\n");
            report.append("Clinics with New Registrations: ").append(clinicsWithRegistrations).append("\n");
            report.append("Total New Patient Registrations: ").append(totalRegistrations).append("\n");

            log.info("Daily report generated successfully. Total registrations: {}", totalRegistrations);
            return report.toString();

        } catch (Exception e) {
            log.error("Error generating daily patient registration report", e);
            return "Error generating daily report: " + e.getMessage();
        }
    }

    /**
     * Get total patient registrations for yesterday across all clinics
     * @return total count
     */
    public long getTotalRegistrationsYesterday() {
        try {
            LocalDate yesterday = LocalDate.now().minusDays(1);
            Date startDate = Date.from(yesterday.atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date endDate = Date.from(yesterday.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());
            
            return patientRepository.countByRegistrationDateBetween(startDate, endDate);
        } catch (Exception e) {
            log.error("Error getting total registrations for yesterday", e);
            return 0;
        }
    }
}
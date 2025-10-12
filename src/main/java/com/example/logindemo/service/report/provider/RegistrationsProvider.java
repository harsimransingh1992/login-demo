package com.example.logindemo.service.report.provider;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class RegistrationsProvider implements ReportDataProvider {

    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Override
    public Map<String, Object> getData(Map<String, Object> parameters) {
        LocalDate reportDate = normalizeDate(parameters.get("date"));

        Date startDate = Date.from(reportDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDate = Date.from(reportDate.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());

        List<ClinicModel> clinics = clinicRepository.findAll();
        List<Object[]> counts = patientRepository.countRegisteredByClinicAndDate(startDate, endDate);

        Map<Long, Long> countByClinicId = counts.stream()
                .collect(Collectors.toMap(row -> (Long) row[0], row -> (Long) row[1]));

        List<Map<String, Object>> clinicData = new ArrayList<>();
        long totalRegistrations = 0;
        int clinicsWithRegistrations = 0;

        List<ClinicModel> sortedClinics = clinics.stream()
                .sorted(Comparator.comparing(ClinicModel::getClinicName, Comparator.nullsLast(String::compareToIgnoreCase)))
                .collect(Collectors.toList());

        for (ClinicModel clinic : sortedClinics) {
            long registrations = countByClinicId.getOrDefault(clinic.getId(), 0L);
            totalRegistrations += registrations;
            if (registrations > 0) clinicsWithRegistrations++;

            Map<String, Object> clinicJson = new LinkedHashMap<>();
            clinicJson.put("id", clinic.getId());
            clinicJson.put("code", clinic.getClinicId());
            clinicJson.put("name", clinic.getClinicName());
            clinicJson.put("registrations", registrations);
            clinicData.add(clinicJson);
        }

        Map<String, Object> totals = new LinkedHashMap<>();
        totals.put("totalClinics", clinics.size());
        totals.put("clinicsWithRegistrations", clinicsWithRegistrations);
        totals.put("totalRegistrations", totalRegistrations);

        Map<String, Object> root = new LinkedHashMap<>();
        root.put("reportType", getReportType());
        root.put("schemaVersion", getSchemaVersion());
        root.put("date", reportDate.toString());
        root.put("clinics", clinicData);
        root.put("totals", totals);
        root.put("generatedAt", LocalDateTime.now().toString());

        return root;
    }

    @Override
    public String getReportType() {
        return "dailyPatientRegistrations";
    }

    @Override
    public String getSchemaVersion() {
        return "1.0";
    }

    private LocalDate normalizeDate(Object value) {
        if (value instanceof LocalDate) {
            return (LocalDate) value;
        }
        if (value instanceof String) {
            try {
                return LocalDate.parse((String) value);
            } catch (Exception ignored) {}
        }
        return LocalDate.now().minusDays(1);
    }
}
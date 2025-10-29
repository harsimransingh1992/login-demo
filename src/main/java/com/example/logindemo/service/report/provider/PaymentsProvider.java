package com.example.logindemo.service.report.provider;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.model.TransactionType;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PaymentEntryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class PaymentsProvider implements ReportDataProvider {

    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private PaymentEntryRepository paymentEntryRepository;

    @Override
    public Map<String, Object> getData(Map<String, Object> parameters) {
        LocalDate reportDate = normalizeDate(parameters.get("date"));
        boolean includeRefunds = normalizeBoolean(parameters.get("includeRefunds"), true);

        LocalDateTime startOfDay = reportDate.atStartOfDay();
        LocalDateTime endOfDay = reportDate.plusDays(1).atStartOfDay();

        List<ClinicModel> clinics = clinicRepository.findAll();
        // Use fetch-join to eagerly load examination and clinic, avoiding LazyInitializationException
        List<PaymentEntry> payments = paymentEntryRepository.findAllWithExaminationClinicByPaymentDateBetween(startOfDay, endOfDay);

        Map<Long, List<PaymentEntry>> paymentsByClinicId = payments.stream()
                .filter(p -> p.getExamination() != null && p.getExamination().getExaminationClinic() != null)
                .collect(Collectors.groupingBy(p -> p.getExamination().getExaminationClinic().getId()));

        List<Map<String, Object>> clinicData = new ArrayList<>();
        double grandCapture = 0.0;
        double grandRefund = 0.0;
        int grandTransactions = 0;

        // Sort clinics by name for stable output
        List<ClinicModel> sortedClinics = clinics.stream()
                .sorted(Comparator.comparing(ClinicModel::getClinicName, Comparator.nullsLast(String::compareToIgnoreCase)))
                .collect(Collectors.toList());

        for (ClinicModel clinic : sortedClinics) {
            List<PaymentEntry> clinicPayments = paymentsByClinicId.getOrDefault(clinic.getId(), List.of());

            double captured = clinicPayments.stream()
                    .filter(p -> p.getTransactionType() == TransactionType.CAPTURE)
                    .mapToDouble(p -> p.getAmount() != null ? p.getAmount() : 0.0)
                    .sum();

            double refunded = clinicPayments.stream()
                    .filter(p -> p.getTransactionType() == TransactionType.REFUND)
                    .mapToDouble(p -> p.getAmount() != null ? p.getAmount() : 0.0)
                    .sum();

            int transactions = (int) clinicPayments.stream()
                    .filter(p -> includeRefunds || p.getTransactionType() == TransactionType.CAPTURE)
                    .count();

            double net = captured - refunded;

            grandCapture += captured;
            grandRefund += refunded;
            grandTransactions += transactions;

            Map<String, Object> clinicJson = new LinkedHashMap<>();
            clinicJson.put("id", clinic.getId());
            clinicJson.put("code", clinic.getClinicId());
            clinicJson.put("name", clinic.getClinicName());
            clinicJson.put("captured", roundTwo(captured));
            clinicJson.put("refunded", roundTwo(refunded));
            clinicJson.put("net", roundTwo(net));
            clinicJson.put("transactions", transactions);

            clinicData.add(clinicJson);
        }

        Map<String, Object> totals = new LinkedHashMap<>();
        totals.put("captured", roundTwo(grandCapture));
        totals.put("refunded", roundTwo(grandRefund));
        totals.put("net", roundTwo(grandCapture - grandRefund));
        totals.put("transactions", grandTransactions);

        Map<String, Object> root = new LinkedHashMap<>();
        root.put("reportType", getReportType());
        root.put("schemaVersion", getSchemaVersion());
        root.put("date", reportDate.toString());
        root.put("includeRefunds", includeRefunds);
        root.put("clinics", clinicData);
        root.put("totals", totals);
        root.put("generatedAt", LocalDateTime.now().toString());

        return root;
    }

    @Override
    public String getReportType() {
        return "dailyClinicCollections";
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

    private boolean normalizeBoolean(Object value, boolean defaultVal) {
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        if (value instanceof String) {
            return Boolean.parseBoolean((String) value);
        }
        return defaultVal;
    }

    private double roundTwo(double v) {
        return Math.round(v * 100.0) / 100.0;
    }
}
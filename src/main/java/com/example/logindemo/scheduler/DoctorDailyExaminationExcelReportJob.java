package com.example.logindemo.scheduler;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.EmailService;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Slf4j
public class DoctorDailyExaminationExcelReportJob {

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Autowired(required = false)
    private EmailService emailService;

    // Use existing default property for daily report recipients
    @Value("${daily.report.recipients:}")
    private String reportRecipientsCsv;

    @Value("${reports.base-dir:uploads}")
    private String reportsBaseDir;

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TS_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Scheduled(cron = "0 0 8 * * *")
    public void generateDailyDoctorExaminationReport() {
        LocalDate reportDay = LocalDate.now().minusDays(1);
        LocalDateTime from = reportDay.atStartOfDay();
        LocalDateTime to = reportDay.atTime(LocalTime.MAX);

        log.info("Generating doctor examinations report for {} ({} to {})", reportDay, from, to);

        try {
            List<ToothClinicalExamination> exams = examinationRepository.findWithDoctorByDateRange(from, to);
            log.info("Fetched {} examinations for report day {}", exams.size(), reportDay);

            Path dir = Paths.get(reportsBaseDir, "reports", "daily-doctor-examinations");
            Files.createDirectories(dir);

            String filename = String.format("doctor-examinations-%s.xlsx", DATE_FMT.format(reportDay));
            Path outputPath = dir.resolve(filename);

            try (SXSSFWorkbook workbook = new SXSSFWorkbook(100); FileOutputStream fos = new FileOutputStream(outputPath.toFile())) {
                // Styles
                CellStyle headerStyle = createHeaderStyle(workbook);
                CellStyle defaultStyle = createDefaultStyle(workbook);
                CellStyle dateStyle = createDateStyle(workbook);

                // Build summary sheet
                buildSummarySheet(workbook, exams, headerStyle, defaultStyle, reportDay);

                // Build doctor sheets
                Map<String, List<ToothClinicalExamination>> byDoctor = exams.stream()
                        .collect(Collectors.groupingBy(this::resolveDoctorName));
                for (Map.Entry<String, List<ToothClinicalExamination>> entry : byDoctor.entrySet()) {
                    buildDoctorSheet(workbook, sanitizeSheetName(entry.getKey()), entry.getValue(), headerStyle, defaultStyle, dateStyle);
                }

                // Write and dispose
                workbook.write(fos);
                workbook.dispose();
            }

            log.info("Doctor examinations report written to {}", outputPath);

            // Optional email distribution (simple text notice)
            if (emailService != null && reportRecipientsCsv != null && !reportRecipientsCsv.trim().isEmpty()) {
                String subject = String.format("Daily Doctor Examination Report - %s", DATE_FMT.format(reportDay));
                String body = String.format("The daily doctor examination report has been generated.\nDate: %s\nLocation: %s\nGenerated at: %s",
                        DATE_FMT.format(reportDay), outputPath.toAbsolutePath(), TS_FMT.format(LocalDateTime.now()));
                for (String recipient : reportRecipientsCsv.split(",")) {
                    String r = recipient.trim();
                    if (!r.isEmpty()) {
                        try {
                            emailService.sendSimpleMessage(r, subject, body);
                            log.info("Sent report notification email to {}", r);
                        } catch (Exception e) {
                            log.error("Failed to send report email to {}: {}", r, e.getMessage());
                        }
                    }
                }
            }

        } catch (Exception e) {
            log.error("Error generating doctor examinations report for {}: {}", reportDay, e.getMessage(), e);
        }
    }

    private void buildSummarySheet(Workbook wb, List<ToothClinicalExamination> exams, CellStyle headerStyle, CellStyle defaultStyle, LocalDate reportDay) {
        Sheet sheet = wb.createSheet("Summary");

        // Title
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Daily Doctor Examination Summary");
        titleCell.setCellStyle(headerStyle);
        sheet.createRow(1).createCell(0).setCellValue("Report Date: " + DATE_FMT.format(reportDay));
        sheet.createRow(2).createCell(0).setCellValue("Generated At: " + TS_FMT.format(LocalDateTime.now()));

        // Clinic-wise breakdown
        int rowIdx = 4;
        Row clinicHdr = sheet.createRow(rowIdx++);
        createHeaderCells(clinicHdr, headerStyle, Arrays.asList("Clinic", "Patients Examined"));

        Map<String, Long> clinicCounts = exams.stream()
                .collect(Collectors.groupingBy(e -> resolveClinicName(e.getExaminationClinic()), Collectors.counting()));
        for (Map.Entry<String, Long> entry : clinicCounts.entrySet()) {
            Row r = sheet.createRow(rowIdx++);
            r.createCell(0).setCellValue(entry.getKey());
            r.createCell(1).setCellValue(entry.getValue());
            r.getCell(0).setCellStyle(defaultStyle);
            r.getCell(1).setCellStyle(defaultStyle);
        }

        rowIdx += 2;
        // Count per doctor across all clinics
        Row docHdr = sheet.createRow(rowIdx++);
        createHeaderCells(docHdr, headerStyle, Arrays.asList("Doctor", "Patients Examined"));
        Map<String, Long> doctorCounts = exams.stream()
                .collect(Collectors.groupingBy(this::resolveDoctorName, Collectors.counting()));
        for (Map.Entry<String, Long> entry : doctorCounts.entrySet()) {
            Row r = sheet.createRow(rowIdx++);
            r.createCell(0).setCellValue(entry.getKey());
            r.createCell(1).setCellValue(entry.getValue());
            r.getCell(0).setCellStyle(defaultStyle);
            r.getCell(1).setCellStyle(defaultStyle);
        }

        rowIdx += 2;
        // Summary statistics
        Row statsHdr = sheet.createRow(rowIdx++);
        createHeaderCells(statsHdr, headerStyle, Arrays.asList("Metric", "Value"));
        long total = exams.size();
        double avgPerClinic = clinicCounts.isEmpty() ? 0.0 : (double) total / clinicCounts.size();
        double avgPerDoctor = doctorCounts.isEmpty() ? 0.0 : (double) total / doctorCounts.size();

        row(sheet, rowIdx++, defaultStyle, "Total Patients Examined", String.valueOf(total));
        row(sheet, rowIdx++, defaultStyle, "Average per Clinic", String.format(Locale.US, "%.2f", avgPerClinic));
        row(sheet, rowIdx++, defaultStyle, "Average per Doctor", String.format(Locale.US, "%.2f", avgPerDoctor));

        sheet.getFooter().setLeft("Generated: " + TS_FMT.format(LocalDateTime.now()));
        autoSizeColumns(sheet, 4);
    }

    private void buildDoctorSheet(Workbook wb, String doctorName, List<ToothClinicalExamination> items,
                                  CellStyle headerStyle, CellStyle defaultStyle, CellStyle dateStyle) {
        Sheet sheet = wb.createSheet(doctorName);

        Row hdr = sheet.createRow(0);
        createHeaderCells(hdr, headerStyle, Arrays.asList("Date", "Patient ID", "Examination Type", "Clinic"));

        int rowIdx = 1;
        for (ToothClinicalExamination e : items) {
            Row r = sheet.createRow(rowIdx++);
            Cell c0 = r.createCell(0);
            c0.setCellValue(TS_FMT.format(resolveExamDate(e)));
            c0.setCellStyle(dateStyle);

            Patient p = e.getPatient();
            r.createCell(1).setCellValue(p != null && p.getId() != null ? p.getId() : -1);

            ProcedurePrice proc = e.getProcedure();
            r.createCell(2).setCellValue(proc != null ? proc.getProcedureName() : "-");

            r.createCell(3).setCellValue(resolveClinicName(e.getExaminationClinic()));

            for (int i = 1; i <= 3; i++) {
                Cell cell = r.getCell(i);
                if (cell != null) cell.setCellStyle(defaultStyle);
            }
        }

        sheet.getFooter().setLeft("Generated: " + TS_FMT.format(LocalDateTime.now()));
        autoSizeColumns(sheet, 4);
    }

    private CellStyle createHeaderStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private CellStyle createDefaultStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private CellStyle createDateStyle(Workbook wb) {
        CellStyle style = createDefaultStyle(wb);
        DataFormat format = wb.createDataFormat();
        style.setDataFormat(format.getFormat("yyyy-mm-dd hh:mm:ss"));
        return style;
    }

    private void createHeaderCells(Row row, CellStyle style, List<String> headers) {
        for (int i = 0; i < headers.size(); i++) {
            Cell c = row.createCell(i);
            c.setCellValue(headers.get(i));
            c.setCellStyle(style);
        }
    }

    private void row(Sheet sheet, int idx, CellStyle style, String c0, String c1) {
        Row r = sheet.createRow(idx);
        r.createCell(0).setCellValue(c0);
        r.createCell(1).setCellValue(c1);
        r.getCell(0).setCellStyle(style);
        r.getCell(1).setCellStyle(style);
    }

    private void autoSizeColumns(Sheet sheet, int count) {
        for (int i = 0; i < count; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    private String resolveDoctorName(ToothClinicalExamination e) {
        User doc = e.getAssignedDoctor() != null ? e.getAssignedDoctor() : e.getOpdDoctor();
        if (doc == null) return "Unknown Doctor";
        String first = doc.getFirstName() != null ? doc.getFirstName() : "";
        String last = doc.getLastName() != null ? doc.getLastName() : "";
        String name = (first + " " + last).trim();
        return name.isEmpty() ? (doc.getUsername() != null ? doc.getUsername() : "Doctor") : name;
    }

    private String resolveClinicName(ClinicModel clinic) {
        if (clinic == null) return "Unknown Clinic";
        return clinic.getClinicName() != null ? clinic.getClinicName() : (clinic.getClinicId() != null ? clinic.getClinicId() : "Clinic");
    }

    private LocalDateTime resolveExamDate(ToothClinicalExamination e) {
        return e.getExaminationDate() != null ? e.getExaminationDate() : (e.getCreatedAt() != null ? e.getCreatedAt() : LocalDateTime.now());
    }

    private String sanitizeSheetName(String name) {
        if (name == null || name.isEmpty()) name = "Doctor";
        // Escape backslashes for Java string and regex to avoid invalid escape sequences
        String sanitized = name.replaceAll("[\\\\/*?\\n\\r\\[\\]]", "-");
        return sanitized.length() > 31 ? sanitized.substring(0, 31) : sanitized;
    }
}
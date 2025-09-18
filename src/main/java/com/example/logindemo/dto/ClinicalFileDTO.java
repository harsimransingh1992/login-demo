package com.example.logindemo.dto;

import com.example.logindemo.model.ClinicalFileStatus;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ClinicalFileDTO {
    
    private Long id;
    private Long patientId;
    private Long clinicId;
    
    // Patient information for display
    private String patientFirstName;
    private String patientLastName;
    private String patientFullName;
    
    private String fileNumber;
    private String title;
    private ClinicalFileStatus status;
    private String notes;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private LocalDateTime createdAt;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private LocalDateTime updatedAt;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private LocalDateTime closedAt;
    
    // Formatted date strings for easy display
    private String createdAtFormatted;
    private String updatedAtFormatted;
    private String closedAtFormatted;
    
    // Related entities (commented out to avoid mapping conflicts)
    // private PatientDTO patient;
    // private ClinicModelDTO clinic;
    
    // Computed fields
    private Integer examinationCount;
    private Double totalAmount;
    private Double totalPaidAmount;
    private Double remainingAmount;
    private Boolean hasPendingPayments;
    private String overallStatus;
    
    // List of examinations in this file
    private List<ToothClinicalExaminationDTO> examinations;
}

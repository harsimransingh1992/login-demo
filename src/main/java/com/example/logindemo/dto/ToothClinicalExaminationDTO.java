package com.example.logindemo.dto;

import com.example.logindemo.model.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ToothClinicalExaminationDTO {
    private Long id;
    private Long patientId;
    private ToothNumber toothNumber;
    private ToothCondition toothCondition;
    private ToothMobility toothMobility;
    private PocketDepth pocketDepth;
    private BleedingOnProbing bleedingOnProbing;
    private PlaqueScore plaqueScore;
    private GingivalRecession gingivalRecession;
    private ToothVitality toothVitality;
    private FurcationInvolvement furcationInvolvement;
    private PeriapicalCondition periapicalCondition;
    private ToothSensitivity toothSensitivity;
    private ExistingRestoration existingRestoration;
    private String examinationNotes;
    private String chiefComplaints;
    private String advised;
    private String upperDenturePicturePath;
    private String lowerDenturePicturePath;
    private String xrayPicturePath;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private LocalDateTime examinationDate;
    private LocalDateTime treatmentStartingDate;
    
    private Long assignedDoctorId;
    private Long opdDoctorId;
    
    @JsonManagedReference
    private PatientDTO patient;
    
    @JsonManagedReference
    private ClinicModelDTO examinationClinic;
    
    private ProcedurePriceDTO procedure;
    private LocalDateTime followUpDate;
    private String followUpNotes;
    private PaymentMode paymentMode;
    private String paymentNotes;
    private LocalDateTime paymentCollectionDate;
    private Double paymentAmount;
    private String treatmentStartDate;

    /**
     * Custom setter for toothNumber that handles both enum and string values
     */
    public void setToothNumber(Object value) {
        if (value instanceof ToothNumber) {
            this.toothNumber = (ToothNumber) value;
        } else if (value instanceof String) {
            try {
                this.toothNumber = ToothNumber.valueOf((String) value);
            } catch (IllegalArgumentException e) {
            this.toothNumber = null;
            }
        } else {
            this.toothNumber = null;
        }
    }

    public PaymentMode getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(PaymentMode paymentMode) {
        this.paymentMode = paymentMode;
    }

    public String getPaymentNotes() {
        return paymentNotes;
    }

    public void setPaymentNotes(String paymentNotes) {
        this.paymentNotes = paymentNotes;
    }
}

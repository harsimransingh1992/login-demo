package com.example.logindemo.dto;


import com.example.logindemo.model.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class ToothClinicalExaminationDTO {
    private Long id;
    private Long patientId;
    private ToothNumber toothNumber;
    private ToothSurface toothSurface;
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
    private LocalDateTime examinationDate;
    private LocalDateTime treatmentStartingDate;
    private DoctorDetailDTO assignedDoctor;
    private PatientDTO patient;
    private UserDTO examinationClinic;

}

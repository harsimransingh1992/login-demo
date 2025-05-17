package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Setter
@Getter
@Entity
@Table(name = "toothclinicalexamination")
public class ToothClinicalExamination {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private ToothNumber toothNumber;

    @Enumerated(EnumType.STRING)
    private ToothSurface toothSurface;

    @Enumerated(EnumType.STRING)
    private ToothCondition toothCondition;

    @Enumerated(EnumType.STRING)
    private ToothMobility toothMobility;

    @Enumerated(EnumType.STRING)
    private PocketDepth pocketDepth;

    @Enumerated(EnumType.STRING)
    private BleedingOnProbing bleedingOnProbing;

    @Enumerated(EnumType.STRING)
    private PlaqueScore plaqueScore;

    @Enumerated(EnumType.STRING)
    private GingivalRecession gingivalRecession;

    @Enumerated(EnumType.STRING)
    private ToothVitality toothVitality;

    @Enumerated(EnumType.STRING)
    private FurcationInvolvement furcationInvolvement;

    @Enumerated(EnumType.STRING)
    private PeriapicalCondition periapicalCondition;

    @Enumerated(EnumType.STRING)
    private ToothSensitivity toothSensitivity;

    @Enumerated(EnumType.STRING)
    private ExistingRestoration existingRestoration;

    @Column(nullable = false)
    private LocalDateTime examinationDate = LocalDateTime.now();

    @Column
    private String examinationNotes;

    @OneToOne(cascade = CascadeType.ALL)
    private DoctorDetail assignedDoctor;

    @ManyToOne
    private Patient patient;

    @Column
    private LocalDateTime treatmentStartingDate;

    @OneToOne(cascade = CascadeType.ALL)
    private User examinationClinic;

    @OneToMany
    private List<ProcedurePrice> procedures;
}

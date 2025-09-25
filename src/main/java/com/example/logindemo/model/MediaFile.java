package com.example.logindemo.model;

import com.example.logindemo.model.TreatmentPhase;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "media_file")
public class MediaFile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "examination_id")
    private ToothClinicalExamination examination;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Column(name = "file_type")
    private String fileType; // e.g. 'xray', 'profile', etc.

    @Column(name = "treatment_phase")
    @Enumerated(EnumType.STRING)
    private TreatmentPhase treatmentPhase = TreatmentPhase.PRE; // Default to PRE treatment phase

    @Column(name = "uploaded_at")
    private LocalDateTime uploadedAt = LocalDateTime.now();
}
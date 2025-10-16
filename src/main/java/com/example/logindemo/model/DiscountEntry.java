package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "discount_entries")
public class DiscountEntry {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "examination_id")
    private ToothClinicalExamination examination;

    @Enumerated(EnumType.STRING)
    @Column(name = "reason_enum")
    private DiscountReason reasonEnum;

    /**
     * Applied percentage snapshot at time of discount application.
     */
    @Column(name = "applied_percentage")
    private Double percentage;

    @Column(name = "note", length = 500)
    private String note;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "applied_by")
    private User appliedBy;

    @Column(name = "applied_at")
    private LocalDateTime appliedAt = LocalDateTime.now();

    /** Active flag to allow logical removal while keeping audit history */
    @Column(name = "is_active")
    private Boolean active = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "removed_by")
    private User removedBy;

    @Column(name = "removed_at")
    private LocalDateTime removedAt;

    public Double getEffectivePercentage() {
        double p = percentage != null ? percentage : 0.0;
        if (p < 0.0) return 0.0;
        if (p > 100.0) return 100.0;
        return p;
    }
}
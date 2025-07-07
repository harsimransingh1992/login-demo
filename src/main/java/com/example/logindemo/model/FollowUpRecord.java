package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a follow-up record for a dental examination.
 * This allows tracking multiple follow-ups for the same examination.
 */
@Setter
@Getter
@Entity
@Table(name = "follow_up_records")
public class FollowUpRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * The examination this follow-up belongs to
     */
    @ManyToOne
    @JoinColumn(name = "examination_id", nullable = false)
    private ToothClinicalExamination examination;

    /**
     * The scheduled date and time for the follow-up
     */
    @Column(name = "scheduled_date", nullable = false)
    private LocalDateTime scheduledDate;

    /**
     * The actual date and time when the follow-up was completed
     */
    @Column(name = "completed_date")
    private LocalDateTime completedDate;

    /**
     * Notes or instructions for the follow-up
     */
    @Column(name = "follow_up_notes", columnDefinition = "TEXT")
    private String followUpNotes;

    /**
     * The status of the follow-up
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private FollowUpStatus status = FollowUpStatus.SCHEDULED;

    /**
     * The doctor assigned to this follow-up
     */
    @ManyToOne
    @JoinColumn(name = "assigned_doctor_id")
    private User assignedDoctor;

    /**
     * The appointment associated with this follow-up
     */
    @OneToOne
    @JoinColumn(name = "appointment_id")
    private Appointment appointment;

    /**
     * When this follow-up record was created
     */
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    /**
     * When this follow-up record was last updated
     */
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    /**
     * The sequence number of this follow-up (1st, 2nd, 3rd, etc.)
     */
    @Column(name = "sequence_number")
    private Integer sequenceNumber;

    /**
     * Additional clinical notes from the follow-up visit
     */
    @Column(name = "clinical_notes", columnDefinition = "TEXT")
    private String clinicalNotes;

    /**
     * Whether this follow-up is the most recent one
     */
    @Column(name = "is_latest")
    private Boolean isLatest = true;

    @Transient
    private String formattedScheduledDate;
    @Transient
    private String formattedCompletedDate;

    public String getFormattedScheduledDate() { return formattedScheduledDate; }
    public void setFormattedScheduledDate(String formattedScheduledDate) { this.formattedScheduledDate = formattedScheduledDate; }
    public String getFormattedCompletedDate() { return formattedCompletedDate; }
    public void setFormattedCompletedDate(String formattedCompletedDate) { this.formattedCompletedDate = formattedCompletedDate; }

    /**
     * Mark this follow-up as completed
     */
    public void markAsCompleted() {
        this.status = FollowUpStatus.COMPLETED;
        this.completedDate = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Mark this follow-up as cancelled
     */
    public void markAsCancelled() {
        this.status = FollowUpStatus.CANCELLED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Get the follow-up number as a string (1st, 2nd, 3rd, etc.)
     */
    public String getFollowUpNumber() {
        if (sequenceNumber == null) return "Follow-up";
        
        switch (sequenceNumber) {
            case 1: return "1st Follow-up";
            case 2: return "2nd Follow-up";
            case 3: return "3rd Follow-up";
            default: return sequenceNumber + "th Follow-up";
        }
    }
} 
package com.example.logindemo.cron.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "cron_job_config_changes")
public class CronJobConfigChange {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "cron_job_id")
    private CronJob cronJob;

    @Column(nullable = false, length = 128)
    private String fieldName;

    @Column(length = 1024)
    private String oldValue;

    @Column(length = 1024)
    private String newValue;

    @Column(length = 128)
    private String changedBy;

    @Column(nullable = false)
    private LocalDateTime changedAt = LocalDateTime.now();

    @Column
    private Long rollbackOfChangeId;

    @Column(length = 512)
    private String notes;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public CronJob getCronJob() { return cronJob; }
    public void setCronJob(CronJob cronJob) { this.cronJob = cronJob; }
    public String getFieldName() { return fieldName; }
    public void setFieldName(String fieldName) { this.fieldName = fieldName; }
    public String getOldValue() { return oldValue; }
    public void setOldValue(String oldValue) { this.oldValue = oldValue; }
    public String getNewValue() { return newValue; }
    public void setNewValue(String newValue) { this.newValue = newValue; }
    public String getChangedBy() { return changedBy; }
    public void setChangedBy(String changedBy) { this.changedBy = changedBy; }
    public LocalDateTime getChangedAt() { return changedAt; }
    public void setChangedAt(LocalDateTime changedAt) { this.changedAt = changedAt; }
    public Long getRollbackOfChangeId() { return rollbackOfChangeId; }
    public void setRollbackOfChangeId(Long rollbackOfChangeId) { this.rollbackOfChangeId = rollbackOfChangeId; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
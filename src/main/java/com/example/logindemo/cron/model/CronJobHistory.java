package com.example.logindemo.cron.model;

import com.example.logindemo.cron.CronJobStatus;
import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "cron_job_history")
public class CronJobHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cron_job_id", nullable = false)
    private CronJob cronJob;

    @Enumerated(EnumType.STRING)
    @Column(length = 32, nullable = false)
    private CronJobStatus status = CronJobStatus.PENDING;

    @Column
    private LocalDateTime startTime;

    @Column
    private LocalDateTime endTime;

    @Column
    private Long durationMs;

    @Column
    private Integer retryAttempt = 0;

    @Column(length = 32)
    private String triggerType; // MANUAL or SCHEDULED

    @Column(length = 2048)
    private String errorMessage;

    @Column(length = 8192)
    private String stackTrace;

    @Column(length = 1024)
    private String resultSummary;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public CronJob getCronJob() { return cronJob; }
    public void setCronJob(CronJob cronJob) { this.cronJob = cronJob; }
    public CronJobStatus getStatus() { return status; }
    public void setStatus(CronJobStatus status) { this.status = status; }
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    public Long getDurationMs() { return durationMs; }
    public void setDurationMs(Long durationMs) { this.durationMs = durationMs; }
    public Integer getRetryAttempt() { return retryAttempt; }
    public void setRetryAttempt(Integer retryAttempt) { this.retryAttempt = retryAttempt; }
    public String getTriggerType() { return triggerType; }
    public void setTriggerType(String triggerType) { this.triggerType = triggerType; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public String getStackTrace() { return stackTrace; }
    public void setStackTrace(String stackTrace) { this.stackTrace = stackTrace; }
    public String getResultSummary() { return resultSummary; }
    public void setResultSummary(String resultSummary) { this.resultSummary = resultSummary; }
}
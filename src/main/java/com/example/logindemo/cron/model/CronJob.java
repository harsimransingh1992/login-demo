package com.example.logindemo.cron.model;

import com.example.logindemo.cron.CronJobStatus;
import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "cron_jobs")
public class CronJob {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name;

    @Column(length = 512)
    private String description;

    @Column(nullable = false)
    private String beanName;

    @Column
    private String cronExpression;

    @Column
    private boolean active = true;

    @Column
    private boolean oneTime = false;

    @Column
    private boolean paused = false;

    @Enumerated(EnumType.STRING)
    @Column(length = 32)
    private CronJobStatus lastStatus = CronJobStatus.PENDING;

    @Column
    private Integer maxRetries = 0;

    @Column
    private Integer retryDelaySeconds = 60;

    @Column
    private boolean concurrentAllowed = false;

    @Column
    private LocalDateTime lastRunStart;

    @Column
    private LocalDateTime lastRunEnd;

    @Column
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column
    private LocalDateTime updatedAt = LocalDateTime.now();

    @Column(columnDefinition = "TEXT")
    private String recipientsCsv;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getBeanName() { return beanName; }
    public void setBeanName(String beanName) { this.beanName = beanName; }
    public String getCronExpression() { return cronExpression; }
    public void setCronExpression(String cronExpression) { this.cronExpression = cronExpression; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public boolean isOneTime() { return oneTime; }
    public void setOneTime(boolean oneTime) { this.oneTime = oneTime; }
    public boolean isPaused() { return paused; }
    public void setPaused(boolean paused) { this.paused = paused; }
    public CronJobStatus getLastStatus() { return lastStatus; }
    public void setLastStatus(CronJobStatus lastStatus) { this.lastStatus = lastStatus; }
    public Integer getMaxRetries() { return maxRetries; }
    public void setMaxRetries(Integer maxRetries) { this.maxRetries = maxRetries; }
    public Integer getRetryDelaySeconds() { return retryDelaySeconds; }
    public void setRetryDelaySeconds(Integer retryDelaySeconds) { this.retryDelaySeconds = retryDelaySeconds; }
    public boolean isConcurrentAllowed() { return concurrentAllowed; }
    public void setConcurrentAllowed(boolean concurrentAllowed) { this.concurrentAllowed = concurrentAllowed; }
    public LocalDateTime getLastRunStart() { return lastRunStart; }
    public void setLastRunStart(LocalDateTime lastRunStart) { this.lastRunStart = lastRunStart; }
    public LocalDateTime getLastRunEnd() { return lastRunEnd; }
    public void setLastRunEnd(LocalDateTime lastRunEnd) { this.lastRunEnd = lastRunEnd; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public String getRecipientsCsv() { return recipientsCsv; }
    public void setRecipientsCsv(String recipientsCsv) { this.recipientsCsv = recipientsCsv; }
}
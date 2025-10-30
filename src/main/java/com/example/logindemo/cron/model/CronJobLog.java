package com.example.logindemo.cron.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "cron_job_logs")
public class CronJobLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "history_id", nullable = false)
    private CronJobHistory history;

    @Column
    private LocalDateTime timestamp = LocalDateTime.now();

    @Column(length = 16)
    private String level = "INFO"; // INFO/WARN/ERROR

    @Column(length = 2048)
    private String message;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public CronJobHistory getHistory() { return history; }
    public void setHistory(CronJobHistory history) { this.history = history; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
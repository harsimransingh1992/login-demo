package com.example.logindemo.model;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "report_triggers")
public class ReportTrigger {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String reportName;
    
    @Column(nullable = false)
    private String reportDisplayName;
    
    @Column(nullable = false)
    private String reportGeneratorBean; // Spring bean name for the report generator
    
    @Column(nullable = false)
    private String cronExpression;
    
    @Column(nullable = false, columnDefinition = "TEXT")
    private String recipients; // Comma-separated email addresses
    
    @Column(nullable = false)
    private Boolean enabled = true;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column
    private String subject; // Email subject template
    
    @Column(columnDefinition = "TEXT")
    private String emailTemplate; // Custom email template
    
    @Column(columnDefinition = "TEXT")
    private String reportParameters; // JSON string containing report parameters
    
    @Column(nullable = false)
    private String reportFormat = "PDF"; // Default format: PDF, CSV, EXCEL
    
    @ManyToOne
    @JoinColumn(name = "created_by")
    private User createdBy;
    
    @ManyToOne
    @JoinColumn(name = "updated_by")
    private User updatedBy;
    
    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    
    @Column
    private LocalDateTime lastExecuted;
    
    @Column
    private LocalDateTime nextExecution;
    
    @Enumerated(EnumType.STRING)
    @Column
    private ExecutionStatus lastExecutionStatus;
    
    @Column(columnDefinition = "TEXT")
    private String lastExecutionError;
    
    // Transient fields for JSP compatibility (Date objects for formatting)
    @Transient
    private Date nextExecutionDate;
    
    @Transient
    private Date lastExecutedDate;
    
    public enum ExecutionStatus {
        SUCCESS("Success"),
        FAILED("Failed"),
        RUNNING("Running"),
        PENDING("Pending");
        
        private final String displayName;
        
        ExecutionStatus(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
    
    // Helper methods
    public String[] getRecipientsArray() {
        if (recipients == null || recipients.trim().isEmpty()) {
            return new String[0];
        }
        return recipients.split(",");
    }
    
    public void setRecipientsFromArray(String[] recipientArray) {
        if (recipientArray == null || recipientArray.length == 0) {
            this.recipients = "";
        } else {
            this.recipients = String.join(",", recipientArray);
        }
    }
    
    public boolean isActive() {
        return enabled != null && enabled;
    }
}
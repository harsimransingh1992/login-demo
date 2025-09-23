-- Create report_triggers table for dynamic report scheduling
CREATE TABLE IF NOT EXISTS report_triggers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(100) NOT NULL UNIQUE,
    report_display_name VARCHAR(200) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    cron_expression VARCHAR(100) NOT NULL,
    recipients TEXT NOT NULL,
    description TEXT,
    subject VARCHAR(500),
    email_template TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_executed TIMESTAMP NULL,
    last_execution_status VARCHAR(20) DEFAULT 'PENDING',
    next_execution TIMESTAMP NULL,
    execution_count INT DEFAULT 0,
    failure_count INT DEFAULT 0,
    last_error_message TEXT,
    FOREIGN KEY (created_by_id) REFERENCES users(id),
    CONSTRAINT chk_report_type CHECK (report_type IN (
        'DAILY_PATIENT_REGISTRATION',
        'WEEKLY_PATIENT_SUMMARY', 
        'MONTHLY_CLINIC_PERFORMANCE',
        'APPOINTMENT_SUMMARY',
        'REVENUE_REPORT',
        'CUSTOM'
    )),
    CONSTRAINT chk_execution_status CHECK (last_execution_status IN (
        'PENDING',
        'RUNNING', 
        'SUCCESS',
        'FAILED'
    ))
);

-- Create indexes for efficient querying
CREATE INDEX idx_report_triggers_active ON report_triggers(is_active);
CREATE INDEX idx_report_triggers_type ON report_triggers(report_type);
CREATE INDEX idx_report_triggers_next_execution ON report_triggers(next_execution);
CREATE INDEX idx_report_triggers_created_by ON report_triggers(created_by_id);
CREATE INDEX idx_report_triggers_status ON report_triggers(last_execution_status);
CREATE INDEX idx_report_triggers_active_next ON report_triggers(is_active, next_execution);

-- Create report_execution_logs table for detailed execution tracking
CREATE TABLE IF NOT EXISTS report_execution_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    trigger_id BIGINT NOT NULL,
    execution_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    execution_end TIMESTAMP NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'RUNNING',
    error_message TEXT,
    report_size_bytes BIGINT,
    recipients_count INT,
    execution_duration_ms BIGINT,
    triggered_by VARCHAR(50) DEFAULT 'SCHEDULER', -- 'SCHEDULER', 'MANUAL', 'API'
    triggered_by_user_id BIGINT NULL,
    FOREIGN KEY (trigger_id) REFERENCES report_triggers(id) ON DELETE CASCADE,
    FOREIGN KEY (triggered_by_user_id) REFERENCES users(id),
    CONSTRAINT chk_execution_log_status CHECK (status IN (
        'RUNNING',
        'SUCCESS', 
        'FAILED',
        'CANCELLED'
    ))
);

-- Create indexes for execution logs
CREATE INDEX idx_execution_logs_trigger ON report_execution_logs(trigger_id);
CREATE INDEX idx_execution_logs_status ON report_execution_logs(status);
CREATE INDEX idx_execution_logs_start_time ON report_execution_logs(execution_start);
CREATE INDEX idx_execution_logs_trigger_status ON report_execution_logs(trigger_id, status);

-- Insert sample report triggers for demonstration
INSERT INTO report_triggers (
    report_name, 
    report_display_name, 
    report_type, 
    cron_expression, 
    recipients, 
    description,
    subject,
    created_by_id
) VALUES 
(
    'daily_patient_registrations',
    'Daily Patient Registrations Report',
    'DAILY_PATIENT_REGISTRATION',
    '0 0 8 * * *',
    'admin@peridesk.com',
    'Daily summary of new patient registrations',
    'Daily Patient Registration Report - {date}',
    1
),
(
    'weekly_clinic_summary',
    'Weekly Clinic Performance Summary',
    'WEEKLY_PATIENT_SUMMARY', 
    '0 0 9 * * MON',
    'admin@peridesk.com,manager@peridesk.com',
    'Weekly overview of clinic performance and patient statistics',
    'Weekly Clinic Performance Report - Week of {date}',
    1
),
(
    'monthly_revenue_report',
    'Monthly Revenue and Financial Report',
    'REVENUE_REPORT',
    '0 0 10 1 * *',
    'admin@peridesk.com,finance@peridesk.com',
    'Monthly financial performance and revenue analysis',
    'Monthly Revenue Report - {month} {year}',
    1
);

-- Add comments to document the tables
ALTER TABLE report_triggers COMMENT = 'Stores configuration for automated report generation and scheduling';
ALTER TABLE report_execution_logs COMMENT = 'Tracks execution history and performance metrics for report triggers';
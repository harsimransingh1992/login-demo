-- Create follow_up_records table for tracking multiple follow-ups
CREATE TABLE follow_up_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    examination_id BIGINT NOT NULL,
    scheduled_date DATETIME NOT NULL,
    completed_date DATETIME NULL,
    follow_up_notes TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    assigned_doctor_id BIGINT NULL,
    appointment_id BIGINT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    sequence_number INT NOT NULL,
    clinical_notes TEXT,
    is_latest BOOLEAN NOT NULL DEFAULT TRUE,
    
    FOREIGN KEY (examination_id) REFERENCES toothclinicalexamination(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_doctor_id) REFERENCES user(id) ON DELETE SET NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointment(id) ON DELETE SET NULL,
    
    INDEX idx_examination_id (examination_id),
    INDEX idx_scheduled_date (scheduled_date),
    INDEX idx_status (status),
    INDEX idx_assigned_doctor (assigned_doctor_id),
    INDEX idx_is_latest (is_latest),
    INDEX idx_sequence_number (sequence_number)
);

-- Add comment to the table
ALTER TABLE follow_up_records 
COMMENT = 'Table to track multiple follow-up appointments for dental examinations'; 
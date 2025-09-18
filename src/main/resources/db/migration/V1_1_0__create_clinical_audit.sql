-- Create clinical_audit table for tracking senior doctor audit activities
CREATE TABLE clinical_audit (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    clinical_file_id BIGINT,
    examination_id BIGINT,
    auditor_id BIGINT,
    audit_type VARCHAR(50) NOT NULL,
    quality_rating VARCHAR(50),
    audit_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    audit_notes TEXT,
    recommendations TEXT,
    audit_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (clinical_file_id) REFERENCES clinical_file(id) ON DELETE CASCADE,
    FOREIGN KEY (examination_id) REFERENCES toothclinicalexamination(id) ON DELETE CASCADE,
    FOREIGN KEY (auditor_id) REFERENCES user(id) ON DELETE SET NULL,
    
    -- Indexes for better performance
    INDEX idx_clinical_audit_file (clinical_file_id),
    INDEX idx_clinical_audit_examination (examination_id),
    INDEX idx_clinical_audit_auditor (auditor_id),
    INDEX idx_clinical_audit_date (audit_date),
    INDEX idx_clinical_audit_status (audit_status)
);

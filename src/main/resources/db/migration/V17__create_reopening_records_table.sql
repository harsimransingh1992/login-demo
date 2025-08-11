-- Create reopening_records table
CREATE TABLE reopening_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    examination_id BIGINT NOT NULL,
    reopened_by_doctor_id BIGINT NOT NULL,
    clinic_id BIGINT NOT NULL,
    reopened_at DATETIME NOT NULL,
    reopening_reason TEXT,
    notes TEXT,
    previous_status VARCHAR(50),
    new_status VARCHAR(50) DEFAULT 'REOPEN',
    patient_condition TEXT,
    treatment_plan TEXT,
    approved_by_senior BOOLEAN DEFAULT FALSE,
    approved_by_doctor_id BIGINT,
    approval_date DATETIME,
    reopening_sequence INT,
    
    FOREIGN KEY (examination_id) REFERENCES toothclinicalexamination(id) ON DELETE CASCADE,
    FOREIGN KEY (reopened_by_doctor_id) REFERENCES users(id),
    FOREIGN KEY (clinic_id) REFERENCES clinic(id),
    FOREIGN KEY (approved_by_doctor_id) REFERENCES users(id)
);

-- Create indexes for better performance
CREATE INDEX idx_reopening_examination_id ON reopening_records(examination_id);
CREATE INDEX idx_reopening_doctor_id ON reopening_records(reopened_by_doctor_id);
CREATE INDEX idx_reopening_clinic_id ON reopening_records(clinic_id);
CREATE INDEX idx_reopening_date ON reopening_records(reopened_at);
-- Create clinical_file table
CREATE TABLE clinical_file (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    clinic_id VARCHAR(255) NOT NULL,
    file_number VARCHAR(255) UNIQUE,
    title VARCHAR(500),
    status VARCHAR(50) DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    notes TEXT,
    
    FOREIGN KEY (patient_id) REFERENCES patient(id),
    FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
);

-- Add clinical_file_id column to toothclinicalexamination table
ALTER TABLE toothclinicalexamination
ADD COLUMN clinical_file_id BIGINT,
ADD CONSTRAINT fk_toothclinicalexamination_clinical_file
FOREIGN KEY (clinical_file_id) REFERENCES clinical_file(id);

-- Create indexes for better performance
CREATE INDEX idx_clinical_file_patient_id ON clinical_file(patient_id);
CREATE INDEX idx_clinical_file_clinic_id ON clinical_file(clinic_id);
CREATE INDEX idx_clinical_file_status ON clinical_file(status);
CREATE INDEX idx_clinical_file_created_at ON clinical_file(created_at);
CREATE INDEX idx_clinical_file_file_number ON clinical_file(file_number);
CREATE INDEX idx_toothclinicalexamination_clinical_file ON toothclinicalexamination(clinical_file_id);

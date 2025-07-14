-- Add audit fields to patients table
ALTER TABLE patients ADD COLUMN created_by BIGINT;
ALTER TABLE patients ADD COLUMN registered_clinic BIGINT;
ALTER TABLE patients ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add foreign key constraints
ALTER TABLE patients ADD CONSTRAINT fk_patients_created_by FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE patients ADD CONSTRAINT fk_patients_registered_clinic FOREIGN KEY (registered_clinic) REFERENCES clinic_models(id); 
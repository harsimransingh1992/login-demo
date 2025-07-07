-- Add opd_doctor_id column to toothclinicalexamination table
ALTER TABLE toothclinicalexamination
ADD COLUMN opd_doctor_id BIGINT,
ADD CONSTRAINT fk_toothclinicalexamination_opd_doctor
FOREIGN KEY (opd_doctor_id) REFERENCES users(id);
 
-- Add index for better query performance
CREATE INDEX idx_toothclinicalexamination_opd_doctor
ON toothclinicalexamination(opd_doctor_id); 
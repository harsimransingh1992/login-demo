-- Add color code column to patients table
ALTER TABLE patients ADD COLUMN color_code VARCHAR(20) DEFAULT 'NO_CODE'; 
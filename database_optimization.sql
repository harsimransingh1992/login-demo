-- Database Performance Optimization Script for PeriDesk
-- Run this script to add indexes for better query performance

-- Indexes for Patient table
CREATE INDEX IF NOT EXISTS idx_patient_checked_in ON patient(checked_in);
CREATE INDEX IF NOT EXISTS idx_patient_clinic_checked_in ON patient(checked_in, current_check_in_record_id);
CREATE INDEX IF NOT EXISTS idx_patient_registration_date ON patient(registration_date);
CREATE INDEX IF NOT EXISTS idx_patient_phone ON patient(phone_number);
CREATE INDEX IF NOT EXISTS idx_patient_name ON patient(first_name, last_name);
CREATE INDEX IF NOT EXISTS idx_patient_registration_code ON patient(registration_code);

-- Indexes for CheckInRecord table
CREATE INDEX IF NOT EXISTS idx_checkin_clinic ON check_in_record(clinic_id);
CREATE INDEX IF NOT EXISTS idx_checkin_patient ON check_in_record(patient_id);
CREATE INDEX IF NOT EXISTS idx_checkin_time ON check_in_record(check_in_time);
CREATE INDEX IF NOT EXISTS idx_checkin_clinic_time ON check_in_record(clinic_id, check_in_time);

-- Indexes for User table
CREATE INDEX IF NOT EXISTS idx_user_username ON user(username);
CREATE INDEX IF NOT EXISTS idx_user_clinic ON user(clinic_id);
CREATE INDEX IF NOT EXISTS idx_user_role ON user(role);
CREATE INDEX IF NOT EXISTS idx_user_clinic_role ON user(clinic_id, role);

-- Indexes for Appointment table (if exists)
CREATE INDEX IF NOT EXISTS idx_appointment_date ON appointment(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointment_patient ON appointment(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointment_doctor ON appointment(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointment_status ON appointment(status);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_patient_clinic_status ON patient(current_check_in_record_id, checked_in);
CREATE INDEX IF NOT EXISTS idx_checkin_patient_clinic ON check_in_record(patient_id, clinic_id);

-- Analyze tables to update statistics
ANALYZE TABLE patient;
ANALYZE TABLE check_in_record;
ANALYZE TABLE user;
ANALYZE TABLE appointment;

-- Show index usage (for monitoring)
-- SELECT 
--     TABLE_NAME,
--     INDEX_NAME,
--     CARDINALITY,
--     SUB_PART,
--     PACKED,
--     NULLABLE,
--     INDEX_TYPE
-- FROM information_schema.STATISTICS 
-- WHERE TABLE_SCHEMA = 'sdcdatab4'
-- ORDER BY TABLE_NAME, INDEX_NAME;
-- Migration to update report_triggers table for Spring bean-based reporting
-- This migration adds new columns and migrates existing data

-- Add new columns for bean-based reporting
ALTER TABLE report_triggers 
ADD COLUMN report_generator_bean VARCHAR(255),
ADD COLUMN report_parameters TEXT,
ADD COLUMN report_format VARCHAR(50) DEFAULT 'PDF';

-- Migrate existing data from report_type to report_generator_bean
UPDATE report_triggers 
SET report_generator_bean = CASE 
    WHEN report_type = 'DAILY_PATIENT_REGISTRATION' THEN 'dailyPatientRegistrationReport'
    WHEN report_type = 'WEEKLY_PATIENT_SUMMARY' THEN 'weeklyPatientSummaryReport'
    WHEN report_type = 'MONTHLY_CLINIC_PERFORMANCE' THEN 'monthlyClinicPerformanceReport'
    WHEN report_type = 'APPOINTMENT_SUMMARY' THEN 'appointmentSummaryReport'
    WHEN report_type = 'REVENUE_REPORT' THEN 'revenueReport'
    WHEN report_type = 'CUSTOM' THEN 'customReport'
    ELSE 'dailyPatientRegistrationReport'
END;

-- Set default parameters for existing reports
UPDATE report_triggers 
SET report_parameters = CASE 
    WHEN report_type = 'DAILY_PATIENT_REGISTRATION' THEN '{"includeSummary": true, "includeDetails": true}'
    WHEN report_type = 'WEEKLY_PATIENT_SUMMARY' THEN '{"includeCharts": true, "groupByDepartment": false}'
    ELSE '{}'
END;

-- Make report_generator_bean NOT NULL after data migration
ALTER TABLE report_triggers 
ALTER COLUMN report_generator_bean SET NOT NULL;

-- Drop the old report_type column (commented out for safety - uncomment after verification)
-- ALTER TABLE report_triggers DROP COLUMN report_type;

-- Add indexes for better performance
CREATE INDEX idx_report_triggers_bean ON report_triggers(report_generator_bean);
CREATE INDEX idx_report_triggers_enabled ON report_triggers(enabled);

-- Add comments for documentation
COMMENT ON COLUMN report_triggers.report_generator_bean IS 'Spring bean name for the report generator implementation';
COMMENT ON COLUMN report_triggers.report_parameters IS 'JSON string containing report-specific parameters';
COMMENT ON COLUMN report_triggers.report_format IS 'Output format for the report (PDF, CSV, EXCEL)';
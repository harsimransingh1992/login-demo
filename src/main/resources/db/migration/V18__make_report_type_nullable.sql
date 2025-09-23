-- Make report_type column nullable to fix database insertion errors
-- This allows report triggers to be created without requiring a report_type value

ALTER TABLE report_triggers 
MODIFY COLUMN report_type VARCHAR(50) NULL;

-- Update existing records to have a default value if needed
UPDATE report_triggers 
SET report_type = 'CUSTOM' 
WHERE report_type IS NULL;
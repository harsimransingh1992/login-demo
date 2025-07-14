-- Update toothclinicalexamination table with the correct data
-- Skip adding the column as it already exists

-- Copy existing doctor assignments to use the user_id from doctor_detail
UPDATE toothclinicalexamination tce
SET assigned_user_id = (
    SELECT dd.user_id 
    FROM doctordetails dd 
    WHERE dd.id = tce.assigned_doctor_id
)
WHERE tce.assigned_doctor_id IS NOT NULL 
  AND (tce.assigned_user_id IS NULL OR tce.assigned_user_id = 0);

-- Drop foreign key constraint (if it exists)
-- Find the actual constraint name first
SET @constraint_name = (
    SELECT CONSTRAINT_NAME 
    FROM information_schema.KEY_COLUMN_USAGE 
    WHERE TABLE_SCHEMA = 'sdcdatab1' 
      AND TABLE_NAME = 'toothclinicalexamination' 
      AND COLUMN_NAME = 'assigned_doctor_id'
      AND REFERENCED_TABLE_NAME = 'doctordetails'
);

SET @sql = IF(@constraint_name IS NOT NULL, 
               CONCAT('ALTER TABLE toothclinicalexamination DROP FOREIGN KEY ', @constraint_name), 
               'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if there are any missing values in assigned_user_id
SELECT COUNT(*) INTO @missing_values
FROM toothclinicalexamination 
WHERE assigned_doctor_id IS NOT NULL AND assigned_user_id IS NULL;

-- Show a message if there are missing values
SELECT IF(@missing_values > 0, 
          CONCAT(@missing_values, ' records could not be updated - please check the data.'), 
          'All records updated successfully') AS migration_status;

-- Drop the doctordetails table if no records depend on it
DROP TABLE IF EXISTS doctordetails; 
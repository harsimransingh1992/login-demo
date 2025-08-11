-- Fix MediaFile record for examination 46
-- Update the file path to match the actual file

UPDATE media_file 
SET file_path = 'dental-images/dc3de607-5eb8-45de-80e3-c15047712b1c.jpeg'
WHERE examination_id = 46 
AND file_path = 'dental-images/dc3de607-5eb8-45e3-80e3-c15047712b1c.jpeg';

-- Verify the update
SELECT * FROM media_file WHERE examination_id = 46;
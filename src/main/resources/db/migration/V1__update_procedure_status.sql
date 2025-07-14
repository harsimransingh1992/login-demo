-- Update existing WAITING status records to OPEN
UPDATE toothclinicalexamination 
SET procedure_status = 'OPEN' 
WHERE procedure_status = 'WAITING'; 
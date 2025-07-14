-- Add X-ray picture path column to toothclinicalexamination table
ALTER TABLE toothclinicalexamination 
ADD COLUMN xray_picture_path VARCHAR(500); 
-- Add upper and lower denture picture path columns to toothclinicalexamination table
ALTER TABLE toothclinicalexamination 
ADD COLUMN upper_denture_picture_path VARCHAR(500),
ADD COLUMN lower_denture_picture_path VARCHAR(500); 
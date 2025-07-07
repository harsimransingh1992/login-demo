-- Add chief complaints and advised columns to toothclinicalexamination table
ALTER TABLE toothclinicalexamination 
ADD COLUMN chief_complaints TEXT,
ADD COLUMN advised TEXT; 
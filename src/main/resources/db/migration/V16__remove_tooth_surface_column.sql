-- Remove tooth_surface column from toothclinicalexamination table
ALTER TABLE toothclinicalexamination DROP COLUMN IF EXISTS tooth_surface;
-- Change examination_notes column from VARCHAR to TEXT to support longer clinical notes
ALTER TABLE toothclinicalexamination 
MODIFY COLUMN examination_notes TEXT; 
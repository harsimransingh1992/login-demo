-- Update existing payment notes to use the enum value
UPDATE tooth_clinical_examination 
SET payment_notes = 'OTHER' 
WHERE payment_notes IS NULL OR payment_notes = '';

-- Add a check constraint to ensure only valid enum values are used
ALTER TABLE tooth_clinical_examination 
ADD CONSTRAINT chk_payment_notes 
CHECK (payment_notes IN ('FULL_PAYMENT', 'PARTIAL_PAYMENT', 'ADVANCE_PAYMENT', 'REFUND', 'ADJUSTMENT', 'OTHER')); 
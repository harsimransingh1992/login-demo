-- Add referral_model column to patients table
ALTER TABLE patients ADD COLUMN IF NOT EXISTS referral_model VARCHAR(50);

-- Add constraint to ensure only valid enum values are stored
ALTER TABLE patients ADD CONSTRAINT IF NOT EXISTS chk_referral_model 
CHECK (referral_model IN ('REFERRAL', 'SEARCH', 'SOCIAL', 'WALK_IN', 'OTHER'));

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_patients_referral_model ON patients(referral_model); 
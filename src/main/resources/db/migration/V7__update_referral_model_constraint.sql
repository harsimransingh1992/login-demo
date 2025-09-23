-- Drop the existing constraint (MySQL syntax)
ALTER TABLE patients DROP CHECK chk_referral_model;

-- Add updated constraint to include all ReferralModel enum values
ALTER TABLE patients ADD CONSTRAINT chk_referral_model
CHECK (referral_model IN (
    'REFERRAL',
    'SEARCH',
    'SOCIAL',
    'WALK_IN',
    'OTHER',
    'GOOGLE',
    'WORD_OF_MOUTH',
    'PRM',
    'BNI',
    'STAFF_REFERENCE',
    'SHARK_TANK',
    'BIKRAM_REFERENCE'
));
-- Add transaction_type column to payment_entry table
-- Following banking/payment processor patterns like CyberSource

ALTER TABLE payment_entry 
ADD COLUMN transaction_type VARCHAR(20) NOT NULL DEFAULT 'CAPTURE';

-- Update existing records based on payment_notes
-- Set REFUND for existing refund entries
UPDATE payment_entry 
SET transaction_type = 'REFUND' 
WHERE payment_notes = 'REFUND';

-- Set CAPTURE for all other entries (payments)
UPDATE payment_entry 
SET transaction_type = 'CAPTURE' 
WHERE payment_notes != 'REFUND' OR payment_notes IS NULL;

-- Add index for better query performance
CREATE INDEX idx_payment_entry_transaction_type ON payment_entry(transaction_type);

-- Add comment to document the column
ALTER TABLE payment_entry 
MODIFY COLUMN transaction_type VARCHAR(20) NOT NULL DEFAULT 'CAPTURE' 
COMMENT 'Transaction type: CAPTURE (payment received), REFUND (money returned), AUTHORIZATION, VOID';
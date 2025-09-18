-- Add refund-specific fields to PaymentEntry table
ALTER TABLE payment_entry ADD COLUMN refund_type ENUM('FULL', 'PARTIAL') NULL;
ALTER TABLE payment_entry ADD COLUMN original_payment_id BIGINT NULL;
ALTER TABLE payment_entry ADD COLUMN refund_reason VARCHAR(500) NULL;
ALTER TABLE payment_entry ADD COLUMN refund_approved_by BIGINT NULL;
ALTER TABLE payment_entry ADD COLUMN refund_approval_date DATETIME NULL;

-- Add foreign key constraints
ALTER TABLE payment_entry ADD CONSTRAINT fk_original_payment 
    FOREIGN KEY (original_payment_id) REFERENCES payment_entry(id);
ALTER TABLE payment_entry ADD CONSTRAINT fk_refund_approved_by 
    FOREIGN KEY (refund_approved_by) REFERENCES users(id);

-- Add index for better performance
CREATE INDEX idx_payment_entry_refund_type ON payment_entry(refund_type);
CREATE INDEX idx_payment_entry_original_payment ON payment_entry(original_payment_id);
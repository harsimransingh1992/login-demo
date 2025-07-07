-- Add new dental professional fields to users table
ALTER TABLE users ADD COLUMN specialization VARCHAR(100);
ALTER TABLE users ADD COLUMN license_number VARCHAR(50);
ALTER TABLE users ADD COLUMN license_expiry_date DATE;
ALTER TABLE users ADD COLUMN qualification VARCHAR(100);
ALTER TABLE users ADD COLUMN designation VARCHAR(100);
ALTER TABLE users ADD COLUMN joining_date DATE;
ALTER TABLE users ADD COLUMN emergency_contact VARCHAR(50);
ALTER TABLE users ADD COLUMN address VARCHAR(255);
ALTER TABLE users ADD COLUMN bio VARCHAR(1000);
ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- Add comment
COMMENT ON TABLE users IS 'This table stores dental professionals information including dentists, staff, and administrators'; 
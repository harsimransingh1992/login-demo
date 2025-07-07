-- Initial schema for the database

-- Create clinics table
CREATE TABLE IF NOT EXISTS clinics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'STAFF',
    clinic_id BIGINT,
    FOREIGN KEY (clinic_id) REFERENCES clinics(id)
);

-- Create an index for username searches
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Establish the owned clinic relationship
ALTER TABLE clinics ADD COLUMN IF NOT EXISTS owner_id BIGINT;
ALTER TABLE clinics ADD CONSTRAINT IF NOT EXISTS fk_clinics_owner FOREIGN KEY (owner_id) REFERENCES users(id); 
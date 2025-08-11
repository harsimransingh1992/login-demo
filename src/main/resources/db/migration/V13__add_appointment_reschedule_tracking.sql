-- Add reschedule tracking fields to appointments table
ALTER TABLE appointments ADD COLUMN original_appointment_date_time DATETIME;
ALTER TABLE appointments ADD COLUMN rescheduled_count INT DEFAULT 0;
ALTER TABLE appointments ADD COLUMN last_rescheduled_by_id BIGINT;
ALTER TABLE appointments ADD COLUMN last_rescheduled_at DATETIME;
ALTER TABLE appointments ADD COLUMN reschedule_reason VARCHAR(500);

-- Create appointment_history table to track ALL changes
CREATE TABLE appointment_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    appointment_id BIGINT NOT NULL,
    action VARCHAR(50) NOT NULL, -- 'CREATED', 'RESCHEDULED', 'CANCELLED', 'STATUS_CHANGED'
    old_value VARCHAR(500),
    new_value VARCHAR(500),
    changed_by_id BIGINT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes VARCHAR(1000),
    reschedule_number INT DEFAULT 0, -- Track which reschedule this is (1st, 2nd, 3rd, etc.)
    FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    FOREIGN KEY (changed_by_id) REFERENCES users(id)
);

-- Create indexes for efficient querying
CREATE INDEX idx_appointment_history_appointment_id ON appointment_history(appointment_id);
CREATE INDEX idx_appointment_history_action ON appointment_history(action);
CREATE INDEX idx_appointment_history_reschedule_number ON appointment_history(reschedule_number); 
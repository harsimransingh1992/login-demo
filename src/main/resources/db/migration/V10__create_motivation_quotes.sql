-- Create motivation quotes table
CREATE TABLE motivation_quotes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    quote_text TEXT NOT NULL,
    author VARCHAR(255),
    category VARCHAR(100) DEFAULT 'GENERAL',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert some initial motivation quotes
INSERT INTO motivation_quotes (quote_text, author, category) VALUES
('Every patient is a unique story, and you have the power to change their narrative for the better.', 'Dental Professional', 'PATIENT_CARE'),
('The best doctor is the one who treats the patient, not just the disease.', 'Unknown', 'PATIENT_CARE'),
('Your hands have the power to heal, your words have the power to comfort, and your presence has the power to inspire hope.', 'Medical Professional', 'INSPIRATION'),
('Excellence in dentistry is not a skill, it''s an attitude.', 'Dental Professional', 'EXCELLENCE'),
('The greatest medicine of all is teaching people how not to need it.', 'Hippocrates', 'PREVENTION'),
('Success is not final, failure is not fatal: it is the courage to continue that counts.', 'Winston Churchill', 'PERSEVERANCE'),
('The art of medicine consists of amusing the patient while nature cures the disease.', 'Voltaire', 'PATIENT_CARE'),
('Your dedication to healing makes the world a better place, one smile at a time.', 'Dental Professional', 'INSPIRATION'),
('In the midst of difficulty lies opportunity.', 'Albert Einstein', 'PERSEVERANCE'),
('The only way to do great work is to love what you do.', 'Steve Jobs', 'PASSION'),
('Every expert was once a beginner. Keep learning, keep growing.', 'Unknown', 'GROWTH'),
('The difference between ordinary and extraordinary is that little extra.', 'Jimmy Johnson', 'EXCELLENCE'),
('Your commitment to excellence in patient care sets the standard for others to follow.', 'Dental Professional', 'EXCELLENCE'),
('Healing is an art. It takes time, it takes practice, it takes love.', 'Maza Dohta', 'PATIENT_CARE'),
('The best way to predict the future is to create it.', 'Peter Drucker', 'INNOVATION'); 
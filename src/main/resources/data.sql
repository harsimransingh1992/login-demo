-- Delete existing users to avoid conflicts
DELETE FROM users WHERE username IN ('admin', 'adminperidesk');

-- Check if admin user exists, if not create it
INSERT INTO users (username, password, first_name, last_name, role, is_active)
SELECT 'admin', '$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', 'Admin', 'User', 'ADMIN', true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin'); 
-- Delete existing users to avoid conflicts
DELETE FROM users WHERE username IN ('admin', 'adminperidesk');

-- Check if admin user exists, if not create it
INSERT INTO users (username, password, city_tier)
SELECT 'admin', 'admin', 'TIER1'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin'); 
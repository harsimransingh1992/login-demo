-- Script to enable cross-clinic access for users and assign all clinics
-- This script will:
-- 1. Set hasCrossClinicApptAccess = true for all users (or specific users)
-- 2. Assign all available clinics to users in the user_accessible_clinics table

-- ============================================================================
-- PART 1: Update hasCrossClinicApptAccess flag for users
-- ============================================================================

-- Option 1: Enable cross-clinic access for ALL users
UPDATE users 
SET has_cross_clinic_appt_access = true;

-- Option 2: Enable cross-clinic access for specific roles only (uncomment if needed)
-- UPDATE users 
-- SET has_cross_clinic_appt_access = true 
-- WHERE role IN ('RECEPTIONIST', 'ADMIN', 'MODERATOR', 'DOCTOR', 'OPD_DOCTOR');

-- Option 3: Enable cross-clinic access for specific users by username (uncomment if needed)
-- UPDATE users 
-- SET has_cross_clinic_appt_access = true 
-- WHERE username IN ('user1', 'user2', 'user3');

-- ============================================================================
-- PART 2: Assign all clinics to all users in user_accessible_clinics table
-- ============================================================================

-- Clear existing accessible clinic assignments (optional - uncomment if you want to start fresh)
-- DELETE FROM user_accessible_clinics;

-- Insert all clinic-user combinations into user_accessible_clinics
-- This creates a cross-join between all users and all clinics
INSERT INTO user_accessible_clinics (user_id, clinic_id)
SELECT u.id, c.id
FROM users u
CROSS JOIN clinics c
WHERE NOT EXISTS (
    SELECT 1 
    FROM user_accessible_clinics uac 
    WHERE uac.user_id = u.id AND uac.clinic_id = c.id
);

-- ============================================================================
-- VERIFICATION QUERIES (run these to check the results)
-- ============================================================================

-- Check users with cross-clinic access enabled
SELECT id, username, first_name, last_name, role, has_cross_clinic_appt_access
FROM users 
WHERE has_cross_clinic_appt_access = true;

-- Check clinic assignments per user
SELECT 
    u.username,
    u.first_name,
    u.last_name,
    COUNT(uac.clinic_id) as accessible_clinics_count
FROM users u
LEFT JOIN user_accessible_clinics uac ON u.id = uac.user_id
WHERE u.has_cross_clinic_appt_access = true
GROUP BY u.id, u.username, u.first_name, u.last_name
ORDER BY u.username;

-- Check detailed clinic assignments
SELECT 
    u.username,
    u.first_name,
    u.last_name,
    c.clinic_name,
    c.clinic_id
FROM users u
JOIN user_accessible_clinics uac ON u.id = uac.user_id
JOIN clinics c ON uac.clinic_id = c.id
WHERE u.has_cross_clinic_appt_access = true
ORDER BY u.username, c.clinic_name;

-- Check total counts
SELECT 
    (SELECT COUNT(*) FROM users WHERE has_cross_clinic_appt_access = true) as users_with_access,
    (SELECT COUNT(*) FROM clinics) as total_clinics,
    (SELECT COUNT(*) FROM user_accessible_clinics) as total_assignments;
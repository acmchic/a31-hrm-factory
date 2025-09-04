-- Script to convert email column to username column in users table
-- This script will:
-- 1. Extract username part from email (remove @quandoi.local)
-- 2. Rename email column to username

-- Step 1: Update email data to extract username part only
UPDATE users 
SET email = SUBSTRING_INDEX(email, '@', 1) 
WHERE email LIKE '%@%';

-- Step 2: Rename email column to username
ALTER TABLE users CHANGE COLUMN email username VARCHAR(255) UNIQUE;

-- Optional: Show the result
SELECT id, name, username FROM users LIMIT 10;

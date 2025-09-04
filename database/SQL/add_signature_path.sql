-- Add signature_path column to users table
ALTER TABLE users ADD COLUMN signature_path VARCHAR(255) NULL AFTER profile_photo_path;

-- Show result
DESCRIBE users;

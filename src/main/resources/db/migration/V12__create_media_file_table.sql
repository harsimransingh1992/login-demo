-- Create media_file table for storing multiple images per examination
CREATE TABLE media_file (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    examination_id BIGINT,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(32),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mediafile_examination
        FOREIGN KEY (examination_id)
        REFERENCES toothclinicalexamination(id)
        ON DELETE CASCADE
);

-- Optional: Migrate existing single-image data
INSERT INTO media_file (examination_id, file_path, file_type)
SELECT id, xray_picture_path, 'xray'
FROM toothclinicalexamination
WHERE xray_picture_path IS NOT NULL AND xray_picture_path <> '';

-- (Optional) Remove the old column after migration is verified:
-- ALTER TABLE toothclinicalexamination DROP COLUMN xray_picture_path; 
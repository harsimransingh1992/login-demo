CREATE TABLE procedure_lifecycle_transitions (
    id BIGSERIAL PRIMARY KEY,
    examination_id BIGINT NOT NULL,
    stage_name VARCHAR(255) NOT NULL,
    stage_description TEXT NOT NULL,
    transition_time TIMESTAMP NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    transitioned_by BIGINT,
    stage_details TEXT,
    FOREIGN KEY (examination_id) REFERENCES tooth_clinical_examinations(id),
    FOREIGN KEY (transitioned_by) REFERENCES users(id)
); 
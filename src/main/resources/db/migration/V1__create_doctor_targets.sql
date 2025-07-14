CREATE TABLE doctor_targets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    city_tier VARCHAR(20) NOT NULL,
    monthly_revenue_target DECIMAL(10,2) NOT NULL,
    monthly_patient_target INT NOT NULL,
    monthly_procedure_target INT NOT NULL,
    description VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE
);

-- Insert default targets for each tier
INSERT INTO doctor_targets (city_tier, monthly_revenue_target, monthly_patient_target, monthly_procedure_target, description) VALUES
('TIER1', 500000.00, 100, 150, 'Tier 1 cities - High volume targets'),
('TIER2', 300000.00, 75, 100, 'Tier 2 cities - Medium volume targets'),
('TIER3', 200000.00, 50, 75, 'Tier 3 cities - Standard volume targets'); 
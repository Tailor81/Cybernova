CREATE TABLE IF NOT EXISTS service_request (
    request_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone_number VARCHAR(20),
    organisation_name VARCHAR(150),
    country VARCHAR(100) NOT NULL,
    job_title VARCHAR(100),
    industry_sector VARCHAR(100),
    service_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin (
    admin_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS rating (
    rating_id SERIAL PRIMARY KEY,
    request_id INTEGER REFERENCES service_request(request_id) ON DELETE SET NULL,
    customer_name VARCHAR(100) NOT NULL,
    rating_value INTEGER NOT NULL CHECK (rating_value >= 1 AND rating_value <= 5),
    comment TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_request_type ON service_request(service_type);
CREATE INDEX IF NOT EXISTS idx_request_country ON service_request(country);
CREATE INDEX IF NOT EXISTS idx_request_status ON service_request(status);
CREATE INDEX IF NOT EXISTS idx_rating_request ON rating(request_id);

INSERT INTO rating (customer_name, rating_value, comment) VALUES
('Sarah Mitchell', 5, 'CyberNova transformed our security infrastructure. Their AI-driven approach detected threats we did not know existed.'),
('James Okoro', 4, 'Excellent penetration testing service. The team was thorough and professional throughout the engagement.'),
('Fatima Al-Rashid', 5, 'The network security audit revealed critical vulnerabilities. Their recommendations were practical and effective.'),
('David Chen', 5, 'Outstanding incident response. They contained the breach within hours and helped us recover with zero data loss.'),
('Naledi Moyo', 4, 'The cyber awareness training workshops were engaging and transformed how our staff handles security threats.');

-- ============================================================
-- CyberNova PostgreSQL Schema
-- ============================================================

-- Admin accounts (no FK dependencies, created first)
CREATE TABLE IF NOT EXISTS admin (
    admin_id      SERIAL PRIMARY KEY,
    username      VARCHAR(50)  UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL
);

-- Client service enquiries
CREATE TABLE IF NOT EXISTS service_request (
    request_id        SERIAL PRIMARY KEY,
    full_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(150) NOT NULL,
    phone_number      VARCHAR(20),
    organisation_name VARCHAR(150),
    country           VARCHAR(100) NOT NULL,
    job_title         VARCHAR(100),
    industry_sector   VARCHAR(100),
    service_type      VARCHAR(100) NOT NULL,
    description       TEXT         NOT NULL,
    status            VARCHAR(20)  NOT NULL DEFAULT 'pending'
                          CHECK (status IN ('pending', 'in-progress', 'completed', 'rejected')),
    submission_date   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Customer ratings / testimonials (optionally linked to a service request)
CREATE TABLE IF NOT EXISTS rating (
    rating_id     SERIAL PRIMARY KEY,
    request_id    INTEGER REFERENCES service_request(request_id) ON DELETE SET NULL,
    customer_name VARCHAR(100) NOT NULL,
    rating_value  INTEGER      NOT NULL CHECK (rating_value BETWEEN 1 AND 5),
    comment       TEXT,
    created_date  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Webinar events
CREATE TABLE IF NOT EXISTS webinar (
    webinar_id   SERIAL PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    webinar_date DATE         NOT NULL,
    webinar_time VARCHAR(10)  NOT NULL,
    platform     VARCHAR(100),
    speaker      VARCHAR(150),
    created_date TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Attendee registrations for webinars
CREATE TABLE IF NOT EXISTS webinar_registration (
    registration_id   SERIAL PRIMARY KEY,
    webinar_id        INTEGER      NOT NULL REFERENCES webinar(webinar_id) ON DELETE CASCADE,
    full_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(150) NOT NULL,
    organisation      VARCHAR(150),
    phone             VARCHAR(20),
    registration_date TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (webinar_id, email)
);

-- Downloadable resources / files
CREATE TABLE IF NOT EXISTS resource (
    resource_id   SERIAL PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    description   TEXT,
    category      VARCHAR(100),
    file_name     VARCHAR(255) NOT NULL,
    file_type     VARCHAR(100),
    file_size     BIGINT       NOT NULL DEFAULT 0,
    file_data     BYTEA        NOT NULL,
    uploaded_date TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- Indexes
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_request_status   ON service_request(status);
CREATE INDEX IF NOT EXISTS idx_request_type     ON service_request(service_type);
CREATE INDEX IF NOT EXISTS idx_request_country  ON service_request(country);
CREATE INDEX IF NOT EXISTS idx_rating_request   ON rating(request_id);
CREATE INDEX IF NOT EXISTS idx_webinar_date     ON webinar(webinar_date);
CREATE INDEX IF NOT EXISTS idx_reg_webinar      ON webinar_registration(webinar_id);
CREATE INDEX IF NOT EXISTS idx_resource_cat     ON resource(category);

-- ============================================================
-- Seed data
-- ============================================================
INSERT INTO rating (customer_name, rating_value, comment) VALUES
('Sarah Mitchell',  5, 'CyberNova transformed our security infrastructure. Their AI-driven approach detected threats we did not know existed.'),
('James Okoro',     4, 'Excellent penetration testing service. The team was thorough and professional throughout the engagement.'),
('Fatima Al-Rashid',5, 'The network security audit revealed critical vulnerabilities. Their recommendations were practical and effective.'),
('David Chen',      5, 'Outstanding incident response. They contained the breach within hours and helped us recover with zero data loss.'),
('Naledi Moyo',     4, 'The cyber awareness training workshops were engaging and transformed how our staff handles security threats.');

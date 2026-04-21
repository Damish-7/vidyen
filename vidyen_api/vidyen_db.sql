-- ============================================================
-- VIDYEN Conference Portal — Database Schema + Seed Data
-- Run this in MAMP phpMyAdmin or MySQL client
-- ============================================================

CREATE DATABASE IF NOT EXISTS vidyen_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE vidyen_db;

-- ── Users ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    username      VARCHAR(80)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    designation   VARCHAR(150),
    institution   VARCHAR(200),
    avatar        VARCHAR(255),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ── Abstracts ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS abstracts (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title             VARCHAR(300) NOT NULL,
    authors           VARCHAR(300) NOT NULL,
    institution       VARCHAR(200) NOT NULL,
    category          VARCHAR(100) NOT NULL,
    abstract_text     TEXT NOT NULL,
    presentation_type ENUM('oral','poster') DEFAULT 'oral',
    status            ENUM('pending','accepted','rejected') DEFAULT 'pending',
    submitted_by      INT UNSIGNED,
    submitted_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submitted_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ── Pre-Conference Sessions ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS preconf_sessions (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    speaker          VARCHAR(150) NOT NULL,
    designation      VARCHAR(150),
    description      TEXT,
    session_date     DATE NOT NULL,
    session_time     VARCHAR(50),
    venue            VARCHAR(200),
    max_participants INT DEFAULT 50,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS preconf_registrations (
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id INT UNSIGNED NOT NULL,
    user_id    INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_reg (session_id, user_id),
    FOREIGN KEY (session_id) REFERENCES preconf_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)    REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ── Workshops ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS workshops (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    facilitator      VARCHAR(150) NOT NULL,
    designation      VARCHAR(150),
    description      TEXT,
    workshop_date    DATE NOT NULL,
    workshop_time    VARCHAR(50),
    duration         VARCHAR(50),
    venue            VARCHAR(200),
    topics           JSON,
    max_participants INT DEFAULT 30,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS workshop_registrations (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    workshop_id INT UNSIGNED NOT NULL,
    user_id     INT UNSIGNED NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_ws_reg (workshop_id, user_id),
    FOREIGN KEY (workshop_id) REFERENCES workshops(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)     REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ── Certificates ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS certificates (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id          INT UNSIGNED NOT NULL,
    type             ENUM('participation','presenter','workshop','preconf') NOT NULL,
    title            VARCHAR(200) NOT NULL,
    event_name       VARCHAR(200) NOT NULL,
    issued_at        DATE NOT NULL,
    certificate_code VARCHAR(100) NOT NULL UNIQUE,
    is_downloaded    TINYINT(1) DEFAULT 0,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Users (password = "password123" hashed with bcrypt)
INSERT INTO users (name, email, username, password_hash, designation, institution) VALUES
('Dr. Arjun Sharma',  'arjun.sharma@manipal.edu',  'arjunsharma',
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password
 'Associate Professor', 'Manipal Academy of Higher Education'),
('Dr. Priya Nair',    'priya.nair@aims.edu',        'priyanair',
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
 'Senior Researcher', 'AIIMS New Delhi'),
('Prof. Rahul Menon', 'rahul.menon@iit.ac.in',      'rahulmenon',
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
 'Professor', 'IIT Bombay');

-- Abstracts
INSERT INTO abstracts (title, authors, institution, category, abstract_text, presentation_type, status, submitted_by) VALUES
('Artificial Intelligence in Early Cancer Detection: A Systematic Review',
 'Sharma A., Nair P., Kumar R.', 'Manipal Academy of Higher Education', 'Oncology',
 'This systematic review evaluates the effectiveness of AI-based diagnostic tools in early-stage cancer detection across multiple organ systems. A meta-analysis of 42 randomized controlled trials showed AI models achieving sensitivity of 94.2% and specificity of 91.7%, outperforming traditional screening methods by 18.3%. The review highlights gaps in dataset diversity and regulatory considerations for clinical deployment.',
 'oral', 'accepted', 1),

('Gut Microbiome Dysbiosis and Its Association with Type 2 Diabetes Mellitus',
 'Nair P., Shetty K., Verma S.', 'AIIMS New Delhi', 'Endocrinology',
 'A prospective cohort study of 340 patients examined microbiome composition changes preceding T2DM onset. Significant reduction in Faecalibacterium prausnitzii (p<0.001) and elevated Ruminococcus gnavus were observed 12 months prior to clinical diagnosis. These findings suggest microbiome profiling as a viable early biomarker for diabetes prediction.',
 'poster', 'accepted', 2),

('Neuroplasticity-Based Rehabilitation in Post-Stroke Motor Recovery',
 'Menon R., Das A., Pillai S.', 'IIT Bombay', 'Neurology',
 'This randomized controlled trial assessed constraint-induced movement therapy (CIMT) combined with transcranial magnetic stimulation in 85 post-stroke patients. The intervention group showed 43% greater upper limb motor function improvement at 6-month follow-up.',
 'oral', 'pending', 3),

('Telemedicine Adoption in Rural India: Barriers and Facilitators',
 'Krishnan V., Patel M., Joshi A.', 'CMC Vellore', 'Digital Health',
 'A mixed-methods study exploring telemedicine utilization patterns across 12 rural districts in Karnataka and Maharashtra. Quantitative survey (n=1,200) and qualitative interviews (n=48) revealed connectivity infrastructure and digital literacy as primary barriers.',
 'poster', 'accepted', 1),

('CRISPR-Cas9 Gene Editing in Sickle Cell Disease: Phase II Trial Results',
 'Reddy S., Iyer N., Bhatt P.', 'NIMHANS Bangalore', 'Haematology',
 'Phase II trial of autologous CRISPR-edited HSCs in 22 patients with severe sickle cell disease. At 18-month follow-up, 19/22 patients achieved transfusion independence with haemoglobin F levels >30%.',
 'oral', 'rejected', 2);

-- Pre-Conference Sessions
INSERT INTO preconf_sessions (title, speaker, designation, description, session_date, session_time, venue, max_participants) VALUES
('Research Methodology & Biostatistics Masterclass',
 'Prof. Anitha Krishnamurthy', 'Head of Biostatistics, AIIMS Delhi',
 'A comprehensive full-day masterclass covering study design, sample size calculation, statistical analysis using SPSS/R, and interpretation of research outputs. Ideal for residents and early-career researchers.',
 '2025-03-14', '09:00 AM – 05:00 PM', 'Conference Hall A, Ground Floor', 60),

('Grant Writing for Medical Research',
 'Dr. Suresh Babu', 'Principal Investigator, ICMR',
 'Learn how to structure compelling research proposals, navigate funding agency requirements, and write budgets that get approved. Real grant reviews and feedback sessions included.',
 '2025-03-14', '09:00 AM – 01:00 PM', 'Seminar Room B, First Floor', 40),

('Systematic Review & Meta-Analysis Workshop',
 'Dr. Meena Rajan', 'Cochrane Review Author, CMC Vellore',
 'Step-by-step guidance on conducting systematic reviews using PRISMA guidelines, RevMan software for meta-analysis, heterogeneity assessment, and publication bias detection.',
 '2025-03-14', '02:00 PM – 06:00 PM', 'Seminar Room B, First Floor', 35);

-- Pre-conf registrations (user 1 registered for session 1)
INSERT INTO preconf_registrations (session_id, user_id) VALUES (1, 1), (2, 2);

-- Workshops
INSERT INTO workshops (title, facilitator, designation, description, workshop_date, workshop_time, duration, venue, topics, max_participants) VALUES
('Advanced Laparoscopic Surgical Techniques',
 'Dr. Rajesh Pillai', 'Senior Surgeon, Amrita Institute',
 'Hands-on simulation workshop using box trainers and cadaveric models. Participants will practice intracorporeal suturing, knot tying, and laparoscopic cholecystectomy steps under expert supervision.',
 '2025-03-15', '08:00 AM', '4 hours', 'Simulation Lab, Second Floor',
 '["Box trainer exercises","Intracorporeal suturing","Knot tying techniques","Laparoscopic cholecystectomy steps","Complication management"]', 20),

('Point-of-Care Ultrasound (POCUS) for Clinicians',
 'Dr. Divya Gopalan', 'Emergency Medicine Specialist, KMC Manipal',
 'Introductory and intermediate POCUS training covering FAST exam, lung ultrasound, cardiac windows, and vascular access guidance. Each participant gets dedicated probe time.',
 '2025-03-15', '09:00 AM', '3 hours', 'Skills Lab, Ground Floor',
 '["FAST examination protocol","Lung ultrasound basics","Cardiac windows","Vascular access guidance","Image optimization"]', 24),

('Medical Writing & Journal Publication',
 'Dr. Kavitha Srinivasan', 'Associate Editor, Indian Journal of Medical Research',
 'A practical workshop on writing original research articles, case reports, and review papers. Topics include journal selection, peer review process, and avoiding common rejection pitfalls.',
 '2025-03-15', '02:00 PM', '3 hours', 'Conference Hall B, Ground Floor',
 '["Structuring your manuscript (IMRaD)","Choosing the right journal","Understanding the peer review process","Responding to reviewer comments","Ethical considerations in publication"]', 50);

-- Workshop registrations (user 1 in workshop 1)
INSERT INTO workshop_registrations (workshop_id, user_id) VALUES (1, 1), (2, 2);

-- Certificates for user 1
INSERT INTO certificates (user_id, type, title, event_name, issued_at, certificate_code) VALUES
(1, 'participation', 'Certificate of Participation',    'VIDYEN Annual Conference 2025', '2025-03-17', 'VID-2025-PART-0317-001'),
(1, 'presenter',     'Certificate of Presentation',     'VIDYEN Annual Conference 2025', '2025-03-16', 'VID-2025-PRES-0316-001'),
(1, 'workshop',      'Workshop Completion Certificate',  'Advanced Laparoscopic Surgical Techniques', '2025-03-15', 'VID-2025-WS-0315-001');

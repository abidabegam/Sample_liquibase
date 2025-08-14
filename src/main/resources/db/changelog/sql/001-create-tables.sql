-- Department Table
CREATE TABLE IF NOT EXISTS department (
  department_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

-- Users Table
CREATE TABLE IF NOT EXISTS users (
  user_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  role VARCHAR(50) NOT NULL CHECK (role IN ('ADMIN','EMPLOYEE','HR')),
  department_id INTEGER REFERENCES department(department_id) ON DELETE SET NULL
);

-- Job Table
CREATE TABLE IF NOT EXISTS job (
  job_id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  location VARCHAR(100),
  department_id INTEGER REFERENCES department(department_id) ON DELETE SET NULL,
  posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Job Application Table
CREATE TABLE IF NOT EXISTS job_application (
  job_application_id SERIAL PRIMARY KEY,
  job_id INTEGER NOT NULL REFERENCES job(job_id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  resume TEXT,
  cover_letter TEXT,
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Helpful Indexes
CREATE INDEX IF NOT EXISTS idx_users_department ON users(department_id);
CREATE INDEX IF NOT EXISTS idx_job_department   ON job(department_id);
CREATE INDEX IF NOT EXISTS idx_jobapp_job       ON job_application(job_id);
CREATE INDEX IF NOT EXISTS idx_jobapp_user      ON job_application(user_id);

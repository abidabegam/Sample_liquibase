-- Insert Departments
INSERT INTO department (name) VALUES
  ('Engineering'),
  ('HR')
ON CONFLICT (name) DO NOTHING;

-- Insert Users
INSERT INTO users (first_name, last_name, email, role, department_id) VALUES
  ('Abida', 'Mohammad', 'abida@example.com', 'EMPLOYEE', 1),
  ('Amaan', 'Mohammad', 'amaan@example.com', 'ADMIN', 2)
ON CONFLICT (email) DO NOTHING;

-- Insert Jobs
INSERT INTO job (title, description, location, department_id) VALUES
  ('Python Developer', 'Looking for API developer', 'Remote', 1),
  ('HR Manager', 'Responsible for handling hiring and onboarding', 'Michigan', 2);

-- Insert Job Applications (will only work if the above IDs exist)
INSERT INTO job_application (job_id, user_id, resume, cover_letter) VALUES
  (1, 1, 'resume_abida.pdf', 'Excited to join as a backend developer'),
  (2, 2, 'resume_amaan.pdf', 'Looking forward to contributing to HR');

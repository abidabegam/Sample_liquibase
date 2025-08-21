INSERT INTO team (team_name) VALUES
  ('Platform'),
  ('Apps'),
  ('QA')
ON CONFLICT DO NOTHING;

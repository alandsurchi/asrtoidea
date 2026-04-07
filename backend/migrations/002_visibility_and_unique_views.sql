-- Add public/private visibility flags and per-user unique entity views.

ALTER TABLE ideas
  ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT TRUE;

ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT TRUE;

UPDATE ideas
SET is_public = TRUE
WHERE is_public IS NULL;

UPDATE projects
SET is_public = TRUE
WHERE is_public IS NULL;

CREATE TABLE IF NOT EXISTS entity_views (
  entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('idea', 'project')),
  entity_id UUID NOT NULL,
  viewer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  viewed_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (entity_type, entity_id, viewer_user_id)
);

CREATE INDEX IF NOT EXISTS idx_entity_views_entity
  ON entity_views(entity_type, entity_id);

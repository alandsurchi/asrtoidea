-- ===================================================================
-- AI Idea Generator — Detail View + Threaded Comments
-- ===================================================================

-- Add detail-oriented fields for ideas
ALTER TABLE ideas
  ADD COLUMN IF NOT EXISTS full_content TEXT,
  ADD COLUMN IF NOT EXISTS attachments JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS like_count INTEGER DEFAULT 0;

-- Add detail-oriented fields for projects
ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS full_content TEXT,
  ADD COLUMN IF NOT EXISTS attachments JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS like_count INTEGER DEFAULT 0;

-- Threaded comments for both ideas and projects
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS entity_comments (
  id UUID PRIMARY KEY,
  entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('idea', 'project')),
  entity_id UUID NOT NULL,
  parent_comment_id UUID REFERENCES entity_comments(id) ON DELETE CASCADE,
  author_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  edited_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_entity_comments_entity
  ON entity_comments(entity_type, entity_id, created_at);
CREATE INDEX IF NOT EXISTS idx_entity_comments_parent
  ON entity_comments(parent_comment_id);

-- Per-comment like relation (one like per user)
CREATE TABLE IF NOT EXISTS entity_comment_likes (
  comment_id UUID NOT NULL REFERENCES entity_comments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (comment_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_entity_comment_likes_comment
  ON entity_comment_likes(comment_id);

-- One-time backfill: move legacy project comments JSON into normalized table.
INSERT INTO entity_comments (
  id,
  entity_type,
  entity_id,
  parent_comment_id,
  author_user_id,
  content
)
SELECT
  gen_random_uuid(),
  'project',
  p.id,
  NULL,
  p.user_id,
  legacy_comment.value
FROM projects p
CROSS JOIN LATERAL jsonb_array_elements_text(COALESCE(p.comments, '[]'::jsonb)) AS legacy_comment(value)
WHERE legacy_comment.value IS NOT NULL
  AND btrim(legacy_comment.value) <> ''
  AND NOT EXISTS (
    SELECT 1
    FROM entity_comments c
    WHERE c.entity_type = 'project'
      AND c.entity_id = p.id
  );

-- Per-entity like relation used by detail action bar
CREATE TABLE IF NOT EXISTS entity_likes (
  entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('idea', 'project')),
  entity_id UUID NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (entity_type, entity_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_entity_likes_entity
  ON entity_likes(entity_type, entity_id);

-- Link Home ideas and Explore projects generated from the same publish flow.

ALTER TABLE ideas
  ADD COLUMN IF NOT EXISTS linked_project_id UUID REFERENCES projects(id) ON DELETE SET NULL;

ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS linked_idea_id UUID REFERENCES ideas(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_ideas_linked_project_id
  ON ideas(linked_project_id);

CREATE INDEX IF NOT EXISTS idx_projects_linked_idea_id
  ON projects(linked_idea_id);

-- Backfill high-confidence historical pairs so older publishes can share one detail thread.
WITH ranked_pairs AS (
  SELECT
    i.id AS idea_id,
    p.id AS project_id,
    ABS(EXTRACT(EPOCH FROM (i.created_at - p.created_at))) AS seconds_delta,
    ROW_NUMBER() OVER (
      PARTITION BY i.id
      ORDER BY ABS(EXTRACT(EPOCH FROM (i.created_at - p.created_at))) ASC
    ) AS idea_rank,
    ROW_NUMBER() OVER (
      PARTITION BY p.id
      ORDER BY ABS(EXTRACT(EPOCH FROM (i.created_at - p.created_at))) ASC
    ) AS project_rank
  FROM ideas i
  JOIN projects p
    ON p.user_id = i.user_id
   AND COALESCE(NULLIF(BTRIM(i.title), ''), '') = COALESCE(NULLIF(BTRIM(p.title), ''), '')
   AND COALESCE(NULLIF(BTRIM(i.full_content), ''), '') = COALESCE(NULLIF(BTRIM(p.full_content), ''), '')
  WHERE i.linked_project_id IS NULL
    AND p.linked_idea_id IS NULL
    AND ABS(EXTRACT(EPOCH FROM (i.created_at - p.created_at))) <= 180
),
matched_pairs AS (
  SELECT idea_id, project_id
  FROM ranked_pairs
  WHERE idea_rank = 1
    AND project_rank = 1
)
UPDATE ideas i
SET linked_project_id = m.project_id,
    updated_at = NOW()
FROM matched_pairs m
WHERE i.id = m.idea_id
  AND i.linked_project_id IS NULL;

UPDATE projects p
SET linked_idea_id = i.id,
    updated_at = NOW()
FROM ideas i
WHERE p.id = i.linked_project_id
  AND p.linked_idea_id IS NULL;

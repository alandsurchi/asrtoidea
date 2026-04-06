-- ===================================================================
-- AI Idea Generator — Database Schema
-- Run this in Railway's Postgres "Query" tab or via `npm run migrate`
-- ===================================================================

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id            UUID PRIMARY KEY,
  name          VARCHAR(255) NOT NULL,
  email         VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  profile_image_path VARCHAR(500),
  nick_name     VARCHAR(255),
  phone         VARCHAR(50),
  address       VARCHAR(500),
  job           VARCHAR(255),
  created_at    TIMESTAMP DEFAULT NOW(),
  updated_at    TIMESTAMP DEFAULT NOW()
);

-- Projects table
CREATE TABLE IF NOT EXISTS projects (
  id               UUID PRIMARY KEY,
  title            VARCHAR(255),
  description      TEXT,
  background_image VARCHAR(500),
  primary_chip     VARCHAR(100),
  priority_chip    VARCHAR(100),
  avatar_images    JSONB DEFAULT '[]',
  team_count       INTEGER DEFAULT 0,
  status_text      VARCHAR(100),
  status_icon      VARCHAR(100),
  action_icon      VARCHAR(100),
  is_saved         BOOLEAN DEFAULT FALSE,
  comments         JSONB DEFAULT '[]',
  user_id          UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at       TIMESTAMP DEFAULT NOW(),
  updated_at       TIMESTAMP DEFAULT NOW()
);

-- Ideas table
CREATE TABLE IF NOT EXISTS ideas (
  id                       UUID PRIMARY KEY,
  title                    VARCHAR(255),
  description              TEXT,
  category                 VARCHAR(100),
  priority                 VARCHAR(100),
  status                   VARCHAR(100) DEFAULT 'Draft',
  background_image         VARCHAR(500),
  team_members             JSONB DEFAULT '[]',
  additional_members_count VARCHAR(50),
  user_id                  UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at               TIMESTAMP DEFAULT NOW(),
  updated_at               TIMESTAMP DEFAULT NOW()
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON projects(user_id);
CREATE INDEX IF NOT EXISTS idx_ideas_user_id ON ideas(user_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { query } = require('../db');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ─── GET /api/v1/projects ───────────────────────────────────────────────────
// Supports pagination: ?page=1&limit=20
router.get('/', authenticate, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const countResult = await query('SELECT COUNT(*) FROM projects');
    const totalItems = parseInt(countResult.rows[0].count);
    const totalPages = Math.ceil(totalItems / limit);

    const result = await query(
      `SELECT p.*, u.id AS author_id, COALESCE(u.nick_name, u.name) AS author_name
       FROM projects p
       LEFT JOIN users u ON u.id = p.user_id
       ORDER BY p.created_at DESC
       LIMIT $1 OFFSET $2`,
      [limit, offset]
    );

    const projects = result.rows.map(mapProjectRow);

    res.json({
      success: true,
      data: projects,
      current_page: page,
      total_pages: totalPages,
      total_items: totalItems,
    });
  } catch (err) {
    next(err);
  }
});

// ─── GET /api/v1/projects/:id ───────────────────────────────────────────────
router.get('/:id', authenticate, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT p.*, u.id AS author_id, COALESCE(u.nick_name, u.name) AS author_name
       FROM projects p
       LEFT JOIN users u ON u.id = p.user_id
       WHERE p.id = $1`,
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    res.json({
      success: true,
      data: mapProjectRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── POST /api/v1/projects ──────────────────────────────────────────────────
router.post('/', authenticate, async (req, res, next) => {
  try {
    const {
      title, description, backgroundImage, primaryChip,
      priorityChip, avatarImages, teamCount, statusText,
      statusIcon, actionIcon,
    } = req.body;

    const id = uuidv4();

    const result = await query(
      `INSERT INTO projects
        (id, title, description, background_image, primary_chip, priority_chip,
         avatar_images, team_count, status_text, status_icon, action_icon, user_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
       RETURNING *`,
      [id, title, description, backgroundImage, primaryChip, priorityChip,
       JSON.stringify(avatarImages || []), teamCount || 0, statusText,
       statusIcon, actionIcon, req.user.id]
    );

    res.status(201).json({
      success: true,
      message: 'Project created.',
      data: mapProjectRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── PUT /api/v1/projects/:id/save ──────────────────────────────────────────
router.put('/:id/save', authenticate, async (req, res, next) => {
  try {
    const { isSaved } = req.body;

    const result = await query(
      `UPDATE projects SET is_saved = $1, updated_at = NOW()
       WHERE id = $2 AND user_id = $3
       RETURNING *`,
      [isSaved, req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    res.json({
      success: true,
      message: isSaved ? 'Project saved.' : 'Project unsaved.',
      data: mapProjectRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── POST /api/v1/projects/:id/comments ─────────────────────────────────────
router.post('/:id/comments', authenticate, async (req, res, next) => {
  try {
    const { comment } = req.body;

    if (!comment || !comment.trim()) {
      return res.status(400).json({
        success: false,
        message: 'Comment cannot be empty.',
      });
    }

    // Append comment to the JSON array
    const result = await query(
      `UPDATE projects
       SET comments = comments || $1::jsonb,
           updated_at = NOW()
       WHERE id = $2 AND user_id = $3
       RETURNING *`,
      [JSON.stringify([comment.trim()]), req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    res.json({
      success: true,
      message: 'Comment added.',
      data: mapProjectRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── DELETE /api/v1/projects/:id ────────────────────────────────────────────
router.delete('/:id', authenticate, async (req, res, next) => {
  try {
    const result = await query(
      'DELETE FROM projects WHERE id = $1 AND user_id = $2 RETURNING id',
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    res.json({ success: true, message: 'Project deleted.' });
  } catch (err) {
    next(err);
  }
});

// ─── Helper: Map DB row → API JSON ─────────────────────────────────────────
function mapProjectRow(row) {
  return {
    id: row.id,
    createdById: row.author_id || row.user_id,
    createdByName: row.author_name || null,
    title: row.title,
    description: row.description,
    backgroundImage: row.background_image,
    primaryChip: row.primary_chip,
    priorityChip: row.priority_chip,
    avatarImages: typeof row.avatar_images === 'string'
      ? JSON.parse(row.avatar_images)
      : row.avatar_images || [],
    teamCount: row.team_count,
    statusText: row.status_text,
    statusIcon: row.status_icon,
    actionIcon: row.action_icon,
    isSaved: row.is_saved,
    comments: typeof row.comments === 'string'
      ? JSON.parse(row.comments)
      : row.comments || [],
  };
}

module.exports = router;

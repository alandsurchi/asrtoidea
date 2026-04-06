const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { query } = require('../db');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ─── GET /api/v1/ideas ──────────────────────────────────────────────────────
// Supports pagination: ?page=1&limit=20
router.get('/', authenticate, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const countResult = await query(
      'SELECT COUNT(*) FROM ideas WHERE user_id = $1',
      [req.user.id]
    );
    const totalItems = parseInt(countResult.rows[0].count);
    const totalPages = Math.ceil(totalItems / limit);

    const result = await query(
      `SELECT * FROM ideas
       WHERE user_id = $1
       ORDER BY created_at DESC
       LIMIT $2 OFFSET $3`,
      [req.user.id, limit, offset]
    );

    const ideas = result.rows.map(mapIdeaRow);

    res.json({
      success: true,
      data: ideas,
      current_page: page,
      total_pages: totalPages,
      total_items: totalItems,
    });
  } catch (err) {
    next(err);
  }
});

// ─── GET /api/v1/ideas/:id ──────────────────────────────────────────────────
router.get('/:id', authenticate, async (req, res, next) => {
  try {
    const result = await query(
      'SELECT * FROM ideas WHERE id = $1 AND user_id = $2',
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    res.json({
      success: true,
      data: mapIdeaRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── POST /api/v1/ideas ─────────────────────────────────────────────────────
router.post('/', authenticate, async (req, res, next) => {
  try {
    const {
      title, description, category, priority, status,
      backgroundImage, teamMembers, additionalMembersCount,
    } = req.body;

    const id = uuidv4();

    const result = await query(
      `INSERT INTO ideas
        (id, title, description, category, priority, status,
         background_image, team_members, additional_members_count, user_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
       RETURNING *`,
      [id, title, description, category, priority, status || 'Draft',
       backgroundImage, JSON.stringify(teamMembers || []),
       additionalMembersCount, req.user.id]
    );

    res.status(201).json({
      success: true,
      message: 'Idea created.',
      data: mapIdeaRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── PUT /api/v1/ideas/:id ──────────────────────────────────────────────────
router.put('/:id', authenticate, async (req, res, next) => {
  try {
    const {
      title, description, category, priority, status,
      backgroundImage, teamMembers, additionalMembersCount,
    } = req.body;

    const result = await query(
      `UPDATE ideas SET
        title = COALESCE($1, title),
        description = COALESCE($2, description),
        category = COALESCE($3, category),
        priority = COALESCE($4, priority),
        status = COALESCE($5, status),
        background_image = COALESCE($6, background_image),
        team_members = COALESCE($7, team_members),
        additional_members_count = COALESCE($8, additional_members_count),
        updated_at = NOW()
       WHERE id = $9 AND user_id = $10
       RETURNING *`,
      [title, description, category, priority, status,
       backgroundImage, teamMembers ? JSON.stringify(teamMembers) : null,
       additionalMembersCount, req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    res.json({
      success: true,
      message: 'Idea updated.',
      data: mapIdeaRow(result.rows[0]),
    });
  } catch (err) {
    next(err);
  }
});

// ─── DELETE /api/v1/ideas/:id ───────────────────────────────────────────────
router.delete('/:id', authenticate, async (req, res, next) => {
  try {
    const result = await query(
      'DELETE FROM ideas WHERE id = $1 AND user_id = $2 RETURNING id',
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    res.json({ success: true, message: 'Idea deleted.' });
  } catch (err) {
    next(err);
  }
});

// ─── Helper: Map DB row → API JSON ─────────────────────────────────────────
function mapIdeaRow(row) {
  let teamMembers = [];
  try {
    teamMembers = typeof row.team_members === 'string'
      ? JSON.parse(row.team_members)
      : row.team_members || [];
  } catch (e) {
    teamMembers = [];
  }

  return {
    id: row.id,
    title: row.title,
    description: row.description,
    category: row.category,
    priority: row.priority,
    status: row.status,
    backgroundImage: row.background_image,
    teamMembers,
    additionalMembersCount: row.additional_members_count,
    timestamp: row.created_at ? row.created_at.toISOString() : null,
  };
}

module.exports = router;

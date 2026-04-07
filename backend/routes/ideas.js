const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { query } = require('../db');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

router.get('/', authenticate, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 20;
    const offset = (page - 1) * limit;

    const countResult = await query(
      'SELECT COUNT(*) FROM ideas WHERE user_id = $1',
      [req.user.id]
    );
    const totalItems = parseInt(countResult.rows[0].count, 10);
    const totalPages = Math.ceil(totalItems / limit);

    const result = await query(
      `SELECT i.*, u.id AS author_id, COALESCE(u.nick_name, u.name) AS author_name,
              u.profile_image_path AS author_avatar
       FROM ideas i
       LEFT JOIN users u ON u.id = i.user_id
       WHERE i.user_id = $1
       ORDER BY i.created_at DESC
       LIMIT $2 OFFSET $3`,
      [req.user.id, limit, offset]
    );

    const ideas = result.rows.map((row) => mapIdeaRow(row, req.user.id));

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

router.get('/:id/detail', authenticate, async (req, res, next) => {
  try {
    const ideaId = req.params.id;

    const idea = await fetchIdeaById({
      ideaId,
      currentUserId: req.user.id,
      incrementView: true,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    const comments = await fetchThreadedComments({
      entityType: 'idea',
      entityId: ideaId,
      currentUserId: req.user.id,
      canEditComments: idea.user_id === req.user.id,
    });

    res.json({
      success: true,
      data: {
        ...mapIdeaRow(idea, req.user.id),
        entityType: 'idea',
        comments,
      },
    });
  } catch (err) {
    next(err);
  }
});

router.get('/:id/comments', authenticate, async (req, res, next) => {
  try {
    const idea = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    const comments = await fetchThreadedComments({
      entityType: 'idea',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: idea.user_id === req.user.id,
    });

    res.json({ success: true, data: comments });
  } catch (err) {
    next(err);
  }
});

router.post('/:id/comments', authenticate, async (req, res, next) => {
  try {
    const idea = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    const content = (req.body.content || req.body.comment || '').trim();
    const parentCommentId = (req.body.parentCommentId || '').trim() || null;

    if (!content) {
      return res.status(400).json({
        success: false,
        message: 'Comment cannot be empty.',
      });
    }

    if (content.length > 4000) {
      return res.status(400).json({
        success: false,
        message: 'Comment is too long.',
      });
    }

    if (parentCommentId) {
      const parentResult = await query(
        `SELECT id FROM entity_comments
         WHERE id = $1 AND entity_type = 'idea' AND entity_id = $2`,
        [parentCommentId, req.params.id]
      );

      if (parentResult.rows.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Parent comment not found.',
        });
      }
    }

    const commentId = uuidv4();
    await query(
      `INSERT INTO entity_comments
        (id, entity_type, entity_id, parent_comment_id, author_user_id, content)
       VALUES ($1, 'idea', $2, $3, $4, $5)`,
      [commentId, req.params.id, parentCommentId, req.user.id, content]
    );

    const comments = await fetchThreadedComments({
      entityType: 'idea',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: idea.user_id === req.user.id,
    });

    res.status(201).json({
      success: true,
      message: 'Comment added.',
      data: comments,
    });
  } catch (err) {
    next(err);
  }
});

router.put('/:id/comments/:commentId', authenticate, async (req, res, next) => {
  try {
    const idea = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    if (idea.user_id !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Only the idea owner can edit comments on this idea.',
      });
    }

    const content = (req.body.content || '').trim();
    if (!content) {
      return res.status(400).json({
        success: false,
        message: 'Comment cannot be empty.',
      });
    }

    if (content.length > 4000) {
      return res.status(400).json({
        success: false,
        message: 'Comment is too long.',
      });
    }

    const updated = await query(
      `UPDATE entity_comments
       SET content = $1, edited_at = NOW(), updated_at = NOW()
       WHERE id = $2 AND entity_type = 'idea' AND entity_id = $3
       RETURNING id`,
      [content, req.params.commentId, req.params.id]
    );

    if (updated.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Comment not found.',
      });
    }

    const comments = await fetchThreadedComments({
      entityType: 'idea',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: true,
    });

    res.json({
      success: true,
      message: 'Comment updated.',
      data: comments,
    });
  } catch (err) {
    next(err);
  }
});

router.put('/:id/comments/:commentId/like', authenticate, async (req, res, next) => {
  try {
    const idea = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    const commentResult = await query(
      `SELECT id FROM entity_comments
       WHERE id = $1 AND entity_type = 'idea' AND entity_id = $2`,
      [req.params.commentId, req.params.id]
    );

    if (commentResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Comment not found.',
      });
    }

    const isLiked = req.body.isLiked !== false;

    if (isLiked) {
      await query(
        `INSERT INTO entity_comment_likes (comment_id, user_id)
         VALUES ($1, $2)
         ON CONFLICT (comment_id, user_id) DO NOTHING`,
        [req.params.commentId, req.user.id]
      );
    } else {
      await query(
        `DELETE FROM entity_comment_likes
         WHERE comment_id = $1 AND user_id = $2`,
        [req.params.commentId, req.user.id]
      );
    }

    const comments = await fetchThreadedComments({
      entityType: 'idea',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: idea.user_id === req.user.id,
    });

    res.json({ success: true, data: comments });
  } catch (err) {
    next(err);
  }
});

router.put('/:id/like', authenticate, async (req, res, next) => {
  try {
    const idea = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    const isLiked = req.body.isLiked !== false;

    if (isLiked) {
      await query(
        `INSERT INTO entity_likes (entity_type, entity_id, user_id)
         VALUES ('idea', $1, $2)
         ON CONFLICT (entity_type, entity_id, user_id) DO NOTHING`,
        [req.params.id, req.user.id]
      );
    } else {
      await query(
        `DELETE FROM entity_likes
         WHERE entity_type = 'idea' AND entity_id = $1 AND user_id = $2`,
        [req.params.id, req.user.id]
      );
    }

    await syncIdeaLikeCount(req.params.id);

    const refreshed = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    res.json({
      success: true,
      data: {
        likeCount: Number(refreshed.like_count_total || refreshed.like_count || 0),
        isLiked: refreshed.liked_by_me === true,
      },
    });
  } catch (err) {
    next(err);
  }
});

router.get('/:id', authenticate, async (req, res, next) => {
  try {
    const idea = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!idea) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    res.json({
      success: true,
      data: mapIdeaRow(idea, req.user.id),
    });
  } catch (err) {
    next(err);
  }
});

router.post('/', authenticate, async (req, res, next) => {
  try {
    const {
      title,
      description,
      category,
      priority,
      status,
      backgroundImage,
      teamMembers,
      additionalMembersCount,
      fullContent,
      attachments,
      viewCount,
      likeCount,
      isPublic,
    } = req.body;

    const id = uuidv4();

    await query(
      `INSERT INTO ideas
        (id, title, description, category, priority, status,
         background_image, team_members, additional_members_count, full_content,
         attachments, view_count, like_count, is_public, user_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15)`,
      [
        id,
        title,
        description,
        category,
        priority,
        status || 'Draft',
        backgroundImage,
        JSON.stringify(teamMembers || []),
        additionalMembersCount,
        fullContent || '',
        JSON.stringify(attachments || []),
        Number.isFinite(viewCount) ? viewCount : 0,
        Number.isFinite(likeCount) ? likeCount : 0,
        isPublic !== false,
        req.user.id,
      ]
    );

    const created = await fetchIdeaById({
      ideaId: id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    res.status(201).json({
      success: true,
      message: 'Idea created.',
      data: mapIdeaRow(created, req.user.id),
    });
  } catch (err) {
    next(err);
  }
});

router.put('/:id', authenticate, async (req, res, next) => {
  try {
    const {
      title,
      description,
      category,
      priority,
      status,
      backgroundImage,
      teamMembers,
      additionalMembersCount,
      fullContent,
      attachments,
      viewCount,
      likeCount,
      isPublic,
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
        full_content = COALESCE($9, full_content),
        attachments = COALESCE($10, attachments),
        view_count = COALESCE($11, view_count),
        like_count = COALESCE($12, like_count),
        is_public = COALESCE($13, is_public),
        updated_at = NOW()
       WHERE id = $14 AND user_id = $15
       RETURNING id`,
      [
        title,
        description,
        category,
        priority,
        status,
        backgroundImage,
        teamMembers ? JSON.stringify(teamMembers) : null,
        additionalMembersCount,
        fullContent,
        attachments ? JSON.stringify(attachments) : null,
        Number.isFinite(viewCount) ? viewCount : null,
        Number.isFinite(likeCount) ? likeCount : null,
        typeof isPublic === 'boolean' ? isPublic : null,
        req.params.id,
        req.user.id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Idea not found.',
      });
    }

    const updated = await fetchIdeaById({
      ideaId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    res.json({
      success: true,
      message: 'Idea updated.',
      data: mapIdeaRow(updated, req.user.id),
    });
  } catch (err) {
    next(err);
  }
});

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

async function fetchIdeaById({ ideaId, currentUserId, incrementView }) {
  const result = await query(
    `SELECT i.*, u.id AS author_id, COALESCE(u.nick_name, u.name) AS author_name,
            u.profile_image_path AS author_avatar,
            COUNT(el.user_id)::int AS like_count_total,
            BOOL_OR(el.user_id = $3) AS liked_by_me
     FROM ideas i
     LEFT JOIN users u ON u.id = i.user_id
     LEFT JOIN entity_likes el ON el.entity_type = 'idea' AND el.entity_id = i.id
     WHERE i.id = $1
       AND (i.user_id = $2 OR COALESCE(i.is_public, TRUE) = TRUE)
     GROUP BY i.id, u.id, u.nick_name, u.name, u.profile_image_path`,
    [ideaId, currentUserId, currentUserId]
  );

  const row = result.rows[0] || null;
  if (!row) return null;

  if (incrementView && row.user_id !== currentUserId) {
    const viewInsert = await query(
      `INSERT INTO entity_views (entity_type, entity_id, viewer_user_id)
       VALUES ('idea', $1, $2)
       ON CONFLICT (entity_type, entity_id, viewer_user_id) DO NOTHING
       RETURNING viewer_user_id`,
      [ideaId, currentUserId]
    );

    if (viewInsert.rows.length > 0) {
      await query(
        `UPDATE ideas
         SET view_count = COALESCE(view_count, 0) + 1,
             updated_at = NOW()
         WHERE id = $1`,
        [ideaId]
      );
      row.view_count = Number(row.view_count || 0) + 1;
    }
  }

  return row;
}

async function fetchThreadedComments({
  entityType,
  entityId,
  currentUserId,
  canEditComments,
}) {
  const rowsResult = await query(
    `SELECT c.id, c.parent_comment_id, c.author_user_id, c.content, c.edited_at,
            c.created_at, c.updated_at,
            COALESCE(u.nick_name, u.name) AS author_name,
            u.profile_image_path AS author_avatar,
            COUNT(l.user_id)::int AS likes,
            BOOL_OR(l.user_id = $3) AS is_liked
     FROM entity_comments c
     LEFT JOIN users u ON u.id = c.author_user_id
     LEFT JOIN entity_comment_likes l ON l.comment_id = c.id
     WHERE c.entity_type = $1 AND c.entity_id = $2
     GROUP BY c.id, c.parent_comment_id, c.author_user_id, c.content, c.edited_at,
              c.created_at, c.updated_at, u.nick_name, u.name, u.profile_image_path
     ORDER BY c.created_at ASC`,
    [entityType, entityId, currentUserId]
  );

  const map = new Map();
  for (const row of rowsResult.rows) {
    map.set(row.id, mapCommentRow(row, canEditComments));
  }

  const tree = [];
  for (const row of rowsResult.rows) {
    const current = map.get(row.id);
    const parentId = row.parent_comment_id;

    if (parentId && map.has(parentId)) {
      map.get(parentId).replies.push(current);
    } else {
      tree.push(current);
    }
  }

  return tree;
}

async function syncIdeaLikeCount(ideaId) {
  const likeCountResult = await query(
    `SELECT COUNT(*)::int AS like_count
     FROM entity_likes
     WHERE entity_type = 'idea' AND entity_id = $1`,
    [ideaId]
  );

  const likeCount = Number(likeCountResult.rows[0]?.like_count || 0);
  await query('UPDATE ideas SET like_count = $1 WHERE id = $2', [likeCount, ideaId]);
}

function mapCommentRow(row, canEditComments) {
  return {
    id: row.id,
    authorName: row.author_name || 'Unknown',
    authorAvatar: row.author_avatar || '',
    content: row.content || '',
    timeAgo: formatTimeAgo(row.created_at),
    likes: Number(row.likes || 0),
    isLiked: row.is_liked === true,
    canEdit: canEditComments,
    editedAt: row.edited_at ? row.edited_at.toISOString() : null,
    createdAt: row.created_at ? row.created_at.toISOString() : null,
    replies: [],
  };
}

function mapIdeaRow(row, currentUserId) {
  return {
    id: row.id,
    title: row.title,
    description: row.description,
    category: row.category,
    priority: row.priority,
    status: row.status,
    backgroundImage: row.background_image,
    teamMembers: safeJsonParse(row.team_members, []),
    additionalMembersCount: row.additional_members_count,
    timestamp: row.created_at ? row.created_at.toISOString() : null,
    createdDate: row.created_at ? row.created_at.toISOString() : null,
    fullContent: row.full_content || '',
    attachments: safeJsonParse(row.attachments, []),
    viewCount: Number(row.view_count || 0),
    likeCount: Number(row.like_count_total || row.like_count || 0),
    isLiked: row.liked_by_me === true,
    isPublic: row.is_public !== false,
    createdById: row.author_id || row.user_id,
    createdByName: row.author_name || null,
    createdByAvatar: row.author_avatar || null,
    canEdit: row.user_id === currentUserId,
  };
}

function safeJsonParse(value, fallback) {
  if (value == null) return fallback;
  if (Array.isArray(value)) return value;

  try {
    return JSON.parse(value);
  } catch (_) {
    return fallback;
  }
}

function formatTimeAgo(dateValue) {
  const date = dateValue instanceof Date ? dateValue : new Date(dateValue);
  if (Number.isNaN(date.getTime())) return 'Just now';

  const seconds = Math.max(1, Math.floor((Date.now() - date.getTime()) / 1000));
  if (seconds < 60) return 'Just now';

  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;

  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;

  const days = Math.floor(hours / 24);
  if (days < 30) return `${days}d ago`;

  const months = Math.floor(days / 30);
  if (months < 12) return `${months}mo ago`;

  const years = Math.floor(months / 12);
  return `${years}y ago`;
}

module.exports = router;

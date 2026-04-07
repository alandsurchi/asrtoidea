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
      `SELECT COUNT(*)
       FROM projects
       WHERE user_id = $1 OR COALESCE(is_public, TRUE) = TRUE`,
      [req.user.id]
    );
    const totalItems = parseInt(countResult.rows[0].count, 10);
    const totalPages = Math.ceil(totalItems / limit);

    const result = await query(
      `SELECT p.*, u.id AS author_id, COALESCE(u.nick_name, u.name) AS author_name,
              u.profile_image_path AS author_avatar
       FROM projects p
       LEFT JOIN users u ON u.id = p.user_id
       WHERE p.user_id = $1 OR COALESCE(p.is_public, TRUE) = TRUE
       ORDER BY p.created_at DESC
       LIMIT $2 OFFSET $3`,
      [req.user.id, limit, offset]
    );

    const projects = result.rows.map((row) => mapProjectRow(row, req.user.id));

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

router.get('/:id/detail', authenticate, async (req, res, next) => {
  try {
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: true,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    const comments = await fetchThreadedComments({
      entityType: 'project',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: project.user_id === req.user.id,
    });

    res.json({
      success: true,
      data: {
        ...mapProjectRow(project, req.user.id),
        entityType: 'project',
        comments,
      },
    });
  } catch (err) {
    next(err);
  }
});

router.get('/:id/comments', authenticate, async (req, res, next) => {
  try {
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    const comments = await fetchThreadedComments({
      entityType: 'project',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: project.user_id === req.user.id,
    });

    res.json({ success: true, data: comments });
  } catch (err) {
    next(err);
  }
});

router.post('/:id/comments', authenticate, async (req, res, next) => {
  try {
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
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
         WHERE id = $1 AND entity_type = 'project' AND entity_id = $2`,
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
       VALUES ($1, 'project', $2, $3, $4, $5)`,
      [commentId, req.params.id, parentCommentId, req.user.id, content]
    );

    await query(
      `UPDATE projects
       SET comments = comments || $1::jsonb,
           updated_at = NOW()
       WHERE id = $2`,
      [JSON.stringify([content]), req.params.id]
    );

    const comments = await fetchThreadedComments({
      entityType: 'project',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: project.user_id === req.user.id,
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
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    if (project.user_id !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Only the project owner can edit comments on this project.',
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
       WHERE id = $2 AND entity_type = 'project' AND entity_id = $3
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
      entityType: 'project',
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
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    const commentResult = await query(
      `SELECT id FROM entity_comments
       WHERE id = $1 AND entity_type = 'project' AND entity_id = $2`,
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
      entityType: 'project',
      entityId: req.params.id,
      currentUserId: req.user.id,
      canEditComments: project.user_id === req.user.id,
    });

    res.json({ success: true, data: comments });
  } catch (err) {
    next(err);
  }
});

router.put('/:id/like', authenticate, async (req, res, next) => {
  try {
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    const isLiked = req.body.isLiked !== false;

    if (isLiked) {
      await query(
        `INSERT INTO entity_likes (entity_type, entity_id, user_id)
         VALUES ('project', $1, $2)
         ON CONFLICT (entity_type, entity_id, user_id) DO NOTHING`,
        [req.params.id, req.user.id]
      );
    } else {
      await query(
        `DELETE FROM entity_likes
         WHERE entity_type = 'project' AND entity_id = $1 AND user_id = $2`,
        [req.params.id, req.user.id]
      );
    }

    await syncProjectLikeCount(req.params.id);

    const refreshed = await fetchProjectById({
      projectId: req.params.id,
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
    const project = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    res.json({ success: true, data: mapProjectRow(project, req.user.id) });
  } catch (err) {
    next(err);
  }
});

router.post('/', authenticate, async (req, res, next) => {
  try {
    const {
      title,
      description,
      backgroundImage,
      primaryChip,
      priorityChip,
      avatarImages,
      teamCount,
      statusText,
      statusIcon,
      actionIcon,
      fullContent,
      attachments,
      viewCount,
      likeCount,
      isPublic,
      linkedIdeaId,
    } = req.body;

    const id = uuidv4();
    const normalizedLinkedIdeaId =
      typeof linkedIdeaId === 'string' && linkedIdeaId.trim()
        ? linkedIdeaId.trim()
        : null;

    await query(
      `INSERT INTO projects
        (id, title, description, background_image, primary_chip, priority_chip,
         avatar_images, team_count, status_text, status_icon, action_icon,
         full_content, attachments, view_count, like_count, is_public, linked_idea_id, user_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18)`,
      [
        id,
        title,
        description,
        backgroundImage,
        primaryChip,
        priorityChip,
        JSON.stringify(avatarImages || []),
        teamCount || 0,
        statusText,
        statusIcon,
        actionIcon,
        fullContent || '',
        JSON.stringify(attachments || []),
        Number.isFinite(viewCount) ? viewCount : 0,
        Number.isFinite(likeCount) ? likeCount : 0,
        isPublic !== false,
        normalizedLinkedIdeaId,
        req.user.id,
      ]
    );

    const created = await fetchProjectById({
      projectId: id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    res.status(201).json({
      success: true,
      message: 'Project created.',
      data: mapProjectRow(created, req.user.id),
    });
  } catch (err) {
    next(err);
  }
});

router.put('/:id/save', authenticate, async (req, res, next) => {
  try {
    const { isSaved } = req.body;

    const result = await query(
      `UPDATE projects SET is_saved = $1, updated_at = NOW()
       WHERE id = $2 AND user_id = $3
       RETURNING id`,
      [isSaved, req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    const updated = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    res.json({
      success: true,
      message: isSaved ? 'Project saved.' : 'Project unsaved.',
      data: mapProjectRow(updated, req.user.id),
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
      backgroundImage,
      primaryChip,
      priorityChip,
      avatarImages,
      teamCount,
      statusText,
      statusIcon,
      actionIcon,
      isSaved,
      fullContent,
      attachments,
      viewCount,
      likeCount,
      isPublic,
      linkedIdeaId,
    } = req.body;

    const normalizedLinkedIdeaId =
      typeof linkedIdeaId === 'string' && linkedIdeaId.trim()
        ? linkedIdeaId.trim()
        : null;

    const result = await query(
      `UPDATE projects SET
        title = COALESCE($1, title),
        description = COALESCE($2, description),
        background_image = COALESCE($3, background_image),
        primary_chip = COALESCE($4, primary_chip),
        priority_chip = COALESCE($5, priority_chip),
        avatar_images = COALESCE($6, avatar_images),
        team_count = COALESCE($7, team_count),
        status_text = COALESCE($8, status_text),
        status_icon = COALESCE($9, status_icon),
        action_icon = COALESCE($10, action_icon),
        is_saved = COALESCE($11, is_saved),
        full_content = COALESCE($12, full_content),
        attachments = COALESCE($13, attachments),
        view_count = COALESCE($14, view_count),
        like_count = COALESCE($15, like_count),
        is_public = COALESCE($16, is_public),
        linked_idea_id = COALESCE($17, linked_idea_id),
        updated_at = NOW()
       WHERE id = $18 AND user_id = $19
       RETURNING id`,
      [
        title,
        description,
        backgroundImage,
        primaryChip,
        priorityChip,
        avatarImages ? JSON.stringify(avatarImages) : null,
        teamCount,
        statusText,
        statusIcon,
        actionIcon,
        isSaved,
        fullContent,
        attachments ? JSON.stringify(attachments) : null,
        Number.isFinite(viewCount) ? viewCount : null,
        Number.isFinite(likeCount) ? likeCount : null,
        typeof isPublic === 'boolean' ? isPublic : null,
        normalizedLinkedIdeaId,
        req.params.id,
        req.user.id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Project not found.',
      });
    }

    const updated = await fetchProjectById({
      projectId: req.params.id,
      currentUserId: req.user.id,
      incrementView: false,
    });

    res.json({
      success: true,
      message: 'Project updated.',
      data: mapProjectRow(updated, req.user.id),
    });
  } catch (err) {
    next(err);
  }
});

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

async function fetchProjectById({ projectId, currentUserId, incrementView }) {
  const result = await query(
    `SELECT p.*, u.id AS author_id, COALESCE(u.nick_name, u.name) AS author_name,
            u.profile_image_path AS author_avatar,
            COUNT(el.user_id)::int AS like_count_total,
            BOOL_OR(el.user_id = $2) AS liked_by_me
     FROM projects p
     LEFT JOIN users u ON u.id = p.user_id
     LEFT JOIN entity_likes el ON el.entity_type = 'project' AND el.entity_id = p.id
     WHERE p.id = $1
       AND (p.user_id = $2 OR COALESCE(p.is_public, TRUE) = TRUE)
     GROUP BY p.id, u.id, u.nick_name, u.name, u.profile_image_path`,
    [projectId, currentUserId]
  );

  const row = result.rows[0] || null;
  if (!row) return null;

  if (incrementView && row.user_id !== currentUserId) {
    const viewInsert = await query(
      `INSERT INTO entity_views (entity_type, entity_id, viewer_user_id)
       VALUES ('project', $1, $2)
       ON CONFLICT (entity_type, entity_id, viewer_user_id) DO NOTHING
       RETURNING viewer_user_id`,
      [projectId, currentUserId]
    );

    if (viewInsert.rows.length > 0) {
      await query(
        `UPDATE projects
         SET view_count = COALESCE(view_count, 0) + 1,
             updated_at = NOW()
         WHERE id = $1`,
        [projectId]
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

async function syncProjectLikeCount(projectId) {
  const likeCountResult = await query(
    `SELECT COUNT(*)::int AS like_count
     FROM entity_likes
     WHERE entity_type = 'project' AND entity_id = $1`,
    [projectId]
  );

  const likeCount = Number(likeCountResult.rows[0]?.like_count || 0);
  await query('UPDATE projects SET like_count = $1 WHERE id = $2', [likeCount, projectId]);
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

function mapProjectRow(row, currentUserId) {
  return {
    id: row.id,
    createdById: row.author_id || row.user_id,
    createdByName: row.author_name || null,
    createdByAvatar: row.author_avatar || null,
    title: row.title,
    description: row.description,
    backgroundImage: row.background_image,
    primaryChip: row.primary_chip,
    priorityChip: row.priority_chip,
    avatarImages: safeJsonParse(row.avatar_images, []),
    teamCount: row.team_count,
    statusText: row.status_text,
    statusIcon: row.status_icon,
    actionIcon: row.action_icon,
    isSaved: row.is_saved,
    comments: safeJsonParse(row.comments, []),
    timestamp: row.created_at ? row.created_at.toISOString() : null,
    createdDate: row.created_at ? row.created_at.toISOString() : null,
    fullContent: row.full_content || '',
    attachments: safeJsonParse(row.attachments, []),
    viewCount: Number(row.view_count || 0),
    likeCount: Number(row.like_count_total || row.like_count || 0),
    isLiked: row.liked_by_me === true,
    isPublic: row.is_public !== false,
    linkedIdeaId: row.linked_idea_id || null,
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

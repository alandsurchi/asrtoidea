const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const { query } = require('../db');
const { authenticate, generateToken } = require('../middleware/auth');

const router = express.Router();

// ─── POST /api/v1/auth/register ─────────────────────────────────────────────
router.post('/register', async (req, res, next) => {
  try {
    const { name, email, password } = req.body;
    const normalizedEmail = (email || '').trim().toLowerCase();

    if (!name || !normalizedEmail || !password) {
      return res.status(400).json({
        success: false,
        message: 'Name, email, and password are required.',
      });
    }

    // Check if email already exists
    const existing = await query('SELECT id FROM users WHERE LOWER(email) = $1', [normalizedEmail]);
    if (existing.rows.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'An account with this email already exists.',
      });
    }

    const id = uuidv4();
    const passwordHash = await bcrypt.hash(password, 10);

    await query(
      `INSERT INTO users (id, name, email, password_hash) VALUES ($1, $2, $3, $4)`,
      [id, name, normalizedEmail, passwordHash]
    );

    const user = { id, name, email: normalizedEmail };
    const token = generateToken(user);

    res.status(201).json({
      success: true,
      message: 'Account created successfully.',
      data: { user, token },
    });
  } catch (err) {
    next(err);
  }
});

// ─── POST /api/v1/auth/login ────────────────────────────────────────────────
router.post('/login', async (req, res, next) => {
  try {
    const password = req.body.password;
    const identifier = (req.body.email || req.body.identifier || '').trim();

    if (!identifier || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email or username and password are required.',
      });
    }

    const isEmailIdentifier = identifier.includes('@');
    const normalizedIdentifier = identifier.toLowerCase();

    const result = isEmailIdentifier
      ? await query(
          `SELECT * FROM users
           WHERE LOWER(email) = $1
           LIMIT 1`,
          [normalizedIdentifier]
        )
      : await query(
          `SELECT * FROM users
           WHERE LOWER(COALESCE(nick_name, '')) = $1
           LIMIT 1`,
          [normalizedIdentifier]
        );
    if (result.rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const token = generateToken(user);

    res.json({
      success: true,
      message: 'Login successful.',
      data: {
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          profileImagePath: user.profile_image_path,
          nickName: user.nick_name,
          phone: user.phone,
          address: user.address,
          job: user.job,
        },
        token,
      },
    });
  } catch (err) {
    next(err);
  }
});

// ─── GET /api/v1/auth/profile ───────────────────────────────────────────────
router.get('/profile', authenticate, async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM users WHERE id = $1', [req.user.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const user = result.rows[0];
    res.json({
      success: true,
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        profileImagePath: user.profile_image_path,
        nickName: user.nick_name,
        phone: user.phone,
        address: user.address,
        job: user.job,
      },
    });
  } catch (err) {
    next(err);
  }
});

// ─── PUT /api/v1/auth/profile ───────────────────────────────────────────────
router.put('/profile', authenticate, async (req, res, next) => {
  try {
    const { name, email, profileImagePath, nickName, phone, address, job } = req.body;
    const normalizedEmail = typeof email === 'string' ? email.trim().toLowerCase() : null;

    if (normalizedEmail) {
      const conflict = await query(
        'SELECT id FROM users WHERE LOWER(email) = $1 AND id <> $2',
        [normalizedEmail, req.user.id]
      );
      if (conflict.rows.length > 0) {
        return res.status(409).json({
          success: false,
          message: 'An account with this email already exists.',
        });
      }
    }

    const result = await query(
      `UPDATE users SET
        name = COALESCE($1, name),
        email = COALESCE($2, email),
        profile_image_path = COALESCE($3, profile_image_path),
        nick_name = COALESCE($4, nick_name),
        phone = COALESCE($5, phone),
        address = COALESCE($6, address),
        job = COALESCE($7, job),
        updated_at = NOW()
      WHERE id = $8
      RETURNING *`,
      [name, normalizedEmail, profileImagePath, nickName, phone, address, job, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    const user = result.rows[0];
    res.json({
      success: true,
      message: 'Profile updated.',
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        profileImagePath: user.profile_image_path,
        nickName: user.nick_name,
        phone: user.phone,
        address: user.address,
        job: user.job,
      },
    });
  } catch (err) {
    next(err);
  }
});

module.exports = router;

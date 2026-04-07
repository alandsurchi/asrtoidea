require('dotenv').config();
const express = require('express');
const crypto = require('crypto');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { pool, testConnection } = require('./db');
const logger = require('./logger');

// Import routes
const authRoutes = require('./routes/auth');
const projectRoutes = require('./routes/projects');
const ideaRoutes = require('./routes/ideas');

const app = express();
const PORT = process.env.PORT || 3000;

app.set('trust proxy', 1);

const rawAllowedOrigins = (process.env.CORS_ORIGINS || '').trim();
const allowedOrigins = rawAllowedOrigins
  .split(',')
  .map((origin) => origin.trim())
  .filter((origin) => origin.length > 0);

if (process.env.NODE_ENV === 'production' && allowedOrigins.length === 0) {
  logger.warn('CORS_ORIGINS is not configured; falling back to permissive CORS.');
}

const corsOptions = {
  origin(origin, callback) {
    // Non-browser clients (no Origin header) remain allowed.
    if (!origin) {
      callback(null, true);
      return;
    }

    if (allowedOrigins.length === 0 || allowedOrigins.includes(origin)) {
      callback(null, true);
      return;
    }

    callback(new Error('CORS origin is not allowed.'));
  },
  credentials: true,
};

// ─── Middleware ──────────────────────────────────────────────────────────────
app.use(helmet());
app.use(cors(corsOptions));
app.use(express.json({ limit: '10mb' }));

app.use((req, res, next) => {
  const incoming = req.headers['x-request-id'];
  const requestId =
    typeof incoming === 'string' && incoming.trim().length > 0
      ? incoming.trim()
      : crypto.randomUUID();

  req.requestId = requestId;
  res.setHeader('x-request-id', requestId);

  const startedAt = Date.now();
  res.on('finish', () => {
    logger.info('HTTP request completed', {
      requestId,
      method: req.method,
      path: req.originalUrl,
      statusCode: res.statusCode,
      durationMs: Date.now() - startedAt,
      ip: req.ip,
    });
  });

  next();
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
});

const commentLimiter = rateLimit({
  windowMs: 5 * 60 * 1000,
  max: 120,
  standardHeaders: true,
  legacyHeaders: false,
});

// Request logging (debug only)
if (process.env.NODE_ENV !== 'production') {
  app.use((req, res, next) => {
    logger.info('Incoming request', {
      requestId: req.requestId,
      method: req.method,
      path: req.path,
    });
    next();
  });
}

app.use('/api/v1/auth', authLimiter);
app.use('/api/v1/projects/:id/comments', commentLimiter);
app.use('/api/v1/ideas/:id/comments', commentLimiter);

// ─── Routes ─────────────────────────────────────────────────────────────────
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/projects', projectRoutes);
app.use('/api/v1/ideas', ideaRoutes);

// Health check endpoint
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'AI Idea Generator API is running',
    version: '1.0.0',
  });
});

app.get('/api/v1/health', (req, res) => {
  res.json({ success: true, message: 'OK' });
});

// ─── Global Error Handler ───────────────────────────────────────────────────
app.use((err, req, res, next) => {
  logger.error('Unhandled request error', {
    requestId: req.requestId,
    method: req.method,
    path: req.originalUrl,
    statusCode: err.statusCode || 500,
    error: err.message,
    stack: process.env.NODE_ENV === 'production' ? undefined : err.stack,
  });

  if (!res.headersSent) {
    res.setHeader('x-request-id', req.requestId || crypto.randomUUID());
  }

  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Internal server error',
    requestId: req.requestId || null,
  });
});

// ─── Start Server ───────────────────────────────────────────────────────────
async function start() {
  await testConnection();
  app.listen(PORT, '0.0.0.0', () => {
    logger.info('Server started', { port: PORT });
  });
}

if (require.main === module) {
  start();
}

module.exports = {
  app,
  start,
};

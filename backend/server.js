require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { pool, testConnection } = require('./db');

// Import routes
const authRoutes = require('./routes/auth');
const projectRoutes = require('./routes/projects');
const ideaRoutes = require('./routes/ideas');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Middleware ──────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Request logging (debug only)
if (process.env.NODE_ENV !== 'production') {
  app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
    next();
  });
}

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
  console.error('[ERROR]', err.message);
  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Internal server error',
  });
});

// ─── Start Server ───────────────────────────────────────────────────────────
async function start() {
  await testConnection();
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on port ${PORT}`);
  });
}

start();

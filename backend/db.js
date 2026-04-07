const { Pool } = require('pg');
const logger = require('./logger');

// Railway provides DATABASE_URL automatically when you link the Postgres service
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

async function testConnection() {
  try {
    const client = await pool.connect();
    logger.info('Connected to PostgreSQL');
    client.release();
  } catch (err) {
    logger.error('Database connection failed', {
      error: err.message,
    });
    process.exit(1);
  }
}

// Helper: run a query with automatic error handling
async function query(text, params) {
  const start = Date.now();
  const res = await pool.query(text, params);
  const duration = Date.now() - start;
  if (process.env.NODE_ENV !== 'production') {
    logger.info('Database query', {
      durationMs: duration,
      rowCount: res.rowCount,
      queryPreview: text.substring(0, 80),
    });
  }
  return res;
}

module.exports = { pool, query, testConnection };

const { Pool } = require('pg');

// Railway provides DATABASE_URL automatically when you link the Postgres service
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

async function testConnection() {
  try {
    const client = await pool.connect();
    console.log('✅ Connected to PostgreSQL');
    client.release();
  } catch (err) {
    console.error('❌ Database connection failed:', err.message);
    process.exit(1);
  }
}

// Helper: run a query with automatic error handling
async function query(text, params) {
  const start = Date.now();
  const res = await pool.query(text, params);
  const duration = Date.now() - start;
  if (process.env.NODE_ENV !== 'production') {
    console.log(`  [DB] ${text.substring(0, 60)}... (${duration}ms, ${res.rowCount} rows)`);
  }
  return res;
}

module.exports = { pool, query, testConnection };

// Migration runner — executes SQL files against the database
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { pool } = require('../db');
const logger = require('../logger');

function sha256(content) {
  return crypto.createHash('sha256').update(content).digest('hex');
}

async function ensureMigrationsTable(client) {
  await client.query(
    `CREATE TABLE IF NOT EXISTS schema_migrations (
       id SERIAL PRIMARY KEY,
       filename VARCHAR(255) NOT NULL UNIQUE,
       checksum VARCHAR(64) NOT NULL,
       applied_at TIMESTAMP DEFAULT NOW()
     )`
  );
}

async function loadAppliedMigrations(client) {
  const result = await client.query(
    `SELECT filename, checksum FROM schema_migrations`
  );
  const map = new Map();
  for (const row of result.rows) {
    map.set(row.filename, row.checksum);
  }
  return map;
}

async function runMigrations({ closePool = true } = {}) {
  const client = await pool.connect();
  try {
    logger.info('Running migrations');

    await ensureMigrationsTable(client);
    const applied = await loadAppliedMigrations(client);

    const files = fs
      .readdirSync(__dirname)
      .filter((file) => file.endsWith('.sql'))
      .sort();

    for (const file of files) {
      const sqlFile = path.join(__dirname, file);
      const sql = fs.readFileSync(sqlFile, 'utf8');
      const checksum = sha256(sql);
      const existingChecksum = applied.get(file);

      if (existingChecksum) {
        if (existingChecksum !== checksum) {
          throw new Error(
            `Migration checksum mismatch for ${file}. Expected ${existingChecksum}, got ${checksum}.`
          );
        }

        logger.info('Skipping already applied migration', { file });
        continue;
      }

      logger.info('Applying migration', { file });
      await client.query('BEGIN');
      try {
        await client.query(sql);
        await client.query(
          `INSERT INTO schema_migrations (filename, checksum)
           VALUES ($1, $2)`,
          [file, checksum]
        );
        await client.query('COMMIT');
      } catch (err) {
        await client.query('ROLLBACK');
        throw err;
      }
    }

    logger.info('Migrations complete');
  } catch (err) {
    logger.error('Migration failed', { error: err.message });
    throw err;
  } finally {
    client.release();
    if (closePool) {
      await pool.end();
    }
  }
}

if (require.main === module) {
  runMigrations({ closePool: true }).catch(() => {
    process.exit(1);
  });
}

module.exports = {
  runMigrations,
};

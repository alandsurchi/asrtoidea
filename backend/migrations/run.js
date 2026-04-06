// Migration runner — executes SQL files against the database
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });
const fs = require('fs');
const path = require('path');
const { pool } = require('../db');

async function runMigrations() {
  const client = await pool.connect();
  try {
    console.log('🔧 Running migrations...');
    
    const sqlFile = path.join(__dirname, '001_init.sql');
    const sql = fs.readFileSync(sqlFile, 'utf8');
    
    await client.query(sql);
    
    console.log('✅ Migrations complete!');
  } catch (err) {
    console.error('❌ Migration failed:', err.message);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

runMigrations();

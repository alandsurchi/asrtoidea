const jwt = require('jsonwebtoken');

const configuredSecret = process.env.JWT_SECRET;
if (process.env.NODE_ENV === 'production' && !configuredSecret) {
  throw new Error('JWT_SECRET is required when NODE_ENV=production');
}

const JWT_SECRET = configuredSecret || 'dev-secret-local-only';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '30d';

// Middleware: Verify JWT token
function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Authentication required. Please log in.',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded; // { id, email }
    next();
  } catch (err) {
    return res.status(401).json({
      success: false,
      message: 'Invalid or expired token.',
    });
  }
}

// Helper: Generate a JWT token
function generateToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES_IN }
  );
}

module.exports = { authenticate, generateToken, JWT_SECRET };

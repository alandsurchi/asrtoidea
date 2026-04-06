const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret-change-in-production';

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
    { expiresIn: '30d' }
  );
}

module.exports = { authenticate, generateToken, JWT_SECRET };

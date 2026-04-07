function write(level, message, meta = {}) {
  const payload = {
    timestamp: new Date().toISOString(),
    level,
    message,
    ...meta,
  };

  const serialized = JSON.stringify(payload);

  if (level === 'error') {
    console.error(serialized);
    return;
  }

  console.log(serialized);
}

function info(message, meta) {
  write('info', message, meta);
}

function warn(message, meta) {
  write('warn', message, meta);
}

function error(message, meta) {
  write('error', message, meta);
}

module.exports = {
  info,
  warn,
  error,
};

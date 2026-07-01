import http from 'http';
import app from './app';
import { initializeSocketIO } from './socket';
import { config } from './config/environment';

const server = http.createServer(app);

// Initialize Socket.IO for real-time features
initializeSocketIO(server);

server.listen(config.port, () => {
  console.log(`🚀 TsuperApp Backend running on port ${config.port}`);
  console.log(`📡 Environment: ${config.nodeEnv}`);
  console.log(`🔌 Socket.IO ready for real-time connections`);
  console.log(`🛡️  Security: rate limiting, helmet, CORS, sanitization active`);
});

// ─────────────────────────────────────────────────────────────────
// GRACEFUL SHUTDOWN
// When the server receives a kill signal (e.g., during deployment),
// it finishes serving current requests before closing, instead of
// abruptly dropping connections.
// ─────────────────────────────────────────────────────────────────
const gracefulShutdown = (signal: string) => {
  console.log(`\n⚠️  ${signal} received. Shutting down gracefully...`);
  server.close(() => {
    console.log('✅ HTTP server closed. Process exiting.');
    process.exit(0);
  });

  // Force shutdown if graceful close takes too long (10 seconds)
  setTimeout(() => {
    console.error('❌ Forced shutdown — graceful close timed out.');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Catch unhandled errors so the server doesn't crash silently
process.on('unhandledRejection', (reason: unknown) => {
  console.error('UNHANDLED REJECTION:', reason);
  // In production, you'd want to log this to a service like Sentry
});

process.on('uncaughtException', (error: Error) => {
  console.error('UNCAUGHT EXCEPTION:', error);
  // Exit — the process is in an undefined state
  process.exit(1);
});

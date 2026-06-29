import http from 'http';
import app from './app';
import { initializeSocketIO } from './socket';
import { config } from './config/environment';

const server = http.createServer(app);

// Initialize Socket.IO
initializeSocketIO(server);

server.listen(config.port, () => {
  console.log(`🚀 TsuperApp Backend running on port ${config.port}`);
  console.log(`📡 Environment: ${config.nodeEnv}`);
  console.log(`🔌 Socket.IO ready for real-time connections`);
});

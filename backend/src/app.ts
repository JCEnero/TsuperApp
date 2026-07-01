import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import hpp from 'hpp';
import { config } from './config/environment';
import { errorHandler } from './middleware/error-handler';
import { generalLimiter, speedLimiter } from './middleware/rate-limiter';
import { sanitizeRequest } from './middleware/sanitize';
import { authRoutes } from './routes/auth.routes';
import { userRoutes } from './routes/user.routes';
import { driverRoutes } from './routes/driver.routes';
import { passengerRoutes } from './routes/passenger.routes';
import { routeRoutes } from './routes/route.routes';
import { tripRoutes } from './routes/trip.routes';
import { notificationRoutes } from './routes/notification.routes';
import { jeepneyRoutes } from './routes/jeepney.routes';

const app = express();

// ─────────────────────────────────────────────────────────────────
// SECURITY MIDDLEWARE (runs on every request, in order)
// ─────────────────────────────────────────────────────────────────

// 1. Helmet — Sets security headers (X-Content-Type-Options,
//    X-Frame-Options, Strict-Transport-Security, etc.)
//    Protects against: clickjacking, MIME sniffing, XSS
app.use(helmet());

// 2. CORS — Controls which domains can call your API
//    In production: only your Flutter app's domain
//    Protects against: unauthorized cross-origin requests
app.use(
  cors({
    origin: config.corsOrigin,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
  })
);

// 3. Rate limiting — Prevents abuse and DDoS
//    Default: 100 requests per 15 minutes per IP
app.use(generalLimiter);

// 4. Speed limiting — Gradually slows down repeat offenders
app.use(speedLimiter);

// 5. HPP — HTTP Parameter Pollution protection
//    Prevents: ?sort=asc&sort=desc attacks that confuse parsers
app.use(hpp());

// 6. Body parser with size limit — Prevents large payload attacks
//    Rejects bodies larger than 10kb (more than enough for JSON APIs)
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ extended: true, limit: '10kb' }));

// 7. Sanitize request body — Strips dangerous characters/patterns
app.use(sanitizeRequest);

// ─────────────────────────────────────────────────────────────────
// LOGGING
// ─────────────────────────────────────────────────────────────────

// Development: detailed colored logs
// Production: minimal logs (method, url, status, response time)
app.use(morgan(config.isProduction ? 'combined' : 'dev'));

// ─────────────────────────────────────────────────────────────────
// HEALTH CHECK (no auth required — used by load balancers/monitors)
// ─────────────────────────────────────────────────────────────────
app.get('/api/health', (_req, res) => {
  res.json({
    status: 'ok',
    environment: config.nodeEnv,
    timestamp: new Date().toISOString(),
  });
});

// ─────────────────────────────────────────────────────────────────
// API ROUTES
// ─────────────────────────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/drivers', driverRoutes);
app.use('/api/passengers', passengerRoutes);
app.use('/api/routes', routeRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/jeepneys', jeepneyRoutes);

// ─────────────────────────────────────────────────────────────────
// 404 HANDLER — Catches requests to undefined routes
// ─────────────────────────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found',
  });
});

// ─────────────────────────────────────────────────────────────────
// GLOBAL ERROR HANDLER (must be last)
// ─────────────────────────────────────────────────────────────────
app.use(errorHandler);

export default app;

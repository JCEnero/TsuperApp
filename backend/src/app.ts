import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from './config/environment';
import { errorHandler } from './middleware/error-handler';
import { authRoutes } from './routes/auth.routes';
import { userRoutes } from './routes/user.routes';
import { driverRoutes } from './routes/driver.routes';
import { passengerRoutes } from './routes/passenger.routes';
import { routeRoutes } from './routes/route.routes';
import { tripRoutes } from './routes/trip.routes';
import { notificationRoutes } from './routes/notification.routes';

const app = express();

// Middleware
app.use(helmet());
app.use(cors({ origin: config.corsOrigin }));
app.use(morgan('dev'));
app.use(express.json());

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/drivers', driverRoutes);
app.use('/api/passengers', passengerRoutes);
app.use('/api/routes', routeRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/notifications', notificationRoutes);

// Error handling
app.use(errorHandler);

export default app;

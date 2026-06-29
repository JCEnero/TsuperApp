import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { supabaseAdmin } from '../config/supabase';
import { Tables, TripStatus } from '../config/constants';
import { validate } from '../middleware/validate';
import { authenticate } from '../middleware/auth';
import { AppError } from '../middleware/error-handler';

const router = Router();

// Validation schemas
const createTripSchema = z.object({
  routeId: z.string().min(1, 'Route ID is required'),
  origin: z.string().min(1, 'Origin is required'),
  destination: z.string().min(1, 'Destination is required'),
  fare: z.string().min(1, 'Fare is required'),
  driverId: z.string().optional(),
});

// GET /api/trips/user/:userId - Get trips for a user (passenger)
router.get(
  '/user/:userId',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .select()
        .eq('user_id', req.params.userId)
        .order('created_at', { ascending: false });

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/trips/driver/:driverId - Get trips for a driver
router.get(
  '/driver/:driverId',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .select()
        .eq('driver_id', req.params.driverId)
        .order('created_at', { ascending: false });

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/trips/:id - Get trip by ID
router.get(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (error || !data) {
        throw new AppError('Trip not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/trips - Create trip
router.post(
  '/',
  authenticate,
  validate(createTripSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { routeId, origin, destination, fare, driverId } = req.body;

      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .insert({
          user_id: req.userId,
          driver_id: driverId || null,
          route_id: routeId,
          origin,
          destination,
          fare,
          status: TripStatus.PENDING,
          created_at: new Date().toISOString(),
        })
        .select()
        .single();

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.status(201).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// PATCH /api/trips/:id/start - Start a trip
router.patch(
  '/:id/start',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .update({
          status: TripStatus.IN_PROGRESS,
          start_time: new Date().toISOString(),
        })
        .eq('id', req.params.id)
        .select()
        .single();

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// PATCH /api/trips/:id/complete - Complete a trip
router.patch(
  '/:id/complete',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .update({
          status: TripStatus.COMPLETED,
          end_time: new Date().toISOString(),
        })
        .eq('id', req.params.id)
        .select()
        .single();

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// PATCH /api/trips/:id/cancel - Cancel a trip
router.patch(
  '/:id/cancel',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.TRIPS)
        .update({ status: TripStatus.CANCELLED })
        .eq('id', req.params.id)
        .select()
        .single();

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

export { router as tripRoutes };

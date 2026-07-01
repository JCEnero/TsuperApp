import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { supabaseAdmin } from '../config/supabase';
import { Tables, DriverStatus } from '../config/constants';
import { validate } from '../middleware/validate';
import { authenticate } from '../middleware/auth';
import { AppError } from '../middleware/error-handler';

const router = Router();

// Validation schemas
const updateLocationSchema = z.object({
  latitude: z.number(),
  longitude: z.number(),
});

const updateStatusSchema = z.object({
  status: z.enum([
    DriverStatus.ACTIVE,
    DriverStatus.INACTIVE,
    DriverStatus.ON_ROUTE,
    DriverStatus.OFFLINE,
  ]),
});

const updateOccupancySchema = z.object({
  occupancy: z.number().int().min(0),
});

// GET /api/drivers/active - Get all active drivers
router.get(
  '/active',
  authenticate,
  async (_req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .select()
        .eq('status', DriverStatus.ACTIVE);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/drivers/route/:route - Get drivers by assigned route
router.get(
  '/route/:route',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .select()
        .eq('assigned_route', req.params.route);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/drivers/user/:userId - Get driver by user ID
router.get(
  '/user/:userId',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .select()
        .eq('user_id', req.params.userId)
        .single();

      if (error || !data) {
        throw new AppError('Driver not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/drivers/:id - Get driver by ID
router.get(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (error || !data) {
        throw new AppError('Driver not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// PATCH /api/drivers/:id/location - Update driver location
router.patch(
  '/:id/location',
  authenticate,
  validate(updateLocationSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { latitude, longitude } = req.body;

      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .update({
          current_latitude: latitude,
          current_longitude: longitude,
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

// PATCH /api/drivers/:id/status - Update driver status
router.patch(
  '/:id/status',
  authenticate,
  validate(updateStatusSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { status } = req.body;

      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .update({ status })
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

// PATCH /api/drivers/:id/occupancy - Update driver occupancy
router.patch(
  '/:id/occupancy',
  authenticate,
  validate(updateOccupancySchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { occupancy } = req.body;

      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .update({ occupancy })
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

// PUT /api/drivers/:id - Update full driver record
router.put(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.DRIVERS)
        .update(req.body)
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

export { router as driverRoutes };

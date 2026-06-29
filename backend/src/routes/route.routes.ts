import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { supabaseAdmin } from '../config/supabase';
import { Tables } from '../config/constants';
import { validate } from '../middleware/validate';
import { authenticate } from '../middleware/auth';
import { AppError } from '../middleware/error-handler';

const router = Router();

// Validation schemas
const createRouteSchema = z.object({
  routeName: z.string().min(1, 'Route name is required'),
  origin: z.string().min(1, 'Origin is required'),
  destination: z.string().min(1, 'Destination is required'),
  estimatedFare: z.string().min(1, 'Estimated fare is required'),
  estimatedTime: z.string().min(1, 'Estimated time is required'),
});

// GET /api/routes - Get all routes
router.get(
  '/',
  authenticate,
  async (_req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.ROUTES)
        .select()
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

// GET /api/routes/search - Search routes by origin or destination
router.get(
  '/search',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { origin, destination } = req.query;

      let query = supabaseAdmin.from(Tables.ROUTES).select();

      if (origin) {
        query = query.ilike('origin', `%${origin}%`);
      }

      if (destination) {
        query = query.ilike('destination', `%${destination}%`);
      }

      const { data, error } = await query;

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/routes/:id - Get route by ID
router.get(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.ROUTES)
        .select()
        .eq('id', req.params.id)
        .single();

      if (error || !data) {
        throw new AppError('Route not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/routes - Create route
router.post(
  '/',
  authenticate,
  validate(createRouteSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { routeName, origin, destination, estimatedFare, estimatedTime } =
        req.body;

      const { data, error } = await supabaseAdmin
        .from(Tables.ROUTES)
        .insert({
          route_name: routeName,
          origin,
          destination,
          estimated_fare: estimatedFare,
          estimated_time: estimatedTime,
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

// PUT /api/routes/:id - Update route
router.put(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const updates: Record<string, unknown> = {};

      if (req.body.routeName) updates.route_name = req.body.routeName;
      if (req.body.origin) updates.origin = req.body.origin;
      if (req.body.destination) updates.destination = req.body.destination;
      if (req.body.estimatedFare)
        updates.estimated_fare = req.body.estimatedFare;
      if (req.body.estimatedTime)
        updates.estimated_time = req.body.estimatedTime;

      const { data, error } = await supabaseAdmin
        .from(Tables.ROUTES)
        .update(updates)
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

// DELETE /api/routes/:id - Delete route
router.delete(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { error } = await supabaseAdmin
        .from(Tables.ROUTES)
        .delete()
        .eq('id', req.params.id);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'Route deleted' });
    } catch (err) {
      next(err);
    }
  }
);

export { router as routeRoutes };

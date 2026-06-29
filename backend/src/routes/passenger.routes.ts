import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { supabaseAdmin } from '../config/supabase';
import { Tables } from '../config/constants';
import { validate } from '../middleware/validate';
import { authenticate } from '../middleware/auth';
import { AppError } from '../middleware/error-handler';

const router = Router();

// Validation schemas
const favoritePlaceSchema = z.object({
  placeId: z.string().min(1, 'Place ID is required'),
});

const recentRouteSchema = z.object({
  routeId: z.string().min(1, 'Route ID is required'),
});

// GET /api/passengers/user/:userId - Get passenger by user ID
router.get(
  '/user/:userId',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .select()
        .eq('user_id', req.params.userId)
        .single();

      if (error || !data) {
        throw new AppError('Passenger not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/passengers/:id - Get passenger by ID
router.get(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (error || !data) {
        throw new AppError('Passenger not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// PUT /api/passengers/:id - Update passenger
router.put(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.PASSENGERS)
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

// POST /api/passengers/:id/favorites - Add favorite place
router.post(
  '/:id/favorites',
  authenticate,
  validate(favoritePlaceSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { placeId } = req.body;

      // Get current passenger data
      const { data: passenger, error: fetchError } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (fetchError || !passenger) {
        throw new AppError('Passenger not found', 404);
      }

      const favorites = [...(passenger.favorite_places || []), placeId];

      const { data, error } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .update({ favorite_places: favorites })
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

// DELETE /api/passengers/:id/favorites/:placeId - Remove favorite place
router.delete(
  '/:id/favorites/:placeId',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Get current passenger data
      const { data: passenger, error: fetchError } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (fetchError || !passenger) {
        throw new AppError('Passenger not found', 404);
      }

      const favorites = (passenger.favorite_places || []).filter(
        (p: string) => p !== req.params.placeId
      );

      const { data, error } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .update({ favorite_places: favorites })
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

// POST /api/passengers/:id/recent-routes - Add recent route
router.post(
  '/:id/recent-routes',
  authenticate,
  validate(recentRouteSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { routeId } = req.body;

      const { data: passenger, error: fetchError } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (fetchError || !passenger) {
        throw new AppError('Passenger not found', 404);
      }

      const recentRoutes = [...(passenger.recent_routes || []), routeId];

      const { data, error } = await supabaseAdmin
        .from(Tables.PASSENGERS)
        .update({ recent_routes: recentRoutes })
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

export { router as passengerRoutes };

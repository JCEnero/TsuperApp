import { Router, Request, Response, NextFunction } from 'express';
import { supabaseAdmin } from '../config/supabase';
import { Tables } from '../config/constants';
import { authenticate } from '../middleware/auth';
import { AppError } from '../middleware/error-handler';

const router = Router();

// GET /api/users/:id
router.get(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.USERS)
        .select()
        .eq('id', req.params.id)
        .single();

      if (error || !data) {
        throw new AppError('User not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/users?email=...
router.get(
  '/',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email } = req.query;

      if (email) {
        const { data, error } = await supabaseAdmin
          .from(Tables.USERS)
          .select()
          .eq('email', email as string)
          .single();

        if (error || !data) {
          throw new AppError('User not found', 404);
        }

        return res.json({ success: true, data });
      }

      // List all users (admin only - add role check in production)
      const { data, error } = await supabaseAdmin
        .from(Tables.USERS)
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

// DELETE /api/users/:id
router.delete(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { error } = await supabaseAdmin
        .from(Tables.USERS)
        .delete()
        .eq('id', req.params.id);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'User deleted' });
    } catch (err) {
      next(err);
    }
  }
);

export { router as userRoutes };

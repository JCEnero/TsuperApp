import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { supabaseAdmin } from '../config/supabase';
import { Tables } from '../config/constants';
import { validate } from '../middleware/validate';
import { authenticate } from '../middleware/auth';
import { AppError } from '../middleware/error-handler';

const router = Router();

// Validation schemas
const createNotificationSchema = z.object({
  userId: z.string().min(1, 'User ID is required'),
  title: z.string().min(1, 'Title is required'),
  message: z.string().min(1, 'Message is required'),
  type: z.string().min(1, 'Type is required'),
});

// GET /api/notifications/user/:userId - Get all notifications for user
router.get(
  '/user/:userId',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.NOTIFICATIONS)
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

// GET /api/notifications/user/:userId/unread - Get unread notifications
router.get(
  '/user/:userId/unread',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.NOTIFICATIONS)
        .select()
        .eq('user_id', req.params.userId)
        .eq('is_read', false)
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

// POST /api/notifications - Create notification
router.post(
  '/',
  authenticate,
  validate(createNotificationSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { userId, title, message, type } = req.body;

      const { data, error } = await supabaseAdmin
        .from(Tables.NOTIFICATIONS)
        .insert({
          user_id: userId,
          title,
          message,
          type,
          is_read: false,
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

// PATCH /api/notifications/:id/read - Mark as read
router.patch(
  '/:id/read',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.NOTIFICATIONS)
        .update({ is_read: true })
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

// PATCH /api/notifications/user/:userId/read-all - Mark all as read
router.patch(
  '/user/:userId/read-all',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { error } = await supabaseAdmin
        .from(Tables.NOTIFICATIONS)
        .update({ is_read: true })
        .eq('user_id', req.params.userId);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'All notifications marked as read' });
    } catch (err) {
      next(err);
    }
  }
);

// DELETE /api/notifications/:id - Delete notification
router.delete(
  '/:id',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { error } = await supabaseAdmin
        .from(Tables.NOTIFICATIONS)
        .delete()
        .eq('id', req.params.id);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'Notification deleted' });
    } catch (err) {
      next(err);
    }
  }
);

export { router as notificationRoutes };

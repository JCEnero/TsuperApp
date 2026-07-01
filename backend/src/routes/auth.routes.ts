import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';
import { supabaseAdmin } from '../config/supabase';
import { Tables, Roles, DriverStatus } from '../config/constants';
import { validate } from '../middleware/validate';
import { authenticate } from '../middleware/auth';
import { authLimiter } from '../middleware/rate-limiter';
import { AppError } from '../middleware/error-handler';

const router = Router();

// Apply stricter rate limiting to all auth routes
// (10 attempts per 15 min instead of 100)
router.use(authLimiter);

// Validation schemas
const signUpSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  fullName: z.string().min(1, 'Full name is required'),
  role: z.enum([Roles.PASSENGER, Roles.DRIVER]),
});

const signInSchema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(1, 'Password is required'),
});

const resetPasswordSchema = z.object({
  email: z.string().email('Invalid email'),
});

const updatePasswordSchema = z.object({
  newPassword: z.string().min(6, 'Password must be at least 6 characters'),
});

const updateProfileSchema = z.object({
  fullName: z.string().optional(),
  phone: z.string().optional(),
  avatarUrl: z.string().url().optional(),
});

// POST /api/auth/signup
router.post(
  '/signup',
  validate(signUpSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email, password, fullName, role } = req.body;
      const now = new Date().toISOString();

      // Create auth user
      const { data: authData, error: authError } =
        await supabaseAdmin.auth.admin.createUser({
          email,
          password,
          email_confirm: true,
          user_metadata: { full_name: fullName, role },
        });

      if (authError) {
        throw new AppError(authError.message, 400);
      }

      const userId = authData.user.id;

      // Create user profile
      await supabaseAdmin.from(Tables.USERS).upsert(
        {
          id: userId,
          email,
          full_name: fullName,
          role,
          created_at: now,
          updated_at: now,
        },
        { onConflict: 'id' }
      );

      // Create role-specific profile
      if (role === Roles.PASSENGER) {
        await supabaseAdmin.from(Tables.PASSENGERS).upsert(
          {
            id: uuidv4(),
            user_id: userId,
            favorite_places: [],
            recent_routes: [],
            created_at: now,
          },
          { onConflict: 'user_id', ignoreDuplicates: true }
        );
      } else if (role === Roles.DRIVER) {
        await supabaseAdmin.from(Tables.DRIVERS).upsert(
          {
            id: uuidv4(),
            user_id: userId,
            plate_number: 'TBD',
            vehicle_number: 'TBD',
            assigned_route: null,
            status: DriverStatus.INACTIVE,
            occupancy: 0,
            created_at: now,
          },
          { onConflict: 'user_id', ignoreDuplicates: true }
        );
      }

      // Generate a session so the user is logged in immediately after signup
      const { data: signInData, error: signInError } =
        await supabaseAdmin.auth.signInWithPassword({ email, password });

      if (signInError || !signInData.session) {
        // User was created but session generation failed — still return success
        return res.status(201).json({
          success: true,
          data: {
            session: null,
            user: { id: userId, email, fullName, role },
          },
        });
      }

      res.status(201).json({
        success: true,
        data: {
          session: {
            accessToken: signInData.session.access_token,
            refreshToken: signInData.session.refresh_token,
            expiresAt: signInData.session.expires_at,
          },
          user: {
            id: userId,
            email,
            fullName,
            role,
          },
        },
      });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/auth/signin
router.post(
  '/signin',
  validate(signInSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email, password } = req.body;

      const { data, error } = await supabaseAdmin.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        throw new AppError(error.message, 401);
      }

      // Fetch user profile for role info
      const { data: profile } = await supabaseAdmin
        .from(Tables.USERS)
        .select()
        .eq('id', data.user.id)
        .single();

      res.json({
        success: true,
        data: {
          session: {
            accessToken: data.session.access_token,
            refreshToken: data.session.refresh_token,
            expiresAt: data.session.expires_at,
          },
          user: {
            id: data.user.id,
            email: data.user.email,
            fullName: profile?.full_name,
            role: profile?.role,
          },
        },
      });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/auth/signout
router.post(
  '/signout',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Revoke all sessions for the user (signs them out everywhere)
      const { error } = await supabaseAdmin.auth.admin.signOut(
        req.headers.authorization!.split(' ')[1],
        'global'
      );

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'Signed out successfully' });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/auth/reset-password
router.post(
  '/reset-password',
  validate(resetPasswordSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email } = req.body;

      const { error } = await supabaseAdmin.auth.resetPasswordForEmail(email);

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'Password reset email sent' });
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/auth/update-password (authenticated)
router.post(
  '/update-password',
  authenticate,
  validate(updatePasswordSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { newPassword } = req.body;

      const { error } = await supabaseAdmin.auth.admin.updateUserById(
        req.userId!,
        { password: newPassword }
      );

      if (error) {
        throw new AppError(error.message, 400);
      }

      res.json({ success: true, message: 'Password updated successfully' });
    } catch (err) {
      next(err);
    }
  }
);

// GET /api/auth/profile (authenticated - gets own profile)
router.get(
  '/profile',
  authenticate,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { data, error } = await supabaseAdmin
        .from(Tables.USERS)
        .select()
        .eq('id', req.userId!)
        .single();

      if (error || !data) {
        throw new AppError('Profile not found', 404);
      }

      res.json({ success: true, data });
    } catch (err) {
      next(err);
    }
  }
);

// PATCH /api/auth/profile (authenticated - updates own profile)
router.patch(
  '/profile',
  authenticate,
  validate(updateProfileSchema),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const updates: Record<string, unknown> = {
        updated_at: new Date().toISOString(),
      };

      if (req.body.fullName) updates.full_name = req.body.fullName;
      if (req.body.phone) updates.phone = req.body.phone;
      if (req.body.avatarUrl) updates.avatar_url = req.body.avatarUrl;

      const { data, error } = await supabaseAdmin
        .from(Tables.USERS)
        .update(updates)
        .eq('id', req.userId!)
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

export { router as authRoutes };

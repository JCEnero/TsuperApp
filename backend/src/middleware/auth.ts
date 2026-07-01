import { Request, Response, NextFunction } from 'express';
import { supabaseAdmin } from '../config/supabase';
import { AppError } from './error-handler';

// Extend Express Request to include authenticated user info
declare global {
  namespace Express {
    interface Request {
      userId?: string;
      userEmail?: string;
      userRole?: string;
    }
  }
}

/**
 * AUTHENTICATION MIDDLEWARE
 *
 * Verifies the Supabase JWT token from the Authorization header.
 * If valid, attaches user info to the request so downstream handlers
 * can use req.userId, req.userEmail, req.userRole.
 *
 * How it works:
 * 1. Extracts "Bearer <token>" from the Authorization header
 * 2. Calls Supabase to verify the token is valid and not expired
 * 3. If valid → attaches user data and continues
 * 4. If invalid → returns 401 Unauthorized
 *
 * Security notes:
 * - Token verification is done server-side via Supabase Admin API
 * - Expired tokens are automatically rejected
 * - No sensitive data is logged
 */
export const authenticate = async (
  req: Request,
  _res: Response,
  next: NextFunction
) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new AppError('Missing or invalid authorization header', 401);
    }

    const token = authHeader.split(' ')[1];

    // Reject obviously malformed tokens before hitting Supabase
    if (!token || token.length < 10) {
      throw new AppError('Invalid token format', 401);
    }

    const { data, error } = await supabaseAdmin.auth.getUser(token);

    if (error || !data.user) {
      throw new AppError('Invalid or expired token', 401);
    }

    // Attach user info to request for use in route handlers
    req.userId = data.user.id;
    req.userEmail = data.user.email;
    req.userRole = data.user.user_metadata?.role;

    next();
  } catch (err) {
    next(err);
  }
};

/**
 * OPTIONAL AUTHENTICATION
 *
 * Same as authenticate but doesn't reject unauthenticated requests.
 * Use for endpoints that work differently for logged-in vs anonymous users.
 * e.g., GET /routes might show all routes publicly, but show favorites if logged in.
 */
export const optionalAuth = async (
  req: Request,
  _res: Response,
  next: NextFunction
) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next(); // Continue without user info
    }

    const token = authHeader.split(' ')[1];

    if (!token || token.length < 10) {
      return next();
    }

    const { data, error } = await supabaseAdmin.auth.getUser(token);

    if (!error && data.user) {
      req.userId = data.user.id;
      req.userEmail = data.user.email;
      req.userRole = data.user.user_metadata?.role;
    }

    next();
  } catch {
    // Silently continue — auth is optional
    next();
  }
};

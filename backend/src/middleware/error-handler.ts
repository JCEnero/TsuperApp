import { Request, Response, NextFunction } from 'express';
import { config } from '../config/environment';

/**
 * Custom application error class.
 *
 * - statusCode: HTTP status to return (400, 401, 403, 404, 500, etc.)
 * - isOperational: true = expected error (bad input, not found), safe to show message
 *                  false = programmer error (bug), don't leak details to client
 */
export class AppError extends Error {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string, statusCode: number, isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    Error.captureStackTrace(this, this.constructor);
  }
}

/**
 * GLOBAL ERROR HANDLER
 *
 * All errors flow here. Behavior differs by environment:
 *
 * Development: Returns full error message + stack trace (helps debugging)
 * Production: Returns generic message for unknown errors (prevents info leakage)
 *
 * Operational errors (AppError with isOperational=true) always return their message
 * because they're intentional — "User not found", "Invalid token", etc.
 */
export const errorHandler = (
  err: Error | AppError,
  req: Request,
  res: Response,
  _next: NextFunction
) => {
  // Log error details server-side (always, in any environment)
  console.error(`[${new Date().toISOString()}] ERROR:`, {
    method: req.method,
    path: req.path,
    message: err.message,
    stack: err.stack,
    userId: req.userId || 'unauthenticated',
  });

  // Known operational error — safe to show message to client
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
      ...(config.isProduction ? {} : { stack: err.stack }),
    });
  }

  // Unknown/unexpected error — hide details in production
  return res.status(500).json({
    success: false,
    message: config.isProduction
      ? 'Something went wrong. Please try again later.'
      : err.message,
    ...(config.isProduction ? {} : { stack: err.stack }),
  });
};

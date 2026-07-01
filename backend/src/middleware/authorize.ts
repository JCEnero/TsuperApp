import { Request, Response, NextFunction } from 'express';
import { AppError } from './error-handler';

/**
 * ROLE-BASED ACCESS CONTROL (RBAC)
 *
 * Use after `authenticate` middleware to restrict endpoints to specific roles.
 * If the user's role doesn't match the allowed roles, they get a 403 Forbidden.
 *
 * Usage:
 *   router.get('/admin-only', authenticate, authorize('admin'), handler);
 *   router.get('/driver-or-admin', authenticate, authorize('driver', 'admin'), handler);
 */
export const authorize = (...allowedRoles: string[]) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.userRole) {
      throw new AppError('Access denied. No role assigned.', 403);
    }

    if (!allowedRoles.includes(req.userRole)) {
      throw new AppError(
        `Access denied. Required role: ${allowedRoles.join(' or ')}. Your role: ${req.userRole}.`,
        403
      );
    }

    next();
  };
};

/**
 * OWNERSHIP CHECK
 *
 * Ensures a user can only access/modify their own resources.
 * Compares the authenticated userId with a param in the request.
 *
 * Usage:
 *   router.patch('/users/:id', authenticate, ownerOnly('id'), handler);
 *   // Only the user whose ID matches :id can update
 */
export const ownerOnly = (paramName: string = 'userId') => {
  return (req: Request, _res: Response, next: NextFunction) => {
    const resourceOwnerId = req.params[paramName];

    if (resourceOwnerId && resourceOwnerId !== req.userId) {
      throw new AppError(
        'Access denied. You can only access your own resources.',
        403
      );
    }

    next();
  };
};

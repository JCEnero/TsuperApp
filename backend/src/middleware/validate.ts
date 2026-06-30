import { Request, Response, NextFunction } from 'express';
import { ZodSchema } from 'zod';
import { AppError } from './error-handler';

/**
 * Middleware factory to validate request body against a Zod schema.
 */
export const validate = (schema: ZodSchema) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    const result = schema.safeParse(req.body);

    if (!result.success) {
      const errors = result.error.errors.map((e) => e.message).join(', ');
      throw new AppError(`Validation error: ${errors}`, 400);
    }

    req.body = result.data;
    next();
  };
};

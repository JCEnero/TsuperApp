import { Request, Response, NextFunction } from 'express';

/**
 * REQUEST SANITIZER
 *
 * Cleans incoming request data to prevent common injection attacks:
 * - Trims whitespace from string fields
 * - Removes null bytes (used in null byte injection attacks)
 * - Strips any keys starting with '$' (prevents NoSQL injection patterns)
 *
 * This runs on every request before it hits route handlers.
 */
export const sanitizeRequest = (
  req: Request,
  _res: Response,
  next: NextFunction
) => {
  if (req.body && typeof req.body === 'object') {
    req.body = sanitizeObject(req.body);
  }
  next();
};

function sanitizeObject(obj: Record<string, unknown>): Record<string, unknown> {
  const cleaned: Record<string, unknown> = {};

  for (const [key, value] of Object.entries(obj)) {
    // Block keys starting with $ (NoSQL injection pattern)
    if (key.startsWith('$')) continue;

    if (typeof value === 'string') {
      // Trim whitespace and remove null bytes
      cleaned[key] = value.trim().replace(/\0/g, '');
    } else if (Array.isArray(value)) {
      cleaned[key] = value.map((item) =>
        typeof item === 'string'
          ? item.trim().replace(/\0/g, '')
          : typeof item === 'object' && item !== null
            ? sanitizeObject(item as Record<string, unknown>)
            : item
      );
    } else if (typeof value === 'object' && value !== null) {
      cleaned[key] = sanitizeObject(value as Record<string, unknown>);
    } else {
      cleaned[key] = value;
    }
  }

  return cleaned;
}

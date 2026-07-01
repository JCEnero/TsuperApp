import rateLimit from 'express-rate-limit';
import slowDown from 'express-slow-down';
import { config } from '../config/environment';

/**
 * GENERAL RATE LIMITER
 * Limits each IP to a set number of requests per time window.
 * Prevents a single client from overwhelming the server.
 *
 * Default: 100 requests per 15 minutes.
 */
export const generalLimiter = rateLimit({
  windowMs: config.rateLimitWindowMs,
  max: config.rateLimitMax,
  message: {
    success: false,
    message: 'Too many requests. Please try again later.',
  },
  standardHeaders: true, // Returns rate limit info in `RateLimit-*` headers
  legacyHeaders: false,
});

/**
 * AUTH RATE LIMITER (stricter)
 * Applied specifically to login/signup/password-reset endpoints.
 * Prevents brute-force password guessing attacks.
 *
 * Default: 10 attempts per 15 minutes per IP.
 */
export const authLimiter = rateLimit({
  windowMs: config.rateLimitWindowMs,
  max: config.authRateLimitMax,
  message: {
    success: false,
    message: 'Too many authentication attempts. Please try again later.',
  },
  standardHeaders: true,
  legacyHeaders: false,
});

/**
 * SPEED LIMITER
 * Gradually slows down responses for repeat offenders instead of
 * hard-blocking. After 50 requests, each subsequent request gets
 * an additional 500ms delay. This discourages scrapers/bots without
 * punishing legitimate users who momentarily spike.
 */
export const speedLimiter = slowDown({
  windowMs: config.rateLimitWindowMs,
  delayAfter: 50,
  delayMs: (hits) => hits * 500,
});

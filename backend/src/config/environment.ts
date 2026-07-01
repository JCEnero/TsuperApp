import dotenv from 'dotenv';

dotenv.config();

/**
 * Validates that all required environment variables are present.
 * The server will NOT start if any are missing — this prevents
 * deploying a broken build to production.
 */
function getEnvVar(key: string, required = true): string {
  const value = process.env[key];
  if (required && (!value || value.trim() === '')) {
    throw new Error(
      `❌ Missing required environment variable: ${key}. Check your .env file.`
    );
  }
  return value || '';
}

export const config = {
  // Server
  port: parseInt(process.env.PORT || '3000', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  isProduction: process.env.NODE_ENV === 'production',

  // Supabase (all required — server can't function without these)
  supabaseUrl: getEnvVar('SUPABASE_URL'),
  supabaseAnonKey: getEnvVar('SUPABASE_ANON_KEY'),
  supabaseServiceRoleKey: getEnvVar('SUPABASE_SERVICE_ROLE_KEY'),

  // CORS — in production, restrict to your app's domain only
  corsOrigin: process.env.CORS_ORIGIN || '*',

  // Rate limiting
  rateLimitWindowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000', 10), // 15 minutes
  rateLimitMax: parseInt(process.env.RATE_LIMIT_MAX || '100', 10), // 100 requests per window
  authRateLimitMax: parseInt(process.env.AUTH_RATE_LIMIT_MAX || '10', 10), // 10 auth attempts per window
};

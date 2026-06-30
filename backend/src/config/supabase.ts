import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { config } from './environment';

// Admin client - uses service role key (bypasses RLS)
// Use this for server-side operations
export const supabaseAdmin: SupabaseClient = createClient(
  config.supabaseUrl,
  config.supabaseServiceRoleKey
);

// Public client - uses anon key (respects RLS)
// Use this when you want RLS to apply
export const supabasePublic: SupabaseClient = createClient(
  config.supabaseUrl,
  config.supabaseAnonKey
);

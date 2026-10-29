/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 * 
 * Supabase Setup Boilerplate Code & Auth Connection Guide
 * Copy and use this code when initializing your new Supabase project.
 */

export const SUPABASE_CLIENT_BOILERPLATE = `import { createClient } from '@supabase/supabase-js';

// 1. Read configuration from environment variables or custom config
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://YOUR_PROJECT_ID.supabase.co';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'YOUR_ANON_PUBLIC_KEY';

// 2. Network Timeout & Latency Resilience Wrapper
const TIMEOUT_MS = 10000; // 10s connection timeout

const fetchWithTimeout = async (input: RequestInfo | URL, init?: RequestInit): Promise<Response> => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(input, {
      ...init,
      signal: controller.signal,
    });
    clearTimeout(timeoutId);
    return response;
  } catch (error: any) {
    clearTimeout(timeoutId);
    if (error.name === 'AbortError') {
      throw new Error('Supabase network connection timeout (latency limit exceeded).');
    }
    throw error;
  }
};

// 3. Create the Supabase Client with full Auth and Realtime capabilities
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
  global: {
    fetch: fetchWithTimeout,
  },
});

// 4. Test connection & measure latency
export async function testConnection(): Promise<{ ok: boolean; latencyMs: number; error?: string }> {
  const start = Date.now();
  try {
    const { error } = await supabase.from('school_state').select('key').limit(1);
    if (error && !error.message.includes('does not exist')) throw error;
    return { ok: true, latencyMs: Date.now() - start };
  } catch (err: any) {
    return { ok: false, latencyMs: Date.now() - start, error: err.message };
  }
}
`;

export const SUPABASE_AUTH_BOILERPLATE = `import { supabase } from './supabase';

/**
 * Stanbax Schools Student & Staff Authentication Service
 */
export class AuthService {
  // Sign in with Email / Password via Supabase Auth
  static async signIn(email: string, password = 'stanbax2025') {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) throw error;
    return data;
  }

  // Sign up a scholar or staff member
  static async signUp(email: string, password = 'stanbax2025', userMetadata = {}) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userMetadata,
      },
    });
    if (error) throw error;
    return data;
  }

  // Sign out
  static async signOut() {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
  }

  // Get current active session
  static async getSession() {
    const { data: { session }, error } = await supabase.auth.getSession();
    if (error) throw error;
    return session;
  }
}
`;

/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 * 
 * Production-ready Supabase Client with Resilient State Sync,
 * Connection Timeout Handling, and Network Latency Retries.
 */

import { createClient, type SupabaseClient } from '@supabase/supabase-js';

export interface SupabaseConfig {
  url: string;
  anonKey: string;
  isConfigured: boolean;
  source: 'env' | 'localStorage' | 'none';
}

export type ConnectionStatus = 'connected' | 'connecting' | 'syncing' | 'offline' | 'error' | 'unconfigured';

export interface SupabaseHealth {
  status: ConnectionStatus;
  latencyMs: number | null;
  message: string;
  lastSyncTime: string | null;
  tablesVerified: boolean;
}

const STORAGE_URL_KEY = 'stanbax_supabase_url';
const STORAGE_KEY_KEY = 'stanbax_supabase_anon_key';
const TIMEOUT_MS = 9000; // 9 seconds network timeout
const MAX_RETRIES = 2;

// Read Supabase config with environment precedence, fallback to localStorage
export function getSupabaseConfig(): SupabaseConfig {
  let envUrl = (import.meta.env?.VITE_SUPABASE_URL as string | undefined)?.trim();
  let envKey = (import.meta.env?.VITE_SUPABASE_ANON_KEY as string | undefined)?.trim();

  if (envUrl) envUrl = envUrl.replace(/\/+$/, '');
  if (envUrl && envKey && !envUrl.includes('your-project-id')) {
    return { url: envUrl, anonKey: envKey, isConfigured: true, source: 'env' };
  }

  let localUrl = '';
  let localKey = '';
  try {
    localUrl = (localStorage.getItem(STORAGE_URL_KEY) || '').trim();
    localKey = (localStorage.getItem(STORAGE_KEY_KEY) || '').trim();
    if (localUrl) localUrl = localUrl.replace(/\/+$/, '');
  } catch {}

  if (localUrl && localKey) {
    return { url: localUrl, anonKey: localKey, isConfigured: true, source: 'localStorage' };
  }

  return { url: envUrl || '', anonKey: envKey || '', isConfigured: false, source: 'none' };
}

// Fetch wrapper with timeout and latency error handling
const fetchWithTimeout: typeof fetch = async (input, init) => {
  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), TIMEOUT_MS);
  try {
    const response = await fetch(input, {
      ...init,
      signal: controller.signal,
    });
    clearTimeout(id);
    return response;
  } catch (error: any) {
    clearTimeout(id);
    if (error.name === 'AbortError') {
      throw new Error(`Connection timeout: Supabase server took longer than ${TIMEOUT_MS / 1000}s to respond.`);
    }
    throw error;
  }
};

let clientInstance: SupabaseClient | null = null;
let lastConfigHash = '';

export function getSupabaseClient(): SupabaseClient | null {
  const cfg = getSupabaseConfig();
  if (!cfg.isConfigured || !cfg.url || !cfg.anonKey) {
    return null;
  }
  const hash = `${cfg.url}:${cfg.anonKey}`;
  if (!clientInstance || lastConfigHash !== hash) {
    try {
      clientInstance = createClient(cfg.url, cfg.anonKey, {
        auth: {
          persistSession: true,
          autoRefreshToken: true,
          detectSessionInUrl: true,
        },
        global: {
          fetch: fetchWithTimeout,
        },
      });
      lastConfigHash = hash;
    } catch (err) {
      console.error('[Supabase Init Error]', err);
      clientInstance = null;
    }
  }
  return clientInstance;
}

export function saveSupabaseConfig(url: string, anonKey: string): boolean {
  try {
    const cleanUrl = url.trim().replace(/\/+$/, '');
    const cleanKey = anonKey.trim();
    localStorage.setItem(STORAGE_URL_KEY, cleanUrl);
    localStorage.setItem(STORAGE_KEY_KEY, cleanKey);
    clientInstance = null; // force recreation
    return true;
  } catch (err) {
    console.error('Failed to save Supabase config in localStorage:', err);
    return false;
  }
}

export function clearSupabaseConfig(): void {
  try {
    localStorage.removeItem(STORAGE_URL_KEY);
    localStorage.removeItem(STORAGE_KEY_KEY);
    clientInstance = null;
  } catch {}
}

// Health check and latency ping
export async function testSupabaseConnection(): Promise<SupabaseHealth> {
  const client = getSupabaseClient();
  if (!client) {
    return {
      status: 'unconfigured',
      latencyMs: null,
      message: 'Supabase URL and Anon Key are not configured yet.',
      lastSyncTime: null,
      tablesVerified: false,
    };
  }

  const startTime = Date.now();
  try {
    // Try pinging public.school_state or public.students
    const { error: stateErr } = await client
      .from('school_state')
      .select('key')
      .limit(1);

    const latency = Date.now() - startTime;

    if (stateErr && stateErr.code !== 'PGRST116') {
      // If table doesn't exist yet, check if connection is reachable
      if (stateErr.message?.includes('relation') || stateErr.message?.includes('does not exist')) {
        return {
          status: 'connected',
          latencyMs: latency,
          message: 'Connected to Supabase! (Tables need initialization via schema.sql)',
          lastSyncTime: new Date().toISOString(),
          tablesVerified: false,
        };
      }
      throw stateErr;
    }

    return {
      status: 'connected',
      latencyMs: latency,
      message: `Connected successfully (${latency}ms latency).`,
      lastSyncTime: new Date().toISOString(),
      tablesVerified: true,
    };
  } catch (err: any) {
    const latency = Date.now() - startTime;
    return {
      status: 'error',
      latencyMs: latency,
      message: err.message || 'Failed to connect to Supabase.',
      lastSyncTime: null,
      tablesVerified: false,
    };
  }
}

// Resilient wrapper with exponential backoff for network latency
async function withRetry<T>(operation: () => Promise<T>, attempts = MAX_RETRIES): Promise<T> {
  let lastErr: any;
  for (let i = 0; i <= attempts; i++) {
    try {
      return await operation();
    } catch (err: any) {
      lastErr = err;
      if (i < attempts) {
        const delay = Math.pow(2, i) * 600;
        await new Promise(res => setTimeout(res, delay));
      }
    }
  }
  throw lastErr;
}

// ----------------------------------------------------------------------
// DATA SYNCHRONIZATION APIS
// ----------------------------------------------------------------------

/**
 * Sync generic school state to Supabase table `school_state`
 * (e.g. 'stanbax_school_info', 'stanbax_app_images', 'stanbax_notices')
 */
export async function syncStateOnline(key: string, data: any): Promise<boolean> {
  const client = getSupabaseClient();
  if (!client) {
    // Save to local storage as fallback
    try {
      localStorage.setItem(key, typeof data === 'string' ? data : JSON.stringify(data));
    } catch {}
    return false;
  }

  try {
    await withRetry(async () => {
      const payload = {
        key,
        data: typeof data === 'string' ? JSON.parse(data) : data,
        updated_at: new Date().toISOString(),
      };
      const { error } = await client
        .from('school_state')
        .upsert(payload, { onConflict: 'key' });
      if (error) throw error;
    });
    // Also keep local storage warm
    try {
      localStorage.setItem(key, typeof data === 'string' ? data : JSON.stringify(data));
    } catch {}
    return true;
  } catch (err) {
    console.warn(`[Supabase Sync Warning] Failed to sync ${key}:`, err);
    try {
      localStorage.setItem(key, typeof data === 'string' ? data : JSON.stringify(data));
    } catch {}
    return false;
  }
}

/**
 * Retrieve remote state from Supabase
 */
export async function fetchRemoteState<T = any>(key: string): Promise<T | null> {
  const client = getSupabaseClient();
  if (!client) return null;

  try {
    return await withRetry(async () => {
      const { data, error } = await client
        .from('school_state')
        .select('data')
        .eq('key', key)
        .single();
      if (error) {
        if (error.code === 'PGRST116') return null; // not found
        throw error;
      }
      return data?.data as T;
    });
  } catch (err) {
    console.warn(`[Supabase Fetch Warning] Could not fetch ${key}:`, err);
    return null;
  }
}

/**
 * Sync entire students roster to Supabase `students` table
 */
export async function syncStudentsOnline(students: any[]): Promise<boolean> {
  const client = getSupabaseClient();
  if (!client || !Array.isArray(students) || students.length === 0) return false;

  try {
    const formatted = students.map(s => ({
      id: s.id,
      reg_number: s.regNumber,
      name: s.name,
      gender: s.gender || 'Male',
      age: s.age || 13,
      grade: s.grade,
      password: s.password || 'stanbax2025',
      aliases: s.aliases || [s.name],
      midterm_scores: s.midtermScores2026 || {},
      grades: s.grades || [],
      fee_status: s.feeStatus || 'Fully Paid',
      updated_at: new Date().toISOString(),
    }));

    await withRetry(async () => {
      const { error } = await client
        .from('students')
        .upsert(formatted, { onConflict: 'id' });
      if (error) throw error;
    });

    // Also mirror to school_state for instant atomic hydration
    await client.from('school_state').upsert({
      key: 'stanbax_students',
      data: students,
      updated_at: new Date().toISOString(),
    }, { onConflict: 'key' });

    return true;
  } catch (err) {
    console.error('[Supabase Student Sync Error]', err);
    return false;
  }
}

/**
 * Fetch students from Supabase
 */
export async function fetchRemoteStudents(): Promise<any[] | null> {
  const client = getSupabaseClient();
  if (!client) return null;

  try {
    // 1. Try school_state atomic cache
    const cached = await fetchRemoteState<any[]>('stanbax_students');
    if (cached && Array.isArray(cached) && cached.length > 0) {
      return cached;
    }

    // 2. Query students table
    const { data, error } = await client
      .from('students')
      .select('*')
      .order('name');

    if (error) throw error;
    if (data && data.length > 0) {
      return data.map(d => ({
        id: d.id,
        regNumber: d.reg_number,
        name: d.name,
        gender: d.gender,
        age: d.age,
        grade: d.grade,
        password: d.password,
        aliases: d.aliases,
        midtermScores2026: d.midterm_scores,
        grades: d.grades,
        feeStatus: d.fee_status,
      }));
    }
    return null;
  } catch (err) {
    console.warn('[Supabase Fetch Students Error]', err);
    return null;
  }
}

/**
 * Upload an image (base64 or blob) to Supabase so it persists across all devices
 */
export async function uploadImageOnline(name: string, dataUrl: string): Promise<string | null> {
  const client = getSupabaseClient();
  if (!client) return null;

  try {
    await withRetry(async () => {
      const { error } = await client
        .from('images')
        .upsert({
          id: `img_${name.toLowerCase().replace(/[^a-z0-9]/g, '_')}`,
          filename: name,
          data: dataUrl,
          created_at: new Date().toISOString(),
        }, { onConflict: 'id' });
      if (error) throw error;
    });
    return dataUrl;
  } catch (err) {
    console.error(`[Supabase Upload Image Error for ${name}]`, err);
    return null;
  }
}

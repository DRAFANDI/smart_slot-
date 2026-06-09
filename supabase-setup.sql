-- ============================================================
-- Smart Slots — Secure Supabase Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

CREATE TABLE IF NOT EXISTS public.offers (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  full_name    TEXT NOT NULL,
  mobile       TEXT NOT NULL,
  service      TEXT NOT NULL CHECK (service IN ('laser','filler','botox')),
  offer_amount INTEGER NOT NULL CHECK (offer_amount > 0),
  status       TEXT NOT NULL DEFAULT 'pending'
               CHECK (status IN ('pending','accepted','rejected','waitlist')),
  attended     BOOLEAN DEFAULT FALSE,
  notes        TEXT DEFAULT ''
);

ALTER TABLE public.offers ENABLE ROW LEVEL SECURITY;

-- Clean old policies if re-running
DROP POLICY IF EXISTS "Anyone can submit offer" ON public.offers;
DROP POLICY IF EXISTS "Anyone can count accepted" ON public.offers;
DROP POLICY IF EXISTS "Service role full access" ON public.offers;
DROP POLICY IF EXISTS "public_insert_only" ON public.offers;
DROP POLICY IF EXISTS "admin_select_offers" ON public.offers;
DROP POLICY IF EXISTS "admin_update_offers" ON public.offers;

-- Public patient page: can only submit offers
CREATE POLICY "public_insert_only"
ON public.offers
FOR INSERT
TO anon
WITH CHECK (
  status = 'pending'
  AND attended = false
);

-- Admin dashboard: authenticated Supabase users can read offers
CREATE POLICY "admin_select_offers"
ON public.offers
FOR SELECT
TO authenticated
USING (true);

-- Admin dashboard: authenticated Supabase users can update status/attended/notes
CREATE POLICY "admin_update_offers"
ON public.offers
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Realtime
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
    AND schemaname = 'public'
    AND tablename = 'offers'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.offers;
  END IF;
END $$;

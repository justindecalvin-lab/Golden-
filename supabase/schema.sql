-- ============================================================================
-- STANBAX SCHOOLS IBADAN — Supabase Master Production Schema
-- Run this in Supabase Dashboard -> SQL Editor -> Run to initialize your database.
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS public.school_state (
  key TEXT PRIMARY KEY,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.students (
  id TEXT PRIMARY KEY,
  reg_number TEXT UNIQUE,
  name TEXT NOT NULL,
  gender TEXT DEFAULT 'Male',
  age INTEGER DEFAULT 13,
  grade TEXT NOT NULL,
  password TEXT DEFAULT 'stanbax2025',
  aliases TEXT[] DEFAULT '{}',
  midterm_scores JSONB DEFAULT '{}',
  grades JSONB DEFAULT '[]',
  fee_status TEXT DEFAULT 'Fully Paid',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS students_reg_idx ON public.students (lower(reg_number));
CREATE INDEX IF NOT EXISTS students_name_idx ON public.students (lower(name));
CREATE INDEX IF NOT EXISTS students_grade_idx ON public.students (grade);

CREATE TABLE IF NOT EXISTS public.images (
  id TEXT PRIMARY KEY,
  filename TEXT NOT NULL,
  data TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.tutors (
  id TEXT PRIMARY KEY,
  staff_id TEXT,
  name TEXT NOT NULL,
  email TEXT,
  role TEXT,
  department TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.parents (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  student_reg_numbers TEXT[],
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  action TEXT NOT NULL,
  entity TEXT NOT NULL,
  actor TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.school_state ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.images ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tutors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Public read school_state" ON public.school_state;
  DROP POLICY IF EXISTS "Public write school_state" ON public.school_state;
  DROP POLICY IF EXISTS "Public read students" ON public.students;
  DROP POLICY IF EXISTS "Public write students" ON public.students;
  DROP POLICY IF EXISTS "Public read images" ON public.images;
  DROP POLICY IF EXISTS "Public write images" ON public.images;
  DROP POLICY IF EXISTS "Public read tutors" ON public.tutors;
  DROP POLICY IF EXISTS "Public write tutors" ON public.tutors;
  DROP POLICY IF EXISTS "Public read parents" ON public.parents;
  DROP POLICY IF EXISTS "Public write parents" ON public.parents;
  DROP POLICY IF EXISTS "Public read audit_logs" ON public.audit_logs;
  DROP POLICY IF EXISTS "Public write audit_logs" ON public.audit_logs;
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

CREATE POLICY "Public read school_state" ON public.school_state FOR SELECT USING (true);
CREATE POLICY "Public write school_state" ON public.school_state FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public read students" ON public.students FOR SELECT USING (true);
CREATE POLICY "Public write students" ON public.students FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public read images" ON public.images FOR SELECT USING (true);
CREATE POLICY "Public write images" ON public.images FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public read tutors" ON public.tutors FOR SELECT USING (true);
CREATE POLICY "Public write tutors" ON public.tutors FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public read parents" ON public.parents FOR SELECT USING (true);
CREATE POLICY "Public write parents" ON public.parents FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public read audit_logs" ON public.audit_logs FOR SELECT USING (true);
CREATE POLICY "Public write audit_logs" ON public.audit_logs FOR ALL USING (true) WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- SEED DATA: 94 Scholars (SS3: 4 Science, 2 Arts; SS2: 2 Science, 3 Arts; SS1: 4 Science, 3 Arts)
-- ----------------------------------------------------------------------------
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793088157005',
  'STX/2026/141',
  'Taofeek Fawas',
  'Male',
  16,
  'SSS 2 Arts & Commercial',
  'stanbax2025',
  ARRAY['Taofeek Fawas', 'fawas taofeek', 'taofeek fawas']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":5},"English Language":{"ca1":10,"ca2":10},"Citizenship and Heritage Studies":{"ca1":8,"ca2":5},"Digital Technology":{"ca1":7,"ca2":10},"Literature in English":{"ca1":8,"ca2":8},"Livestock Farming":{"ca1":8,"ca2":8},"Government":{"ca1":6,"ca2":6},"Further Mathematics":{"ca1":10,"ca2":10},"Yoruba":{"ca1":5,"ca2":5}}'::JSONB,
  '[{"id":"grd-std-1793088157005-1","subject":"Mathematics","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-3","subject":"Citizenship and Heritage Studies","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-4","subject":"Digital Technology","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-5","subject":"Literature in English","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-6","subject":"Livestock Farming","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-7","subject":"Government","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-8","subject":"Further Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088157005-9","subject":"Yoruba","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793088119939',
  'STX/2026/140',
  'Alabi Blessing',
  'Female',
  16,
  'SSS 2 Science',
  'stanbax2025',
  ARRAY['Alabi Blessing', 'blessing alabi', 'alabi blessing']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English Language":{"ca1":10,"ca2":10},"Physics":{"ca1":7,"ca2":6},"Chemistry":{"ca1":5,"ca2":5},"Digital Technology":{"ca1":7,"ca2":10},"Livestock Farming":{"ca1":10,"ca2":10},"Further Mathematics":{"ca1":10,"ca2":10},"Citizenship and Heritage Studies":{"ca1":10,"ca2":2}}'::JSONB,
  '[{"id":"grd-std-1793088119939-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-3","subject":"Physics","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-4","subject":"Chemistry","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-5","subject":"Digital Technology","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-6","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-7","subject":"Further Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088119939-8","subject":"Citizenship and Heritage Studies","ca1":10,"ca2":2,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793088079535',
  'STX/2026/139',
  'Oladele Esther Ayomide',
  'Female',
  16,
  'SSS 2 Arts & Commercial',
  'stanbax2025',
  ARRAY['Oladele Esther Ayomide', 'ayomide oladele', 'oladele ayomide']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English Language":{"ca1":10,"ca2":10},"Citizenship and Heritage Studies":{"ca1":8,"ca2":5},"Digital Technology":{"ca1":8,"ca2":10},"Literature in English":{"ca1":9,"ca2":9},"Livestock Farming":{"ca1":10,"ca2":10},"Government":{"ca1":8,"ca2":8},"Further Mathematics":{"ca1":10,"ca2":10},"Yoruba":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-std-1793088079535-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-3","subject":"Citizenship and Heritage Studies","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-4","subject":"Digital Technology","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-5","subject":"Literature in English","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-6","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-7","subject":"Government","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-8","subject":"Further Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793088079535-9","subject":"Yoruba","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793087173045',
  'STX/2026/138',
  'Agboola Darasimi',
  'Female',
  3,
  'Creche & Playgroup',
  'stanbax2025',
  ARRAY['Agboola Darasimi', 'darasimi agboola', 'agboola darasimi']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-std-1793087173045-numeracy","ca1":5,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":11,"remark":"Fail","subject":"Numeracy","term1Total":11,"annualAverage":11}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793087092577',
  'STX/2026/137',
  'Oladipo',
  'Male',
  3,
  'Creche & Playgroup',
  'stanbax2025',
  ARRAY[]::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793087074068',
  'STX/2026/136',
  'Chidi Wealth',
  'Male',
  3,
  'Creche & Playgroup',
  'stanbax2025',
  ARRAY['Chidi Wealth', 'wealth chidi', 'chidi wealth']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793087052820',
  'STX/2026/135',
  'Balogun Richard',
  'Male',
  3,
  'Creche & Playgroup',
  'stanbax2025',
  ARRAY['Balogun Richard', 'richard balogun', 'balogun richard']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793087031610',
  'STX/2026/134',
  'Ajibowo Emmanuel',
  'Male',
  3,
  'Creche & Playgroup',
  'stanbax2025',
  ARRAY['Ajibowo Emmanuel', 'emmanuel ajibowo', 'ajibowo emmanuel']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793087016825',
  'STX/2026/133',
  'AlabiAde David',
  'Male',
  3,
  'Creche & Playgroup',
  'stanbax2025',
  ARRAY['AlabiAde David', 'david alabiade', 'alabiade david']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086983455',
  'STX/2026/132',
  'Chidi Mirabel',
  'Female',
  13,
  'Nursery',
  'stanbax2025',
  ARRAY['Chidi Mirabel', 'mirabel chidi', 'chidi mirabel']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086957950',
  'STX/2026/131',
  'Mustapha Morire',
  'Female',
  13,
  'Nursery',
  'stanbax2025',
  ARRAY['Mustapha Morire', 'morire mustapha', 'mustapha morire']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086924761',
  'STX/2026/130',
  'Ezeani Mmesoma',
  'Female',
  13,
  'Nursery',
  'stanbax2025',
  ARRAY['Ezeani Mmesoma', 'mmesoma ezeani', 'ezeani mmesoma']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086874023',
  'STX/2026/129',
  'Akeredolu Ilerioluwa',
  'Female',
  13,
  'Nursery',
  'stanbax2025',
  ARRAY['Akeredolu Ilerioluwa', 'ilerioluwa akeredolu', 'akeredolu ilerioluwa']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086763969',
  'STX/2026/128',
  'Titcombe Ayobola',
  'Male',
  13,
  'Nursery',
  'stanbax2025',
  ARRAY['Titcombe Ayobola', 'ayobola titcombe', 'titcombe ayobola']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086722511',
  'STX/2026/127',
  'Oluwaseyi Wilfred',
  'Male',
  13,
  'Nursery',
  'stanbax2025',
  ARRAY['Oluwaseyi Wilfred', 'wilfred oluwaseyi', 'oluwaseyi wilfred']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086503433',
  'STX/2026/126',
  'Taofeek Basit',
  'Male',
  8,
  'Primary 3',
  'stanbax2025',
  ARRAY['Taofeek Basit', 'basit taofeek', 'taofeek basit']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":8},"English":{"ca1":8,"ca2":8},"Basic Science":{"ca1":10,"ca2":8},"Pre-Vocational":{"ca1":8,"ca2":5},"Social Citizenship":{"ca1":8,"ca2":5},"BSE":{"ca1":8,"ca2":5},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":10,"ca2":6},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":6},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":5,"ca2":5},"Computer":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-std-1793086503433-1","subject":"Mathematics","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-2","subject":"English","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-3","subject":"Basic Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-4","subject":"Pre-Vocational","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-5","subject":"Social Citizenship","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-6","subject":"BSE","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-8","subject":"CCA","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-11","subject":"PHE","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-13","subject":"Writing","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086503433-14","subject":"Computer","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086478324',
  'STX/2026/125',
  'Babalola Boluwatife',
  'Female',
  8,
  'Primary 3',
  'stanbax2025',
  ARRAY['Babalola Boluwatife', 'boluwatife babalola', 'babalola boluwatife']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":8},"English":{"ca1":8,"ca2":8},"Basic Science":{"ca1":6,"ca2":7},"Pre-Vocational":{"ca1":6,"ca2":7},"Social Citizenship":{"ca1":6,"ca2":7},"BSE":{"ca1":10,"ca2":5},"PVS":{"ca1":7,"ca2":10},"CCA":{"ca1":2,"ca2":7},"Literature":{"ca1":8,"ca2":8},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":6},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":8,"ca2":8},"Computer":{"ca1":10.5,"ca2":6}}'::JSONB,
  '[{"id":"grd-std-1793086478324-1","subject":"Mathematics","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-2","subject":"English","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-3","subject":"Basic Science","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-4","subject":"Pre-Vocational","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-5","subject":"Social Citizenship","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-6","subject":"BSE","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-7","subject":"PVS","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-8","subject":"CCA","ca1":2,"ca2":7,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-9","subject":"Literature","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-11","subject":"PHE","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-13","subject":"Writing","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086478324-14","subject":"Computer","ca1":10.5,"ca2":6,"ca3":0,"exam":0,"total":16.5,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086418715',
  'STX/2026/124',
  'Raheem Enoch',
  'Male',
  4,
  'KG 1',
  'stanbax2025',
  ARRAY['Raheem Enoch', 'enoch raheem', 'raheem enoch']::TEXT[],
  '{"Basic Science":{"ca1":10,"ca2":9},"Social Studies":{"ca1":10,"ca2":10},"Personal Development":{"ca1":8,"ca2":10},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Civic":{"ca1":10,"ca2":7},"Creativity":{"ca1":10,"ca2":7},"Social Habit":{"ca1":10,"ca2":10},"Moral Instruction":{"ca1":10,"ca2":10},"Numeracy":{"ca1":10,"ca2":10},"Literature":{"ca1":7,"ca2":7}}'::JSONB,
  '[{"id":"grd-std-1793086418715-1","subject":"Basic Science","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-2","subject":"Social Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-3","subject":"Personal Development","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-4","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-5","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-6","subject":"Civic","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-7","subject":"Creativity","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-8","subject":"Social Habit","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-9","subject":"Moral Instruction","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-10","subject":"Numeracy","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086418715-11","subject":"Literature","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086396485',
  'STX/2026/123',
  'Obi Elizabeth',
  'Female',
  4,
  'KG 1',
  'stanbax2025',
  ARRAY['Obi Elizabeth', 'elizabeth obi', 'obi elizabeth']::TEXT[],
  '{"Basic Science":{"ca1":6,"ca2":5},"Social Studies":{"ca1":10,"ca2":10},"Personal Development":{"ca1":8,"ca2":6},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Civic":{"ca1":10,"ca2":6},"Creativity":{"ca1":10,"ca2":9},"Social Habit":{"ca1":10,"ca2":10},"Moral Instruction":{"ca1":10,"ca2":7},"Numeracy":{"ca1":7,"ca2":6},"Literature":{"ca1":7,"ca2":8}}'::JSONB,
  '[{"id":"grd-std-1793086396485-1","subject":"Basic Science","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-2","subject":"Social Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-3","subject":"Personal Development","ca1":8,"ca2":6,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-4","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-5","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-6","subject":"Civic","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-7","subject":"Creativity","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-8","subject":"Social Habit","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-9","subject":"Moral Instruction","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-10","subject":"Numeracy","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086396485-11","subject":"Literature","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086383232',
  'STX/2026/122',
  'Kehinde Darasimi',
  'Female',
  4,
  'KG 1',
  'stanbax2025',
  ARRAY['Kehinde Darasimi', 'darasimi kehinde', 'kehinde darasimi']::TEXT[],
  '{"Basic Science":{"ca1":7,"ca2":7},"Social Studies":{"ca1":10,"ca2":10},"Personal Development":{"ca1":6,"ca2":6},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Civic":{"ca1":10,"ca2":5},"Creativity":{"ca1":10,"ca2":9},"Social Habit":{"ca1":10,"ca2":10},"Moral Instruction":{"ca1":10,"ca2":7},"Numeracy":{"ca1":5,"ca2":6},"Literature":{"ca1":7,"ca2":7}}'::JSONB,
  '[{"id":"grd-std-1793086383232-1","subject":"Basic Science","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-2","subject":"Social Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-3","subject":"Personal Development","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-4","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-5","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-6","subject":"Civic","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-7","subject":"Creativity","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-8","subject":"Social Habit","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-9","subject":"Moral Instruction","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-10","subject":"Numeracy","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086383232-11","subject":"Literature","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086337458',
  'STX/2026/121',
  'Bello Matin',
  'Male',
  4,
  'KG 1',
  'stanbax2025',
  ARRAY['Bello Matin', 'matin bello', 'bello matin']::TEXT[],
  '{"Basic Science":{"ca1":7,"ca2":7},"Social Studies":{"ca1":10,"ca2":10},"Personal Development":{"ca1":6,"ca2":10},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Civic":{"ca1":10,"ca2":7},"Creativity":{"ca1":10,"ca2":7},"Social Habit":{"ca1":8,"ca2":8},"Moral Instruction":{"ca1":10,"ca2":7},"Numeracy":{"ca1":10,"ca2":10},"Literature":{"ca1":6,"ca2":7}}'::JSONB,
  '[{"id":"grd-std-1793086337458-1","subject":"Basic Science","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-2","subject":"Social Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-3","subject":"Personal Development","ca1":6,"ca2":10,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-4","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-5","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-6","subject":"Civic","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-7","subject":"Creativity","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-8","subject":"Social Habit","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-9","subject":"Moral Instruction","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-10","subject":"Numeracy","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086337458-11","subject":"Literature","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086315759',
  'STX/2026/120',
  'Balogun Anabel',
  'Female',
  4,
  'KG 1',
  'stanbax2025',
  ARRAY['Balogun Anabel', 'anabel balogun', 'balogun anabel']::TEXT[],
  '{"Basic Science":{"ca1":10,"ca2":10},"Social Studies":{"ca1":10,"ca2":10},"Personal Development":{"ca1":10,"ca2":10},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Civic":{"ca1":10,"ca2":10},"Creativity":{"ca1":10,"ca2":10},"Social Habit":{"ca1":10,"ca2":10},"Moral Instruction":{"ca1":10,"ca2":7},"Numeracy":{"ca1":10,"ca2":10},"Literature":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793086315759-1","subject":"Basic Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-2","subject":"Social Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-3","subject":"Personal Development","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-4","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-5","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-6","subject":"Civic","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-7","subject":"Creativity","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-8","subject":"Social Habit","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-9","subject":"Moral Instruction","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-10","subject":"Numeracy","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086315759-11","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086239453',
  'STX/2026/119',
  'Akinosho Tamim',
  'Male',
  4,
  'KG 1',
  'stanbax2025',
  ARRAY['Akinosho Tamim', 'tamim akinosho', 'akinosho tamim']::TEXT[],
  '{"Basic Science":{"ca1":10,"ca2":10},"Social Studies":{"ca1":10,"ca2":10},"Personal Development":{"ca1":10,"ca2":10},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Civic":{"ca1":10,"ca2":10},"Creativity":{"ca1":9,"ca2":7},"Social Habit":{"ca1":10,"ca2":10},"Moral Instruction":{"ca1":10,"ca2":7},"Numeracy":{"ca1":10,"ca2":10},"Literature":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793086239453-1","subject":"Basic Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-2","subject":"Social Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-3","subject":"Personal Development","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-4","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-5","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-6","subject":"Civic","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-7","subject":"Creativity","ca1":9,"ca2":7,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-8","subject":"Social Habit","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-9","subject":"Moral Instruction","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-10","subject":"Numeracy","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086239453-11","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086194189',
  'STX/2026/118',
  'Oniigho Vigor',
  'Male',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Oniigho Vigor', 'vigor oniigho', 'oniigho vigor', 'Onyigho Vigor']::TEXT[],
  '{"Yoruba":{"ca1":7,"ca2":7},"CRS":{"ca1":8,"ca2":8},"Livestock":{"ca1":6,"ca2":7},"B.S.":{"ca1":9,"ca2":6},"PHE":{"ca1":10,"ca2":9},"History":{"ca1":9,"ca2":6},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":9,"ca2":7},"Intermediate Science":{"ca1":8,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":9},"Mathematics":{"ca1":5,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793086194189-1","subject":"Yoruba","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-2","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-3","subject":"Livestock","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-4","subject":"B.S.","ca1":9,"ca2":6,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-5","subject":"PHE","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-6","subject":"History","ca1":9,"ca2":6,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-8","subject":"CCA","ca1":9,"ca2":7,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-9","subject":"Intermediate Science","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-10","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-11","subject":"English","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086194189-12","subject":"Mathematics","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086120588',
  'STX/2026/116',
  'Oliva Afomachukwu',
  'Female',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Oliva Afomachukwu', 'afomachukwu oliva', 'oliva afomachukwu', 'Oliver Afomachukwu']::TEXT[],
  '{"Yoruba":{"ca1":8,"ca2":8},"CRS":{"ca1":8,"ca2":8},"Livestock":{"ca1":8,"ca2":8},"B.S.":{"ca1":8,"ca2":9},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":8,"ca2":10},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":9,"ca2":9},"Intermediate Science":{"ca1":10,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":9},"Mathematics":{"ca1":5,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793086120588-1","subject":"Yoruba","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-2","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-3","subject":"Livestock","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-4","subject":"B.S.","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-5","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-6","subject":"History","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-8","subject":"CCA","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-9","subject":"Intermediate Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-10","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-11","subject":"English","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086120588-12","subject":"Mathematics","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086078594',
  'STX/2026/115',
  'Odubanjo Samuel',
  'Male',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Odubanjo Samuel', 'samuel odubanjo', 'odubanjo samuel']::TEXT[],
  '{"Yoruba":{"ca1":6,"ca2":5},"CRS":{"ca1":8,"ca2":8},"Livestock":{"ca1":8,"ca2":8},"B.S.":{"ca1":6,"ca2":6},"PHE":{"ca1":6,"ca2":9},"History":{"ca1":7,"ca2":10},"Business Studies":{"ca1":7,"ca2":10},"CCA":{"ca1":5,"ca2":6},"Intermediate Science":{"ca1":10,"ca2":10},"Digital Tech":{"ca1":9,"ca2":9},"English":{"ca1":10,"ca2":9},"Mathematics":{"ca1":5,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793086078594-1","subject":"Yoruba","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-2","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-3","subject":"Livestock","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-4","subject":"B.S.","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-5","subject":"PHE","ca1":6,"ca2":9,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-6","subject":"History","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-7","subject":"Business Studies","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-8","subject":"CCA","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-9","subject":"Intermediate Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-10","subject":"Digital Tech","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-11","subject":"English","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086078594-12","subject":"Mathematics","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793086039312',
  'STX/2026/114',
  'Azeez Haliyah',
  'Female',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Azeez Haliyah', 'haliyah azeez', 'azeez haliyah', 'Azeez Halliah']::TEXT[],
  '{"Yoruba":{"ca1":7,"ca2":7},"CRS":{"ca1":7,"ca2":7},"Livestock":{"ca1":4,"ca2":5},"B.S.":{"ca1":7,"ca2":5},"PHE":{"ca1":6,"ca2":4},"History":{"ca1":6,"ca2":10},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":5,"ca2":8},"Intermediate Science":{"ca1":8,"ca2":10},"Digital Tech":{"ca1":8,"ca2":8},"English":{"ca1":9,"ca2":5},"Mathematics":{"ca1":5,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793086039312-1","subject":"Yoruba","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-2","subject":"CRS","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-3","subject":"Livestock","ca1":4,"ca2":5,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-4","subject":"B.S.","ca1":7,"ca2":5,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-5","subject":"PHE","ca1":6,"ca2":4,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-6","subject":"History","ca1":6,"ca2":10,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-8","subject":"CCA","ca1":5,"ca2":8,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-9","subject":"Intermediate Science","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-10","subject":"Digital Tech","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-11","subject":"English","ca1":9,"ca2":5,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793086039312-12","subject":"Mathematics","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085989033',
  'STX/2026/113',
  'Ajibowo Jomiloju Ruth',
  'Female',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Ajibowo Jomiloju Ruth', 'ruth ajibowo', 'ajibowo ruth', 'Alibawo Jamiloju']::TEXT[],
  '{"Yoruba":{"ca1":8,"ca2":7},"CRS":{"ca1":8,"ca2":8},"Livestock":{"ca1":6,"ca2":9},"B.S.":{"ca1":6,"ca2":10},"PHE":{"ca1":9,"ca2":6},"History":{"ca1":6,"ca2":10},"Business Studies":{"ca1":8,"ca2":10},"CCA":{"ca1":5,"ca2":10},"Intermediate Science":{"ca1":8,"ca2":10},"Digital Tech":{"ca1":9,"ca2":8},"English":{"ca1":10,"ca2":6},"Mathematics":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085989033-1","subject":"Yoruba","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-2","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-3","subject":"Livestock","ca1":6,"ca2":9,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-4","subject":"B.S.","ca1":6,"ca2":10,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-5","subject":"PHE","ca1":9,"ca2":6,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-6","subject":"History","ca1":6,"ca2":10,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-7","subject":"Business Studies","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-8","subject":"CCA","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-9","subject":"Intermediate Science","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-10","subject":"Digital Tech","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-11","subject":"English","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085989033-12","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085955142',
  'STX/2026/112',
  'Ajao Esther',
  'Female',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Ajao Esther', 'esther ajao', 'ajao esther', 'Alao Esther']::TEXT[],
  '{"Yoruba":{"ca1":10,"ca2":4},"CRS":{"ca1":8,"ca2":8},"Livestock":{"ca1":9,"ca2":10},"B.S.":{"ca1":9,"ca2":6},"PHE":{"ca1":6,"ca2":6},"History":{"ca1":8,"ca2":10},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":10,"ca2":9},"Intermediate Science":{"ca1":8,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":7},"Mathematics":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085955142-1","subject":"Yoruba","ca1":10,"ca2":4,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-2","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-3","subject":"Livestock","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-4","subject":"B.S.","ca1":9,"ca2":6,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-5","subject":"PHE","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-6","subject":"History","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-8","subject":"CCA","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-9","subject":"Intermediate Science","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-10","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-11","subject":"English","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085955142-12","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085878745',
  'STX/2026/110',
  'Oladele Ayobami',
  'Male',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Oladele Ayobami', 'ayobami oladele', 'oladele ayobami']::TEXT[],
  '{"Yoruba":{"ca1":7,"ca2":7},"CRS":{"ca1":8,"ca2":8},"Livestock":{"ca1":8,"ca2":8},"B.S.":{"ca1":7,"ca2":8},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":8,"ca2":6},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":8,"ca2":9},"Intermediate Science":{"ca1":9,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":8},"Mathematics":{"ca1":5,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085878745-1","subject":"Yoruba","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-2","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-3","subject":"Livestock","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-4","subject":"B.S.","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-5","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-6","subject":"History","ca1":8,"ca2":6,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-8","subject":"CCA","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-9","subject":"Intermediate Science","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-10","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-11","subject":"English","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085878745-12","subject":"Mathematics","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085591064',
  'STX/2026/109',
  'Oladipo Darasimi',
  'Female',
  15,
  'SSS 1 Arts & Commercial',
  'stanbax2025',
  ARRAY['Oladipo Darasimi', 'darasimi oladipo', 'oladipo darasimi', 'Oladiipo Darasimi Esther']::TEXT[],
  '{"D/Tech":{"ca1":4,"ca2":10},"Yoruba":{"ca1":4,"ca2":5},"Government":{"ca1":6,"ca2":8},"Literature":{"ca1":6,"ca2":8},"C.R.S":{"ca1":5,"ca2":5},"C.H.S":{"ca1":2,"ca2":2},"L.S.F":{"ca1":9,"ca2":9},"English Studies":{"ca1":7,"ca2":5}}'::JSONB,
  '[{"id":"grd-std-1793085591064-1","subject":"D/Tech","ca1":4,"ca2":10,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-2","subject":"Yoruba","ca1":4,"ca2":5,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-3","subject":"Government","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-4","subject":"Literature","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-5","subject":"C.R.S","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-6","subject":"C.H.S","ca1":2,"ca2":2,"ca3":0,"exam":0,"total":4,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-7","subject":"L.S.F","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085591064-8","subject":"English Studies","ca1":7,"ca2":5,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085552590',
  'STX/2026/108',
  'Asimiyu Abdulsalam',
  'Male',
  15,
  'SSS 1 Arts & Commercial',
  'stanbax2025',
  ARRAY['Asimiyu Abdulsalam', 'abdulsalam asimiyu', 'asimiyu abdulsalam']::TEXT[],
  '{"D/Tech":{"ca1":6,"ca2":10},"Yoruba":{"ca1":6,"ca2":5},"Government":{"ca1":5,"ca2":8},"Literature":{"ca1":5,"ca2":8},"C.R.S":{"ca1":2,"ca2":2},"C.H.S":{"ca1":7,"ca2":7},"L.S.F":{"ca1":9,"ca2":9},"English Studies":{"ca1":10,"ca2":7}}'::JSONB,
  '[{"id":"grd-std-1793085552590-1","subject":"D/Tech","ca1":6,"ca2":10,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-2","subject":"Yoruba","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-3","subject":"Government","ca1":5,"ca2":8,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-4","subject":"Literature","ca1":5,"ca2":8,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-5","subject":"C.R.S","ca1":2,"ca2":2,"ca3":0,"exam":0,"total":4,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-6","subject":"C.H.S","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-7","subject":"L.S.F","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085552590-8","subject":"English Studies","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085517437',
  'STX/2026/107',
  'Yekinni Zainab',
  'Female',
  15,
  'SSS 1 Arts & Commercial',
  'stanbax2025',
  ARRAY['Yekinni Zainab', 'zainab yekinni', 'yekinni zainab', 'Yekinni Zainab Ojuolape']::TEXT[],
  '{"D/Tech":{"ca1":9,"ca2":10},"Yoruba":{"ca1":8,"ca2":7},"Government":{"ca1":8,"ca2":8},"Literature":{"ca1":8,"ca2":8},"C.R.S":{"ca1":9,"ca2":9},"C.H.S":{"ca1":10,"ca2":10},"L.S.F":{"ca1":10,"ca2":10},"English Studies":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085517437-1","subject":"D/Tech","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-2","subject":"Yoruba","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-3","subject":"Government","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-4","subject":"Literature","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-5","subject":"C.R.S","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-6","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-7","subject":"L.S.F","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085517437-8","subject":"English Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085480795',
  'STX/2026/106',
  'Ezenwa Vivian',
  'Female',
  15,
  'SSS 1 Science',
  'stanbax2025',
  ARRAY['Ezenwa Vivian', 'vivian ezenwa', 'ezenwa vivian']::TEXT[],
  '{"Chemistry":{"ca1":6,"ca2":5},"D/Tech":{"ca1":6,"ca2":10},"Physics":{"ca1":9,"ca2":8},"Biology":{"ca1":7,"ca2":7},"C.H.S":{"ca1":6,"ca2":6},"L.S.F":{"ca1":10,"ca2":10},"English Studies":{"ca1":7,"ca2":7}}'::JSONB,
  '[{"id":"grd-std-1793085480795-1","subject":"Chemistry","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085480795-2","subject":"D/Tech","ca1":6,"ca2":10,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085480795-3","subject":"Physics","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085480795-4","subject":"Biology","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085480795-5","subject":"C.H.S","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085480795-6","subject":"L.S.F","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085480795-7","subject":"English Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085442114',
  'STX/2026/105',
  'Yekinni Omotoyosi',
  'Female',
  15,
  'SSS 1 Science',
  'stanbax2025',
  ARRAY['Yekinni Omotoyosi', 'omotoyosi yekinni', 'yekinni omotoyosi', 'Yekinni Omotoyosi Oreduwa']::TEXT[],
  '{"D/Tech":{"ca1":9,"ca2":10},"Chemistry":{"ca1":8,"ca2":9},"Physics":{"ca1":6,"ca2":8},"Biology":{"ca1":10,"ca2":10},"C.H.S":{"ca1":7,"ca2":7},"L.S.F":{"ca1":10,"ca2":10},"English Studies":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085442114-1","subject":"D/Tech","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085442114-2","subject":"Chemistry","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085442114-3","subject":"Physics","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085442114-4","subject":"Biology","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085442114-5","subject":"C.H.S","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085442114-6","subject":"L.S.F","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085442114-7","subject":"English Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085402264',
  'STX/2026/104',
  'Adeniyi Moses',
  'Male',
  15,
  'SSS 1 Science',
  'stanbax2025',
  ARRAY['Adeniyi Moses', 'moses adeniyi', 'adeniyi moses', 'Adeniyi Moses Ipepemi']::TEXT[],
  '{"Chemistry":{"ca1":9,"ca2":9},"D/Tech":{"ca1":9,"ca2":10},"Physics":{"ca1":8,"ca2":8},"Biology":{"ca1":9,"ca2":9},"C.H.S":{"ca1":10,"ca2":10},"L.S.F":{"ca1":10,"ca2":10},"English Studies":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085402264-1","subject":"Chemistry","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085402264-2","subject":"D/Tech","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085402264-3","subject":"Physics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085402264-4","subject":"Biology","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085402264-5","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085402264-6","subject":"L.S.F","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085402264-7","subject":"English Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085356611',
  'STX/2026/103',
  'Odubanjo Irewamiri',
  'Female',
  15,
  'SSS 1 Science',
  'stanbax2025',
  ARRAY['Odubanjo Irewamiri', 'irewamiri odubanjo', 'odubanjo irewamiri']::TEXT[],
  '{"Chemistry":{"ca1":6,"ca2":5},"D/Tech":{"ca1":7,"ca2":10},"Physics":{"ca1":8,"ca2":8},"Biology":{"ca1":7,"ca2":7},"C.H.S":{"ca1":6,"ca2":6},"L.S.F":{"ca1":10,"ca2":10},"English Studies":{"ca1":7,"ca2":7}}'::JSONB,
  '[{"id":"grd-std-1793085356611-1","subject":"Chemistry","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085356611-2","subject":"D/Tech","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085356611-3","subject":"Physics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085356611-4","subject":"Biology","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085356611-5","subject":"C.H.S","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085356611-6","subject":"L.S.F","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085356611-7","subject":"English Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-1',
  'SBS/2026/KG2/001',
  'David Abayomi',
  'Male',
  5,
  'KG 2',
  'stanbax2025',
  ARRAY['David Abayomi', 'abayomi david', 'david abayomi']::TEXT[],
  '{"English Language":{"ca1":10,"ca2":10},"Basic Science":{"ca1":8,"ca2":7},"Mathematics":{"ca1":10,"ca2":10},"Prevocational Studies":{"ca1":10,"ca2":10},"Yoruba Language":{"ca1":7,"ca2":8},"Social & Citizenship Studies":{"ca1":7,"ca2":8},"Cultural and Creative Arts":{"ca1":8,"ca2":8},"Cristian Religious studies":{"ca1":10,"ca2":10},"History":{"ca1":7,"ca2":8},"Rhyme":{"ca1":8,"ca2":9},"Music":{"ca1":10,"ca2":10},"Literature":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-1-1","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-2","subject":"Basic Science","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-3","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-4","subject":"Prevocational Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-5","subject":"Yoruba Language","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-6","subject":"Social & Citizenship Studies","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-7","subject":"Cultural and Creative Arts","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-8","subject":"Cristian Religious studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-9","subject":"History","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-10","subject":"Rhyme","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-11","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-1-12","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-2',
  'SBS/2026/KG2/002',
  'Oladayo Olaniyi',
  'Male',
  5,
  'KG 2',
  'stanbax2025',
  ARRAY['Oladayo Olaniyi', 'olaniyi oladayo', 'oladayo olaniyi']::TEXT[],
  '{"English Language":{"ca1":6,"ca2":9},"Basic Science":{"ca1":9,"ca2":9},"Mathematics":{"ca1":8,"ca2":7},"Prevocational Studies":{"ca1":6,"ca2":9},"Yoruba Language":{"ca1":9,"ca2":9},"Social & Citizenship Studies":{"ca1":9,"ca2":9},"Cultural and Creative Arts":{"ca1":8,"ca2":6},"Cristian Religious studies":{"ca1":7,"ca2":7},"History":{"ca1":7,"ca2":8},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Literature":{"ca1":9,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-2-1","subject":"English Language","ca1":6,"ca2":9,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-2","subject":"Basic Science","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-3","subject":"Mathematics","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-4","subject":"Prevocational Studies","ca1":6,"ca2":9,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-5","subject":"Yoruba Language","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-6","subject":"Social & Citizenship Studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-7","subject":"Cultural and Creative Arts","ca1":8,"ca2":6,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-8","subject":"Cristian Religious studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-9","subject":"History","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-10","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-11","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-2-12","subject":"Literature","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-3',
  'SBS/2026/KG2/003',
  'Bryan Babalola',
  'Male',
  5,
  'KG 2',
  'stanbax2025',
  ARRAY['Bryan Babalola', 'babalola bryan', 'bryan babalola']::TEXT[],
  '{"English Language":{"ca1":7,"ca2":8},"Basic Science":{"ca1":7,"ca2":7},"Mathematics":{"ca1":10,"ca2":10},"Prevocational Studies":{"ca1":8,"ca2":9},"Yoruba Language":{"ca1":5,"ca2":6},"Social & Citizenship Studies":{"ca1":7,"ca2":7},"Cultural and Creative Arts":{"ca1":5,"ca2":7},"Cristian Religious studies":{"ca1":6,"ca2":7},"History":{"ca1":8,"ca2":6},"Rhyme":{"ca1":10,"ca2":10},"Music":{"ca1":10,"ca2":10},"Literature":{"ca1":8,"ca2":7}}'::JSONB,
  '[{"id":"grd-stu-roster-3-1","subject":"English Language","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-2","subject":"Basic Science","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-3","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-4","subject":"Prevocational Studies","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-5","subject":"Yoruba Language","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-6","subject":"Social & Citizenship Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-7","subject":"Cultural and Creative Arts","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-8","subject":"Cristian Religious studies","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-9","subject":"History","ca1":8,"ca2":6,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-10","subject":"Rhyme","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-11","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-3-12","subject":"Literature","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-4',
  'SBS/2026/KG2/004',
  'Jemimal Alabiade',
  'Female',
  4,
  'KG 2',
  'stanbax2025',
  ARRAY['Jemimal Alabiade', 'alabiade jemimal', 'jemimal alabiade']::TEXT[],
  '{"English Language":{"ca1":7,"ca2":9},"Basic Science":{"ca1":7,"ca2":8},"Mathematics":{"ca1":6,"ca2":8},"Prevocational Studies":{"ca1":8,"ca2":7},"Yoruba Language":{"ca1":7,"ca2":8},"Social & Citizenship Studies":{"ca1":6,"ca2":6},"Cultural and Creative Arts":{"ca1":7,"ca2":8},"Cristian Religious studies":{"ca1":9,"ca2":8},"History":{"ca1":8,"ca2":7},"Rhyme":{"ca1":7,"ca2":7},"Music":{"ca1":10,"ca2":10},"Literature":{"ca1":8,"ca2":7}}'::JSONB,
  '[{"id":"grd-stu-roster-4-1","subject":"English Language","ca1":7,"ca2":9,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-2","subject":"Basic Science","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-3","subject":"Mathematics","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-4","subject":"Prevocational Studies","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-5","subject":"Yoruba Language","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-6","subject":"Social & Citizenship Studies","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-7","subject":"Cultural and Creative Arts","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-8","subject":"Cristian Religious studies","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-9","subject":"History","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-10","subject":"Rhyme","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-11","subject":"Music","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-4-12","subject":"Literature","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-5',
  'SBS/2026/KG2/005',
  'Azeez Aisha',
  'Female',
  5,
  'KG 2',
  'stanbax2025',
  ARRAY['Azeez Aisha', 'aisha azeez', 'azeez aisha']::TEXT[],
  '{"English Language":{"ca1":6,"ca2":6},"Basic Science":{"ca1":8,"ca2":7},"Mathematics":{"ca1":8,"ca2":8},"Prevocational Studies":{"ca1":9,"ca2":8},"Yoruba Language":{"ca1":2,"ca2":7},"Social & Citizenship Studies":{"ca1":7,"ca2":8},"Cultural and Creative Arts":{"ca1":8,"ca2":8},"Cristian Religious studies":{"ca1":7,"ca2":8},"History":{"ca1":8,"ca2":6},"Rhyme":{"ca1":9,"ca2":9},"Music":{"ca1":10,"ca2":9},"Literature":{"ca1":9,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-5-1","subject":"English Language","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-2","subject":"Basic Science","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-3","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-4","subject":"Prevocational Studies","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-5","subject":"Yoruba Language","ca1":2,"ca2":7,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-6","subject":"Social & Citizenship Studies","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-7","subject":"Cultural and Creative Arts","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-8","subject":"Cristian Religious studies","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-9","subject":"History","ca1":8,"ca2":6,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-10","subject":"Rhyme","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-11","subject":"Music","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-5-12","subject":"Literature","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-6',
  'SBS/2026/KG2/006',
  'Ajibowo Ire',
  'Female',
  4,
  'KG 2',
  'stanbax2025',
  ARRAY['Ajibowo Ire', 'ire ajibowo', 'ajibowo ire']::TEXT[],
  '{"English Language":{"ca1":5,"ca2":7},"Basic Science":{"ca1":6,"ca2":7},"Mathematics":{"ca1":5,"ca2":5},"Prevocational Studies":{"ca1":8,"ca2":9},"Yoruba Language":{"ca1":5,"ca2":8},"Social & Citizenship Studies":{"ca1":3,"ca2":8},"Cultural and Creative Arts":{"ca1":5,"ca2":6},"Cristian Religious studies":{"ca1":5,"ca2":5},"History":{"ca1":5,"ca2":5},"Rhyme":{"ca1":8,"ca2":7},"Music":{"ca1":8,"ca2":9},"Literature":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-6-1","subject":"English Language","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-2","subject":"Basic Science","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-3","subject":"Mathematics","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-4","subject":"Prevocational Studies","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-5","subject":"Yoruba Language","ca1":5,"ca2":8,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-6","subject":"Social & Citizenship Studies","ca1":3,"ca2":8,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-7","subject":"Cultural and Creative Arts","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-8","subject":"Cristian Religious studies","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-9","subject":"History","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-10","subject":"Rhyme","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-11","subject":"Music","ca1":8,"ca2":9,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-6-12","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-7',
  'SBS/2026/PRY1/001',
  'Adaramola Sindara',
  'Female',
  5,
  'Primary 1',
  'stanbax2025',
  ARRAY['Adaramola Sindara', 'sindara adaramola', 'adaramola sindara']::TEXT[],
  '{"Mathematics":{"ca1":7,"ca2":8},"English Language":{"ca1":5,"ca2":5},"Prevocational Studies":{"ca1":8,"ca2":7},"Basic Science":{"ca1":8,"ca2":7},"Yoruba Language":{"ca1":7,"ca2":8},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cultural and Creative Arts":{"ca1":7,"ca2":7},"Cristian Religious studies":{"ca1":8,"ca2":8},"History":{"ca1":5,"ca2":7},"Literature":{"ca1":8,"ca2":8},"French Language":{"ca1":0,"ca2":0},"Writing":{"ca1":7,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-7-1","subject":"Mathematics","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-2","subject":"English Language","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-3","subject":"Prevocational Studies","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-4","subject":"Basic Science","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-5","subject":"Yoruba Language","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-6","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-7","subject":"Cultural and Creative Arts","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-8","subject":"Cristian Religious studies","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-9","subject":"History","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-10","subject":"Literature","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-11","subject":"French Language","ca1":0,"ca2":0,"ca3":0,"exam":0,"total":0,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-7-12","subject":"Writing","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-8',
  'SBS/2026/PRY1/002',
  'Testimony Abenghe',
  'Male',
  6,
  'Primary 1',
  'stanbax2025',
  ARRAY['Testimony Abenghe', 'abenghe testimony', 'testimony abenghe']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English Language":{"ca1":5,"ca2":6},"Prevocational Studies":{"ca1":5,"ca2":7},"Basic Science":{"ca1":7,"ca2":8},"Yoruba Language":{"ca1":5,"ca2":7},"Social & Citizenship Studies":{"ca1":8,"ca2":7},"Cultural and Creative Arts":{"ca1":6,"ca2":7},"Cristian Religious studies":{"ca1":7,"ca2":8},"History":{"ca1":7,"ca2":6},"Literature":{"ca1":7,"ca2":8},"French Language":{"ca1":0,"ca2":0},"Writing":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-8-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-2","subject":"English Language","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-3","subject":"Prevocational Studies","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-4","subject":"Basic Science","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-5","subject":"Yoruba Language","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-6","subject":"Social & Citizenship Studies","ca1":8,"ca2":7,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-7","subject":"Cultural and Creative Arts","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-8","subject":"Cristian Religious studies","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-9","subject":"History","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-10","subject":"Literature","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-11","subject":"French Language","ca1":0,"ca2":0,"ca3":0,"exam":0,"total":0,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-8-12","subject":"Writing","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-9',
  'SBS/2026/PRY2/001',
  'Odubanjo Micheal',
  'Male',
  6,
  'Primary 2',
  'stanbax2025',
  ARRAY['Odubanjo Micheal', 'micheal odubanjo', 'odubanjo micheal', 'Odubanjo Michael']::TEXT[],
  '{"Mathematics":{"ca1":6,"ca2":6},"English":{"ca1":10,"ca2":10},"Basic Science":{"ca1":10,"ca2":5},"Pre-Vocational":{"ca1":10,"ca2":5},"Social Citizenship":{"ca1":6,"ca2":8},"BSE":{"ca1":7,"ca2":8},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":5,"ca2":8},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":5,"ca2":5},"Computer":{"ca1":10,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-9-1","subject":"Mathematics","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-2","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-3","subject":"Basic Science","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-4","subject":"Pre-Vocational","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-5","subject":"Social Citizenship","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-6","subject":"BSE","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-8","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-9","subject":"Literature","ca1":5,"ca2":8,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-11","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-13","subject":"Writing","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-9-14","subject":"Computer","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-10',
  'SBS/2026/PRY2/002',
  'Tamara Abayomi',
  'Female',
  6,
  'Primary 2',
  'stanbax2025',
  ARRAY['Tamara Abayomi', 'abayomi tamara', 'tamara abayomi', 'Abayomi Tamara']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":10},"Basic Science":{"ca1":10,"ca2":10},"Pre-Vocational":{"ca1":10,"ca2":8},"Social Citizenship":{"ca1":7,"ca2":7},"BSE":{"ca1":6,"ca2":6},"PVS":{"ca1":9,"ca2":10},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":15,"ca2":10},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":8,"ca2":8},"Computer":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-10-1","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-2","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-3","subject":"Basic Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-4","subject":"Pre-Vocational","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-5","subject":"Social Citizenship","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-6","subject":"BSE","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-7","subject":"PVS","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-8","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-11","subject":"PHE","ca1":15,"ca2":10,"ca3":0,"exam":0,"total":25,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-13","subject":"Writing","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-10-14","subject":"Computer","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-11',
  'SBS/2026/PRY2/003',
  'Daralis Daramola',
  'Female',
  6,
  'Primary 2',
  'stanbax2025',
  ARRAY['Daralis Daramola', 'daramola daralis', 'daralis daramola']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-12',
  'SBS/2026/PRY2/004',
  'John Mercy',
  'Female',
  7,
  'Primary 2',
  'stanbax2025',
  ARRAY['John Mercy', 'mercy john', 'john mercy']::TEXT[],
  '{"Mathematics":{"ca1":5,"ca2":7},"English":{"ca1":7,"ca2":5},"Basic Science":{"ca1":10,"ca2":5},"Pre-Vocational":{"ca1":10,"ca2":5},"Social Citizenship":{"ca1":7,"ca2":8},"BSE":{"ca1":8,"ca2":6},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":2,"ca2":10},"Literature":{"ca1":10,"ca2":7},"CRS":{"ca1":8,"ca2":8},"PHE":{"ca1":10,"ca2":8},"History":{"ca1":12,"ca2":10},"Writing":{"ca1":5,"ca2":5},"Computer":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-12-1","subject":"Mathematics","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-2","subject":"English","ca1":7,"ca2":5,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-3","subject":"Basic Science","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-4","subject":"Pre-Vocational","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-5","subject":"Social Citizenship","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-6","subject":"BSE","ca1":8,"ca2":6,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-8","subject":"CCA","ca1":2,"ca2":10,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-9","subject":"Literature","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-10","subject":"CRS","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-11","subject":"PHE","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-12","subject":"History","ca1":12,"ca2":10,"ca3":0,"exam":0,"total":22,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-13","subject":"Writing","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-12-14","subject":"Computer","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-13',
  'SBS/2026/PRY2/005',
  'Ajayi Ayomikun',
  'Male',
  7,
  'Primary 2',
  'stanbax2025',
  ARRAY['Ajayi Ayomikun', 'ayomikun ajayi', 'ajayi ayomikun']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":5},"English":{"ca1":10,"ca2":10},"Basic Science":{"ca1":10,"ca2":10},"Pre-Vocational":{"ca1":10,"ca2":7},"Social Citizenship":{"ca1":8,"ca2":5},"BSE":{"ca1":7,"ca2":8},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":10,"ca2":10},"Computer":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-13-1","subject":"Mathematics","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-2","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-3","subject":"Basic Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-4","subject":"Pre-Vocational","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-5","subject":"Social Citizenship","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-6","subject":"BSE","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-8","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-11","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-13","subject":"Writing","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-13-14","subject":"Computer","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-14',
  'SBS/2026/PRY2/006',
  'Obi Ebuka',
  'Male',
  7,
  'Primary 2',
  'stanbax2025',
  ARRAY['Obi Ebuka', 'ebuka obi', 'obi ebuka', 'Obi Ebuka Samuel']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":5},"English":{"ca1":10,"ca2":10},"Basic Science":{"ca1":10,"ca2":5},"Pre-Vocational":{"ca1":4,"ca2":3},"Social Citizenship":{"ca1":4,"ca2":3},"BSE":{"ca1":6,"ca2":6},"PVS":{"ca1":9,"ca2":10},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":4,"ca2":5},"Computer":{"ca1":10,"ca2":5}}'::JSONB,
  '[{"id":"grd-stu-roster-14-1","subject":"Mathematics","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-2","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-3","subject":"Basic Science","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-4","subject":"Pre-Vocational","ca1":4,"ca2":3,"ca3":0,"exam":0,"total":7,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-5","subject":"Social Citizenship","ca1":4,"ca2":3,"ca3":0,"exam":0,"total":7,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-6","subject":"BSE","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-7","subject":"PVS","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-8","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-11","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-13","subject":"Writing","ca1":4,"ca2":5,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-14-14","subject":"Computer","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-15',
  'SBS/2026/PRY2/007',
  'Adeniyi David',
  'Male',
  6,
  'Primary 2',
  'stanbax2025',
  ARRAY['Adeniyi David', 'david adeniyi', 'adeniyi david']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English":{"ca1":10,"ca2":10},"Basic Science":{"ca1":10,"ca2":8},"Pre-Vocational":{"ca1":8,"ca2":8},"Social Citizenship":{"ca1":8,"ca2":8},"BSE":{"ca1":7,"ca2":7},"PVS":{"ca1":7,"ca2":10},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":10,"ca2":8},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":7,"ca2":6},"Computer":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-15-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-2","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-3","subject":"Basic Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-4","subject":"Pre-Vocational","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-5","subject":"Social Citizenship","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-6","subject":"BSE","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-7","subject":"PVS","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-8","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-9","subject":"Literature","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-11","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-13","subject":"Writing","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-15-14","subject":"Computer","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-16',
  'SBS/2026/PRY2/008',
  'Ondigho Divine',
  'Male',
  7,
  'Primary 2',
  'stanbax2025',
  ARRAY['Ondigho Divine', 'divine ondigho', 'ondigho divine', 'Onygho Divine']::TEXT[],
  '{"Mathematics":{"ca1":6,"ca2":8},"English":{"ca1":10,"ca2":8},"Basic Science":{"ca1":10,"ca2":7},"Pre-Vocational":{"ca1":10,"ca2":7},"Social Citizenship":{"ca1":6,"ca2":8},"BSE":{"ca1":7,"ca2":8},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":10},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":7,"ca2":6},"Computer":{"ca1":6,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-16-1","subject":"Mathematics","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-2","subject":"English","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-3","subject":"Basic Science","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-4","subject":"Pre-Vocational","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-5","subject":"Social Citizenship","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-6","subject":"BSE","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-8","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-11","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-13","subject":"Writing","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-16-14","subject":"Computer","ca1":6,"ca2":8,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-17',
  'SBS/2026/PRY3/001',
  'Alabi Darasimi',
  'Female',
  7,
  'Primary 3',
  'stanbax2025',
  ARRAY['Alabi Darasimi', 'darasimi alabi', 'alabi darasimi']::TEXT[],
  '{"Mathematics":{"ca1":4,"ca2":5},"English":{"ca1":6,"ca2":7},"Basic Science":{"ca1":6,"ca2":7},"Pre-Vocational":{"ca1":4,"ca2":3},"Social Citizenship":{"ca1":4,"ca2":3},"BSE":{"ca1":4,"ca2":5},"PVS":{"ca1":10,"ca2":5},"CCA":{"ca1":2,"ca2":7},"Literature":{"ca1":5,"ca2":5},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":1,"ca2":4},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":4,"ca2":5},"Computer":{"ca1":6,"ca2":7}}'::JSONB,
  '[{"id":"grd-stu-roster-17-1","subject":"Mathematics","ca1":4,"ca2":5,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-2","subject":"English","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-3","subject":"Basic Science","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-4","subject":"Pre-Vocational","ca1":4,"ca2":3,"ca3":0,"exam":0,"total":7,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-5","subject":"Social Citizenship","ca1":4,"ca2":3,"ca3":0,"exam":0,"total":7,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-6","subject":"BSE","ca1":4,"ca2":5,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-7","subject":"PVS","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-8","subject":"CCA","ca1":2,"ca2":7,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-9","subject":"Literature","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-11","subject":"PHE","ca1":1,"ca2":4,"ca3":0,"exam":0,"total":5,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-13","subject":"Writing","ca1":4,"ca2":5,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-17-14","subject":"Computer","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-18',
  'SBS/2026/PRY3/002',
  'Mustapha Nathaniel',
  'Male',
  8,
  'Primary 3',
  'stanbax2025',
  ARRAY['Mustapha Nathaniel', 'nathaniel mustapha', 'mustapha nathaniel']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":7},"English":{"ca1":10,"ca2":8},"Basic Science":{"ca1":10,"ca2":8},"Pre-Vocational":{"ca1":8,"ca2":5},"Social Citizenship":{"ca1":7,"ca2":6},"BSE":{"ca1":6,"ca2":7},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":10,"ca2":6},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":7},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":7,"ca2":8},"Computer":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-18-1","subject":"Mathematics","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-2","subject":"English","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-3","subject":"Basic Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-4","subject":"Pre-Vocational","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-5","subject":"Social Citizenship","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-6","subject":"BSE","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-8","subject":"CCA","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-11","subject":"PHE","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-13","subject":"Writing","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-18-14","subject":"Computer","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-19',
  'SBS/2026/PRY3/003',
  'Oliver Zion',
  'Male',
  8,
  'Primary 3',
  'stanbax2025',
  ARRAY['Oliver Zion', 'zion oliver', 'oliver zion']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English":{"ca1":10,"ca2":7},"Basic Science":{"ca1":10,"ca2":7},"Pre-Vocational":{"ca1":6,"ca2":5},"Social Citizenship":{"ca1":7,"ca2":6},"BSE":{"ca1":5,"ca2":6},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":6,"ca2":4},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":6,"ca2":4},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":5,"ca2":6},"Computer":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-19-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-2","subject":"English","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-3","subject":"Basic Science","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-4","subject":"Pre-Vocational","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-5","subject":"Social Citizenship","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-6","subject":"BSE","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-8","subject":"CCA","ca1":6,"ca2":4,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-11","subject":"PHE","ca1":6,"ca2":4,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-13","subject":"Writing","ca1":5,"ca2":6,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-19-14","subject":"Computer","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-20',
  'SBS/2026/PRY3/004',
  'Azeez Ryan',
  'Male',
  7,
  'Primary 3',
  'stanbax2025',
  ARRAY['Azeez Ryan', 'ryan azeez', 'azeez ryan']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English":{"ca1":10,"ca2":8},"Basic Science":{"ca1":7,"ca2":6},"Pre-Vocational":{"ca1":8,"ca2":5},"Social Citizenship":{"ca1":7,"ca2":6},"BSE":{"ca1":7,"ca2":6},"PVS":{"ca1":10,"ca2":10},"CCA":{"ca1":2,"ca2":10},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":8},"History":{"ca1":10,"ca2":10},"Writing":{"ca1":7,"ca2":8},"Computer":{"ca1":10,"ca2":6}}'::JSONB,
  '[{"id":"grd-stu-roster-20-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-2","subject":"English","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-3","subject":"Basic Science","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-4","subject":"Pre-Vocational","ca1":8,"ca2":5,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-5","subject":"Social Citizenship","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-6","subject":"BSE","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-7","subject":"PVS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-8","subject":"CCA","ca1":2,"ca2":10,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-9","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-10","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-11","subject":"PHE","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-12","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-13","subject":"Writing","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-20-14","subject":"Computer","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-21',
  'SBS/2026/PRY4/001',
  'Anakwe Ebube',
  'Female',
  9,
  'Primary 4',
  'stanbax2025',
  ARRAY['Anakwe Ebube', 'ebube anakwe', 'anakwe ebube']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-21-mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Mathematics","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-21-english-language","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"English Language","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-21-citizenship-and-heritage-studies-","ca1":0,"ca2":0,"ca3":0,"exam":0,"grade":"F9","total":0,"remark":"Fail","subject":"Citizenship and Heritage Studies ","term1Total":0,"annualAverage":0},{"id":"grd-stu-roster-21-basic-science-technology-","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-21-prevocational-studies-","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Prevocational Studies ","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-21-cultural-and-creative-arts-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-21-physical-health-education-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Physical & Health Education ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-21-cristian-religious-studies","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cristian Religious studies","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-21-computer","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Computer","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-21-social-citizenship-studies","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-21-writing","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Writing","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-21-literature","ca1":4,"ca2":4,"ca3":0,"exam":0,"grade":"F9","total":8,"remark":"Fail","subject":"Literature","term1Total":8,"annualAverage":8},{"id":"grd-stu-roster-21-history","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"History","term1Total":16,"annualAverage":16}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-22',
  'SBS/2026/PRY4/002',
  'Feyikemi Raheem',
  'Female',
  9,
  'Primary 4',
  'stanbax2025',
  ARRAY['Feyikemi Raheem', 'raheem feyikemi', 'feyikemi raheem']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-22-mathematics","ca1":5,"ca2":5,"ca3":0,"exam":0,"grade":"F9","total":10,"remark":"Fail","subject":"Mathematics","term1Total":10,"annualAverage":10},{"id":"grd-stu-roster-22-english-language","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"English Language","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-22-citizenship-and-heritage-studies-","ca1":0,"ca2":0,"ca3":0,"exam":0,"grade":"F9","total":0,"remark":"Fail","subject":"Citizenship and Heritage Studies ","term1Total":0,"annualAverage":0},{"id":"grd-stu-roster-22-basic-science-technology-","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-22-prevocational-studies-","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Prevocational Studies ","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-22-cultural-and-creative-arts-","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-22-physical-health-education-","ca1":6,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Physical & Health Education ","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-22-cristian-religious-studies","ca1":5,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":11,"remark":"Fail","subject":"Cristian Religious studies","term1Total":11,"annualAverage":11},{"id":"grd-stu-roster-22-computer","ca1":5,"ca2":5,"ca3":0,"exam":0,"grade":"F9","total":10,"remark":"Fail","subject":"Computer","term1Total":10,"annualAverage":10},{"id":"grd-stu-roster-22-social-citizenship-studies","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-22-writing","ca1":9,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Writing","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-22-literature","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Literature","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-22-history","ca1":6,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":13,"remark":"Fail","subject":"History","term1Total":13,"annualAverage":13}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-23',
  'SBS/2026/PRY4/003',
  'Ajibowo Mosinmiloluwa',
  'Female',
  8,
  'Primary 4',
  'stanbax2025',
  ARRAY['Ajibowo Mosinmiloluwa', 'mosinmiloluwa ajibowo', 'ajibowo mosinmiloluwa']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-23-mathematics","ca1":9,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Mathematics","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-23-english-language","ca1":8,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"English Language","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-23-citizenship-and-heritage-studies-","ca1":0,"ca2":0,"ca3":0,"exam":0,"grade":"F9","total":0,"remark":"Fail","subject":"Citizenship and Heritage Studies ","term1Total":0,"annualAverage":0},{"id":"grd-stu-roster-23-basic-science-technology-","ca1":9,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-23-prevocational-studies-","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Prevocational Studies ","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-23-cultural-and-creative-arts-","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-23-physical-health-education-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Physical & Health Education ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-23-cristian-religious-studies","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cristian Religious studies","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-23-computer","ca1":6,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":13,"remark":"Fail","subject":"Computer","term1Total":13,"annualAverage":13},{"id":"grd-stu-roster-23-social-citizenship-studies","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-23-writing","ca1":9,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Writing","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-23-literature","ca1":4,"ca2":4,"ca3":0,"exam":0,"grade":"F9","total":8,"remark":"Fail","subject":"Literature","term1Total":8,"annualAverage":8},{"id":"grd-stu-roster-23-history","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"History","term1Total":14,"annualAverage":14}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-24',
  'SBS/2026/PRY4/004',
  'Olaniyi Joel',
  'Male',
  9,
  'Primary 4',
  'stanbax2025',
  ARRAY['Olaniyi Joel', 'joel olaniyi', 'olaniyi joel']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-24-mathematics","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Mathematics","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-24-english-language","ca1":6,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":13,"remark":"Fail","subject":"English Language","term1Total":13,"annualAverage":13},{"id":"grd-stu-roster-24-citizenship-and-heritage-studies-","ca1":0,"ca2":0,"ca3":0,"exam":0,"grade":"F9","total":0,"remark":"Fail","subject":"Citizenship and Heritage Studies ","term1Total":0,"annualAverage":0},{"id":"grd-stu-roster-24-basic-science-technology-","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-24-prevocational-studies-","ca1":8,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Prevocational Studies ","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-24-cultural-and-creative-arts-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-24-physical-health-education-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Physical & Health Education ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-24-cristian-religious-studies","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cristian Religious studies","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-24-computer","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Computer","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-24-social-citizenship-studies","ca1":6,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-24-writing","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Writing","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-24-literature","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Literature","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-24-history","ca1":8,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"History","term1Total":17,"annualAverage":17}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-25',
  'SBS/2026/PRY4/005',
  'Gbengbe Christiana',
  'Male',
  9,
  'Primary 5',
  'stanbax2025',
  ARRAY['Gbengbe Christiana', 'christiana gbengbe', 'gbengbe christiana']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-25-mathematics","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Mathematics","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-25-english-language","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"English Language","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-25-citizenship-and-heritage-studies-","ca1":0,"ca2":0,"ca3":0,"exam":0,"grade":"F9","total":0,"remark":"Fail","subject":"Citizenship and Heritage Studies ","term1Total":0,"annualAverage":0},{"id":"grd-stu-roster-25-basic-science-technology-","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-25-prevocational-studies-","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Prevocational Studies ","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-25-cultural-and-creative-arts-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-25-physical-health-education-","ca1":6,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Physical & Health Education ","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-25-cristian-religious-studies","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Cristian Religious studies","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-25-computer","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Computer","term1Total":12,"annualAverage":12},{"id":"grd-stu-roster-25-social-citizenship-studies","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-25-writing","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Writing","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-25-literature","ca1":5,"ca2":5,"ca3":0,"exam":0,"grade":"F9","total":10,"remark":"Fail","subject":"Literature","term1Total":10,"annualAverage":10},{"id":"grd-stu-roster-25-history","ca1":5,"ca2":5,"ca3":0,"exam":0,"grade":"F9","total":10,"remark":"Fail","subject":"History","term1Total":10,"annualAverage":10}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-27',
  'SBS/2026/PRY5/002',
  'Testimony Ohidi',
  'Male',
  9,
  'Primary 4',
  'stanbax2025',
  ARRAY['Testimony Ohidi', 'ohidi testimony', 'testimony ohidi']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-27-mathematics","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Mathematics","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-27-english-language","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"English Language","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-27-basic-science-technology-","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-27-prevocational-studies-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Prevocational Studies ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-27-cultural-and-creative-arts-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-27-physical-health-education-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Physical & Health Education ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-27-history","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"History","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-27-cristian-religious-studies","ca1":6,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":13,"remark":"Fail","subject":"Cristian Religious studies","term1Total":13,"annualAverage":13},{"id":"grd-stu-roster-27-computer","ca1":8,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Computer","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-27-social-citizenship-studies","ca1":8,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-27-writing","ca1":9,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":19,"remark":"Fail","subject":"Writing","term1Total":19,"annualAverage":19},{"id":"grd-stu-roster-27-literature","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Literature","term1Total":16,"annualAverage":16}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-28',
  'SBS/2026/PRY5/003',
  'Osimachi Ofamalru',
  'Female',
  9,
  'Primary 4',
  'stanbax2025',
  ARRAY['Osimachi Ofamalru', 'ofamalru osimachi', 'osimachi ofamalru']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-28-mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Mathematics","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-28-english-language","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"English Language","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-28-basic-science-technology-","ca1":8,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-28-prevocational-studies-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Prevocational Studies ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-28-cultural-and-creative-arts-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-28-physical-health-education-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Physical & Health Education ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-28-history","ca1":5,"ca2":5,"ca3":0,"exam":0,"grade":"F9","total":10,"remark":"Fail","subject":"History","term1Total":10,"annualAverage":10},{"id":"grd-stu-roster-28-cristian-religious-studies","ca1":8,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Cristian Religious studies","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-28-computer","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Computer","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-28-social-citizenship-studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":18,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":18,"annualAverage":18},{"id":"grd-stu-roster-28-writing","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Writing","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-28-literature","ca1":6,"ca2":6,"ca3":0,"exam":0,"grade":"F9","total":12,"remark":"Fail","subject":"Literature","term1Total":12,"annualAverage":12}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-29',
  'SBS/2026/JSS1/001',
  'Idiaghe Iyobosa',
  'Female',
  11,
  'JSS 1',
  'stanbax2025',
  ARRAY['Idiaghe Iyobosa', 'iyobosa idiaghe', 'idiaghe iyobosa']::TEXT[],
  '{"Mathematics":{"ca1":7,"ca2":7},"English Language":{"ca1":9,"ca2":9},"Intermediate Science":{"ca1":10,"ca2":8},"Digital Technology":{"ca1":8,"ca2":8},"Livestock Farming":{"ca1":9,"ca2":9},"History":{"ca1":5,"ca2":5},"Yoruba":{"ca1":10,"ca2":5},"Business Studies":{"ca1":6,"ca2":6},"Physical & Health Education":{"ca1":9,"ca2":9},"Cultural and Creative Arts":{"ca1":2,"ca2":2},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cristian Religious studies":{"ca1":9,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-29-1","subject":"Mathematics","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-2","subject":"English Language","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-3","subject":"Intermediate Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-4","subject":"Digital Technology","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-5","subject":"Livestock Farming","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-6","subject":"History","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-7","subject":"Yoruba","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-8","subject":"Business Studies","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-9","subject":"Physical & Health Education","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-10","subject":"Cultural and Creative Arts","ca1":2,"ca2":2,"ca3":0,"exam":0,"total":4,"grade":"F9","remark":"Needs Improvement","color":"#dc2626","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-11","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-29-12","subject":"Cristian Religious studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-30',
  'SBS/2026/JSS1/002',
  'Adeniyi Paul',
  'Male',
  9,
  'JSS 1',
  'stanbax2025',
  ARRAY['Adeniyi Paul', 'paul adeniyi', 'adeniyi paul']::TEXT[],
  '{"Mathematics":{"ca1":6,"ca2":6},"English Language":{"ca1":10,"ca2":10},"Intermediate Science":{"ca1":10,"ca2":10},"Digital Technology":{"ca1":10,"ca2":10},"Livestock Farming":{"ca1":10,"ca2":10},"Yoruba":{"ca1":6,"ca2":7},"Business Studies":{"ca1":7,"ca2":7},"Physical & Health Education":{"ca1":10,"ca2":10},"Social & Citizenship Studies":{"ca1":7,"ca2":7},"Cristian Religious studies":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-30-1","subject":"Mathematics","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-3","subject":"Intermediate Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-4","subject":"Digital Technology","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-5","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-6","subject":"Yoruba","ca1":6,"ca2":7,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-7","subject":"Business Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-8","subject":"Physical & Health Education","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-9","subject":"Social & Citizenship Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-30-10","subject":"Cristian Religious studies","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-31',
  'SBS/2026/JSS1/003',
  'Titcombe Ayodeji',
  'Male',
  13,
  'JSS 1',
  'stanbax2025',
  ARRAY['Titcombe Ayodeji', 'ayodeji titcombe', 'titcombe ayodeji']::TEXT[],
  '{"Mathematics":{"ca1":5,"ca2":5},"English Language":{"ca1":8,"ca2":8},"Intermediate Science":{"ca1":5,"ca2":5},"Digital Technology":{"ca1":6,"ca2":6},"Livestock Farming":{"ca1":6,"ca2":6},"History":{"ca1":6,"ca2":6},"Yoruba":{"ca1":5,"ca2":5},"Business Studies":{"ca1":6,"ca2":5},"Physical & Health Education":{"ca1":5,"ca2":7},"Cultural and Creative Arts":{"ca1":7,"ca2":7},"Social & Citizenship Studies":{"ca1":6,"ca2":5},"Cristian Religious studies":{"ca1":7,"ca2":7}}'::JSONB,
  '[{"id":"grd-stu-roster-31-1","subject":"Mathematics","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-2","subject":"English Language","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-3","subject":"Intermediate Science","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-4","subject":"Digital Technology","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-5","subject":"Livestock Farming","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-6","subject":"History","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-7","subject":"Yoruba","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-8","subject":"Business Studies","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-9","subject":"Physical & Health Education","ca1":5,"ca2":7,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-10","subject":"Cultural and Creative Arts","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-11","subject":"Social & Citizenship Studies","ca1":6,"ca2":5,"ca3":0,"exam":0,"total":11,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-31-12","subject":"Cristian Religious studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-32',
  'SBS/2026/JSS1/004',
  'Ada Anakwae',
  'Female',
  11,
  'JSS 1',
  'stanbax2025',
  ARRAY['Ada Anakwae', 'anakwae ada', 'ada anakwae']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":10},"English Language":{"ca1":10,"ca2":10},"Intermediate Science":{"ca1":10,"ca2":8},"Digital Technology":{"ca1":10,"ca2":10},"Livestock Farming":{"ca1":10,"ca2":10},"History":{"ca1":8,"ca2":8},"Yoruba":{"ca1":10,"ca2":10},"Business Studies":{"ca1":10,"ca2":10},"Physical & Health Education":{"ca1":10,"ca2":10},"Cultural and Creative Arts":{"ca1":7,"ca2":7},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cristian Religious studies":{"ca1":9,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-32-1","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-3","subject":"Intermediate Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-4","subject":"Digital Technology","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-5","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-6","subject":"History","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-7","subject":"Yoruba","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-8","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-9","subject":"Physical & Health Education","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-10","subject":"Cultural and Creative Arts","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-11","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-32-12","subject":"Cristian Religious studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-33',
  'SBS/2026/JSS1/005',
  'Ademumi Demilade',
  'Male',
  10,
  'JSS 1',
  'stanbax2025',
  ARRAY['Ademumi Demilade', 'demilade ademumi', 'ademumi demilade']::TEXT[],
  '{"Mathematics":{"ca1":7,"ca2":7},"English Language":{"ca1":10,"ca2":10},"Intermediate Science":{"ca1":10,"ca2":8},"Digital Technology":{"ca1":10,"ca2":10},"Livestock Farming":{"ca1":10,"ca2":10},"History":{"ca1":8,"ca2":8},"Yoruba":{"ca1":10,"ca2":7},"Business Studies":{"ca1":6,"ca2":6},"Physical & Health Education":{"ca1":9,"ca2":9},"Cultural and Creative Arts":{"ca1":10,"ca2":10},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cristian Religious studies":{"ca1":9,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-33-1","subject":"Mathematics","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-3","subject":"Intermediate Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-4","subject":"Digital Technology","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-5","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-6","subject":"History","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-7","subject":"Yoruba","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-8","subject":"Business Studies","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-9","subject":"Physical & Health Education","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-10","subject":"Cultural and Creative Arts","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-11","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-33-12","subject":"Cristian Religious studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-34',
  'SBS/2026/JSS1/006',
  'Mustapha Irewamiri',
  'Male',
  11,
  'JSS 1',
  'stanbax2025',
  ARRAY['Mustapha Irewamiri', 'irewamiri mustapha', 'mustapha irewamiri']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English Language":{"ca1":9,"ca2":9},"Intermediate Science":{"ca1":10,"ca2":8},"Digital Technology":{"ca1":9,"ca2":9},"Livestock Farming":{"ca1":9,"ca2":9},"History":{"ca1":8,"ca2":8},"Yoruba":{"ca1":7,"ca2":10},"Business Studies":{"ca1":7,"ca2":7},"Physical & Health Education":{"ca1":10,"ca2":10},"Cultural and Creative Arts":{"ca1":5,"ca2":5},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cristian Religious studies":{"ca1":9,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-34-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-2","subject":"English Language","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-3","subject":"Intermediate Science","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-4","subject":"Digital Technology","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-5","subject":"Livestock Farming","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-6","subject":"History","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-7","subject":"Yoruba","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-8","subject":"Business Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-9","subject":"Physical & Health Education","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-10","subject":"Cultural and Creative Arts","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-11","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-34-12","subject":"Cristian Religious studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-35',
  'SBS/2026/JSS1/007',
  'Unaji Vincent',
  'Male',
  10,
  'JSS 1',
  'stanbax2025',
  ARRAY['Unaji Vincent', 'vincent unaji', 'unaji vincent']::TEXT[],
  '{"Mathematics":{"ca1":7,"ca2":7},"English Language":{"ca1":9,"ca2":9},"Intermediate Science":{"ca1":10,"ca2":10},"Digital Technology":{"ca1":10,"ca2":10},"Livestock Farming":{"ca1":9,"ca2":9},"History":{"ca1":6,"ca2":6},"Yoruba":{"ca1":10,"ca2":9},"Business Studies":{"ca1":10,"ca2":10},"Physical & Health Education":{"ca1":10,"ca2":7},"Cultural and Creative Arts":{"ca1":9,"ca2":9},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cristian Religious studies":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-roster-35-1","subject":"Mathematics","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-2","subject":"English Language","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-3","subject":"Intermediate Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-4","subject":"Digital Technology","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-5","subject":"Livestock Farming","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-6","subject":"History","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-7","subject":"Yoruba","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-8","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-9","subject":"Physical & Health Education","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-10","subject":"Cultural and Creative Arts","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-11","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-35-12","subject":"Cristian Religious studies","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-36',
  'SBS/2026/JSS1/008',
  'Oladipo Samuel',
  'Male',
  11,
  'JSS 1',
  'stanbax2025',
  ARRAY['Oladipo Samuel', 'samuel oladipo', 'oladipo samuel', 'Oladipo Samuel Gbolahan']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":10},"English Language":{"ca1":9,"ca2":9},"Intermediate Science":{"ca1":10,"ca2":6},"Digital Technology":{"ca1":10,"ca2":10},"Livestock Farming":{"ca1":9,"ca2":9},"History":{"ca1":6,"ca2":6},"Yoruba":{"ca1":10,"ca2":7},"Business Studies":{"ca1":9,"ca2":9},"Physical & Health Education":{"ca1":7,"ca2":6},"Cultural and Creative Arts":{"ca1":5,"ca2":5},"Social & Citizenship Studies":{"ca1":10,"ca2":10},"Cristian Religious studies":{"ca1":9,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-36-1","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-2","subject":"English Language","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-3","subject":"Intermediate Science","ca1":10,"ca2":6,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-4","subject":"Digital Technology","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-5","subject":"Livestock Farming","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-6","subject":"History","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-7","subject":"Yoruba","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-8","subject":"Business Studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-9","subject":"Physical & Health Education","ca1":7,"ca2":6,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-10","subject":"Cultural and Creative Arts","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-11","subject":"Social & Citizenship Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-36-12","subject":"Cristian Religious studies","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-46',
  'SBS/2026/JSS3/001',
  'Ndubisi Victor',
  'Male',
  13,
  'JSS 3',
  'stanbax2025',
  ARRAY['Ndubisi Victor', 'victor ndubisi', 'ndubisi victor']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-47',
  'SBS/2026/JSS3/002',
  'Titcombe Ayomide',
  'Male',
  12,
  'JSS 3',
  'stanbax2025',
  ARRAY['Titcombe Ayomide', 'ayomide titcombe', 'titcombe ayomide']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-48',
  'SBS/2026/JSS3/003',
  'Amulo Samuel',
  'Male',
  12,
  'JSS 3',
  'stanbax2025',
  ARRAY['Amulo Samuel', 'samuel amulo', 'amulo samuel']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-49',
  'SBS/2026/JSS3/004',
  'Izuagbe Mercy',
  'Female',
  13,
  'JSS 3',
  'stanbax2025',
  ARRAY['Izuagbe Mercy', 'mercy izuagbe', 'izuagbe mercy']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-50',
  'SBS/2026/JSS3/005',
  'Unaji Immaculate',
  'Female',
  13,
  'JSS 3',
  'stanbax2025',
  ARRAY['Unaji Immaculate', 'immaculate unaji', 'unaji immaculate']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-51',
  'SBS/2026/JSS3/006',
  'Okwuchukwu Oluchi',
  'Male',
  13,
  'JSS 3',
  'stanbax2025',
  ARRAY['Okwuchukwu Oluchi', 'oluchi okwuchukwu', 'okwuchukwu oluchi']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-52',
  'SBS/2026/JSS3/007',
  'Adaramola Ayooluwa',
  'Female',
  12,
  'JSS 3',
  'stanbax2025',
  ARRAY['Adaramola Ayooluwa', 'ayooluwa adaramola', 'adaramola ayooluwa']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-53',
  'SBS/2026/JSS3/008',
  'Adeshina Solomon',
  'Male',
  13,
  'JSS 3',
  'stanbax2025',
  ARRAY['Adeshina Solomon', 'solomon adeshina', 'adeshina solomon']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-54',
  'SBS/2026/JSS3/009',
  'Anakwae Ifechukwu Henry',
  'Male',
  13,
  'JSS 3',
  'stanbax2025',
  ARRAY['Anakwae Ifechukwu Henry', 'henry anakwae', 'anakwae henry']::TEXT[],
  '{}'::JSONB,
  '[]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-55',
  'SBS/2026/SS2/001',
  'Bello Mordiyah',
  'Female',
  16,
  'SSS 2 Science',
  'stanbax2025',
  ARRAY['Bello Mordiyah', 'mordiyah bello', 'bello mordiyah']::TEXT[],
  '{"Mathematics":{"ca1":8,"ca2":8},"English Language":{"ca1":10,"ca2":5},"Physics":{"ca1":5,"ca2":5},"Chemistry":{"ca1":5,"ca2":5},"Digital Technology":{"ca1":7,"ca2":10},"Livestock Farming":{"ca1":10,"ca2":10},"Further Mathematics":{"ca1":10,"ca2":10},"Citizenship and Heritage Studies":{"ca1":7,"ca2":2}}'::JSONB,
  '[{"id":"grd-stu-roster-55-1","subject":"Mathematics","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-2","subject":"English Language","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-3","subject":"Physics","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-4","subject":"Chemistry","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-5","subject":"Digital Technology","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-6","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-7","subject":"Further Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-55-8","subject":"Citizenship and Heritage Studies","ca1":7,"ca2":2,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-57',
  'SBS/2026/SS2/003',
  'Kafilat Balogun',
  'Female',
  16,
  'SSS 2 Arts & Commercial',
  'stanbax2025',
  ARRAY['Kafilat Balogun', 'balogun kafilat', 'kafilat balogun']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":5},"English Language":{"ca1":10,"ca2":8},"Digital Technology":{"ca1":8,"ca2":10},"Livestock Farming":{"ca1":10,"ca2":10},"Further Mathematics":{"ca1":10,"ca2":10},"Citizenship and Heritage Studies":{"ca1":8,"ca2":4},"Literature in English":{"ca1":8,"ca2":8},"Government":{"ca1":7,"ca2":7},"Yoruba":{"ca1":10,"ca2":9}}'::JSONB,
  '[{"id":"grd-stu-roster-57-1","subject":"Mathematics","ca1":10,"ca2":5,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-2","subject":"English Language","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-3","subject":"Digital Technology","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-4","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-5","subject":"Further Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-6","subject":"Citizenship and Heritage Studies","ca1":8,"ca2":4,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-7","subject":"Literature in English","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-8","subject":"Government","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-57-9","subject":"Yoruba","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-7',
  'STX/2024/101',
  'Amina Bello',
  'Female',
  14,
  'JSS 1',
  'stanbax2025',
  ARRAY['Amina Bello', 'bello amina', 'amina bello', 'Osuntoyinbo Obabi']::TEXT[],
  '{"Mathematics":{"ca1":7,"ca2":7},"English Language":{"ca1":9,"ca2":9},"Intermediate Science":{"ca1":10,"ca2":7},"Digital Technology":{"ca1":9,"ca2":9},"Livestock Farming":{"ca1":9,"ca2":9},"History":{"ca1":5,"ca2":5},"Yoruba":{"ca1":6,"ca2":6},"Business Studies":{"ca1":8,"ca2":8},"Physical & Health Education":{"ca1":10,"ca2":10},"Cultural and Creative Arts":{"ca1":5,"ca2":5},"Social & Citizenship Studies":{"ca1":7,"ca2":7},"Cristian Religious studies":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-7-1","subject":"Mathematics","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-2","subject":"English Language","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-3","subject":"Intermediate Science","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-4","subject":"Digital Technology","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-5","subject":"Livestock Farming","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-6","subject":"History","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-7","subject":"Yoruba","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-8","subject":"Business Studies","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-9","subject":"Physical & Health Education","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-10","subject":"Cultural and Creative Arts","ca1":5,"ca2":5,"ca3":0,"exam":0,"total":10,"grade":"C5","remark":"Satisfactory","color":"#6366f1","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-11","subject":"Social & Citizenship Studies","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-7-12","subject":"Cristian Religious studies","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-8',
  'STX/2024/102',
  'Kenechukwu Nnamdi',
  'Male',
  14,
  'JSS 1',
  'stanbax2025',
  ARRAY['Kenechukwu Nnamdi', 'nnamdi kenechukwu', 'kenechukwu nnamdi', 'Daramola Darasimi']::TEXT[],
  '{"Mathematics":{"ca1":10,"ca2":10},"English Language":{"ca1":10,"ca2":10},"Intermediate Science":{"ca1":10,"ca2":7},"Digital Technology":{"ca1":9,"ca2":0},"Livestock Farming":{"ca1":10,"ca2":10},"History":{"ca1":10,"ca2":10},"Yoruba":{"ca1":10,"ca2":8},"Business Studies":{"ca1":10,"ca2":10},"Physical & Health Education":{"ca1":10,"ca2":10},"Cultural and Creative Arts":{"ca1":10,"ca2":10},"Social & Citizenship Studies":{"ca1":8,"ca2":8},"Cristian Religious studies":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":10},"Basic Science":{"ca1":10,"ca2":10},"Pre-Vocational":{"ca1":10,"ca2":10},"Social Citizenship":{"ca1":7,"ca2":10},"BSE":{"ca1":6,"ca2":6},"PVS":{"ca1":7,"ca2":8},"CCA":{"ca1":7,"ca2":10},"Literature":{"ca1":10,"ca2":10},"CRS":{"ca1":10,"ca2":10},"PHE":{"ca1":10,"ca2":10},"Writing":{"ca1":8,"ca2":8},"Computer":{"ca1":8,"ca2":8}}'::JSONB,
  '[{"id":"grd-stu-8-1","subject":"Mathematics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-2","subject":"English Language","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-3","subject":"Intermediate Science","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-4","subject":"Digital Technology","ca1":9,"ca2":0,"ca3":0,"exam":0,"total":9,"grade":"C6","remark":"Fair","color":"#d97706","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-5","subject":"Livestock Farming","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-6","subject":"History","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-7","subject":"Yoruba","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-8","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-9","subject":"Physical & Health Education","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-10","subject":"Cultural and Creative Arts","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-11","subject":"Social & Citizenship Studies","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-12","subject":"Cristian Religious studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-13","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-14","subject":"Basic Science","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-15","subject":"Pre-Vocational","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-16","subject":"Social Citizenship","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-17","subject":"BSE","ca1":6,"ca2":6,"ca3":0,"exam":0,"total":12,"grade":"C4","remark":"Credit","color":"#4f46e5","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-18","subject":"PVS","ca1":7,"ca2":8,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-19","subject":"CCA","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-20","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-21","subject":"CRS","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-22","subject":"PHE","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-23","subject":"Writing","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-8-24","subject":"Computer","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-26',
  'SBS/2026/PRY5/001',
  'Ezeani victor',
  'Male',
  9,
  'Primary 4',
  'stanbax2025',
  ARRAY['Ezeani victor', 'victor ezeani', 'ezeani victor']::TEXT[],
  '{}'::JSONB,
  '[{"id":"grd-stu-roster-26-mathematics","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Mathematics","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-26-english-language","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"English Language","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-26-basic-science-technology-","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Basic Science & Technology ","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-26-prevocational-studies-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Prevocational Studies ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-26-cultural-and-creative-arts-","ca1":7,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Cultural and Creative Arts ","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-26-physical-health-education-","ca1":10,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":20,"remark":"Fail","subject":"Physical & Health Education ","term1Total":20,"annualAverage":20},{"id":"grd-stu-roster-26-history","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"History","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-26-cristian-religious-studies","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Cristian Religious studies","term1Total":15,"annualAverage":15},{"id":"grd-stu-roster-26-computer","ca1":7,"ca2":7,"ca3":0,"exam":0,"grade":"F9","total":14,"remark":"Fail","subject":"Computer","term1Total":14,"annualAverage":14},{"id":"grd-stu-roster-26-social-citizenship-studies","ca1":6,"ca2":10,"ca3":0,"exam":0,"grade":"F9","total":16,"remark":"Fail","subject":"Social & Citizenship Studies","term1Total":16,"annualAverage":16},{"id":"grd-stu-roster-26-writing","ca1":8,"ca2":9,"ca3":0,"exam":0,"grade":"F9","total":17,"remark":"Fail","subject":"Writing","term1Total":17,"annualAverage":17},{"id":"grd-stu-roster-26-literature","ca1":7,"ca2":8,"ca3":0,"exam":0,"grade":"F9","total":15,"remark":"Fail","subject":"Literature","term1Total":15,"annualAverage":15}]'::JSONB,
  'Partially Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'stu-roster-43',
  'SBS/2026/JSS2/007',
  'Adeshina Darasimi',
  'Female',
  12,
  'JSS 2',
  'stanbax2025',
  ARRAY['Adeshina Darasimi', 'darasimi adeshina', 'adeshina darasimi']::TEXT[],
  '{"Yoruba":{"ca1":9,"ca2":9},"CRS":{"ca1":9,"ca2":9},"Livestock":{"ca1":9,"ca2":8},"B.S.":{"ca1":9,"ca2":8},"PHE":{"ca1":10,"ca2":9},"History":{"ca1":8,"ca2":8},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":10,"ca2":7},"Intermediate Science":{"ca1":9,"ca2":10},"Digital Tech":{"ca1":9,"ca2":9},"English":{"ca1":9,"ca2":4},"Mathematics":{"ca1":4,"ca2":10}}'::JSONB,
  '[{"id":"grd-stu-roster-43-1","subject":"Yoruba","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-2","subject":"CRS","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-3","subject":"Livestock","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-4","subject":"B.S.","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-5","subject":"PHE","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-6","subject":"History","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-8","subject":"CCA","ca1":10,"ca2":7,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-9","subject":"Intermediate Science","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-10","subject":"Digital Tech","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-11","subject":"English","ca1":9,"ca2":4,"ca3":0,"exam":0,"total":13,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-stu-roster-43-12","subject":"Mathematics","ca1":4,"ca2":10,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-1793085909910',
  'STX/2026/111',
  'Izuagbe Elizabeth',
  'Female',
  13,
  'JSS 2',
  'stanbax2025',
  ARRAY['Izuagbe Elizabeth', 'elizabeth izuagbe', 'izuagbe elizabeth']::TEXT[],
  '{"Yoruba":{"ca1":7,"ca2":7},"CRS":{"ca1":9,"ca2":9},"Livestock":{"ca1":9,"ca2":8},"B.S.":{"ca1":8,"ca2":8},"PHE":{"ca1":10,"ca2":8},"History":{"ca1":9,"ca2":10},"Business Studies":{"ca1":10,"ca2":10},"CCA":{"ca1":9,"ca2":7},"Intermediate Science":{"ca1":8,"ca2":10},"Digital Tech":{"ca1":7,"ca2":7},"English":{"ca1":10,"ca2":8},"Mathematics":{"ca1":5,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-1793085909910-1","subject":"Yoruba","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-2","subject":"CRS","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-3","subject":"Livestock","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-4","subject":"B.S.","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-5","subject":"PHE","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-6","subject":"History","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-7","subject":"Business Studies","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-8","subject":"CCA","ca1":9,"ca2":7,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-9","subject":"Intermediate Science","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-10","subject":"Digital Tech","ca1":7,"ca2":7,"ca3":0,"exam":0,"total":14,"grade":"B3","remark":"Good","color":"#0284c7","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-11","subject":"English","ca1":10,"ca2":8,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-1793085909910-12","subject":"Mathematics","ca1":5,"ca2":10,"ca3":0,"exam":0,"total":15,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Outstanding'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-ss3-1',
  'SBS/2026/SS3/001',
  'Ezenwa Uchechukwu',
  'Female',
  17,
  'SSS 3 Arts & Commercial',
  'stanbax2025',
  ARRAY['Ezenwa Uchechukwu']::TEXT[],
  '{"C.H.S":{"ca1":10,"ca2":10},"Yoruba":{"ca1":10,"ca2":9},"Digital Tech":{"ca1":10,"ca2":10},"C.R.S":{"ca1":9,"ca2":9},"Mathematics":{"ca1":9,"ca2":10},"Government":{"ca1":10,"ca2":10},"Literature":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-ss3-1-1","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-2","subject":"Yoruba","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-3","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-4","subject":"C.R.S","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-5","subject":"Mathematics","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-6","subject":"Government","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-7","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-1-8","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-ss3-2',
  'SBS/2026/SS3/002',
  'Iteji Favour',
  'Female',
  17,
  'SSS 3 Arts & Commercial',
  'stanbax2025',
  ARRAY['Iteji Favour']::TEXT[],
  '{"C.H.S":{"ca1":10,"ca2":10},"Yoruba":{"ca1":10,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"C.R.S":{"ca1":8,"ca2":8},"Mathematics":{"ca1":9,"ca2":10},"Government":{"ca1":10,"ca2":10},"Literature":{"ca1":10,"ca2":10},"English":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-ss3-2-1","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-2","subject":"Yoruba","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-3","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-4","subject":"C.R.S","ca1":8,"ca2":8,"ca3":0,"exam":0,"total":16,"grade":"B2","remark":"Very Good","color":"#2563eb","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-5","subject":"Mathematics","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-6","subject":"Government","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-7","subject":"Literature","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-2-8","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-ss3-3',
  'SBS/2026/SS3/003',
  'Ademijoke David',
  'Male',
  17,
  'SSS 3 Science',
  'stanbax2025',
  ARRAY['Ademijoke David']::TEXT[],
  '{"C.H.S":{"ca1":10,"ca2":10},"Physics":{"ca1":10,"ca2":10},"Yoruba":{"ca1":10,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"Chemistry":{"ca1":10,"ca2":10},"Biology":{"ca1":9,"ca2":9},"Mathematics":{"ca1":9,"ca2":10},"English":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-ss3-3-1","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-2","subject":"Physics","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-3","subject":"Yoruba","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-4","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-5","subject":"Chemistry","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-6","subject":"Biology","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-7","subject":"Mathematics","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-3-8","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-ss3-4',
  'SBS/2026/SS3/004',
  'Ejionye Chidubem',
  'Male',
  17,
  'SSS 3 Science',
  'stanbax2025',
  ARRAY['Ejionye Chidubem']::TEXT[],
  '{"C.H.S":{"ca1":10,"ca2":10},"Digital Tech":{"ca1":10,"ca2":10},"Chemistry":{"ca1":10,"ca2":10},"Biology":{"ca1":10,"ca2":9},"Mathematics":{"ca1":9,"ca2":10},"English":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-ss3-4-1","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-4-2","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-4-3","subject":"Chemistry","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-4-4","subject":"Biology","ca1":10,"ca2":9,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-4-5","subject":"Mathematics","ca1":9,"ca2":10,"ca3":0,"exam":0,"total":19,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-4-6","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-ss3-5',
  'SBS/2026/SS3/005',
  'Okwuchukwu Onyedika',
  'Male',
  17,
  'SSS 3 Science',
  'stanbax2025',
  ARRAY['Okwuchukwu Onyedika']::TEXT[],
  '{"C.H.S":{"ca1":10,"ca2":10},"Physics":{"ca1":9,"ca2":9},"Digital Tech":{"ca1":10,"ca2":10},"Chemistry":{"ca1":9,"ca2":9},"Biology":{"ca1":9,"ca2":8},"Mathematics":{"ca1":8,"ca2":10},"English":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-ss3-5-1","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-5-2","subject":"Physics","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-5-3","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-5-4","subject":"Chemistry","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-5-5","subject":"Biology","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-5-6","subject":"Mathematics","ca1":8,"ca2":10,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-5-7","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();
INSERT INTO public.students (id, reg_number, name, gender, age, grade, password, aliases, midterm_scores, grades, fee_status)
VALUES (
  'std-ss3-6',
  'SBS/2026/SS3/006',
  'Adeleke Joshua',
  'Male',
  17,
  'SSS 3 Science',
  'stanbax2025',
  ARRAY['Adeleke Joshua']::TEXT[],
  '{"C.H.S":{"ca1":10,"ca2":10},"Physics":{"ca1":9,"ca2":9},"Digital Tech":{"ca1":10,"ca2":10},"Chemistry":{"ca1":9,"ca2":9},"Biology":{"ca1":9,"ca2":8},"Mathematics":{"ca1":7,"ca2":10},"English":{"ca1":10,"ca2":10}}'::JSONB,
  '[{"id":"grd-std-ss3-6-1","subject":"C.H.S","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-6-2","subject":"Physics","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-6-3","subject":"Digital Tech","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-6-4","subject":"Chemistry","ca1":9,"ca2":9,"ca3":0,"exam":0,"total":18,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-6-5","subject":"Biology","ca1":9,"ca2":8,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-6-6","subject":"Mathematics","ca1":7,"ca2":10,"ca3":0,"exam":0,"total":17,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true},{"id":"grd-std-ss3-6-7","subject":"English","ca1":10,"ca2":10,"ca3":0,"exam":0,"total":20,"grade":"A1","remark":"Excellent Distinction","color":"#16a34a","term":"1st Term","academicSession":"2026/2027 Academic Session","isMidterm":true}]'::JSONB,
  'Fully Paid'
) ON CONFLICT (id) DO UPDATE SET
  reg_number = EXCLUDED.reg_number,
  name = EXCLUDED.name,
  gender = EXCLUDED.gender,
  age = EXCLUDED.age,
  grade = EXCLUDED.grade,
  password = EXCLUDED.password,
  aliases = EXCLUDED.aliases,
  midterm_scores = EXCLUDED.midterm_scores,
  grades = EXCLUDED.grades,
  fee_status = EXCLUDED.fee_status,
  updated_at = now();

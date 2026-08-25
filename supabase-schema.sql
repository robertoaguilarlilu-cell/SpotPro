-- SpotPro — esquema inicial de Supabase
-- Ejecuta esto completo en: Supabase Dashboard → SQL Editor → New query → Run

-- 1) Inventario de espacios OOH (lo que se muestra en el feed)
create table if not exists public.spots (
  id uuid primary key default gen_random_uuid(),
  spot_type text not null check (spot_type in ('Espectacular','Mupi','Valla','Pantalla digital','Parabús','Puente peatonal')),
  location text not null,
  city text not null,
  price_mxn numeric not null,
  status text not null default 'disponible' check (status in ('disponible','reservado')),
  created_at timestamptz not null default now()
);

alter table public.spots enable row level security;

create policy "Cualquiera puede ver los espacios"
  on public.spots for select
  using (true);

-- 2) Solicitudes de marcas ("Solicita un espacio")
create table if not exists public.space_requests (
  id uuid primary key default gen_random_uuid(),
  brand_name text not null,
  contact_email text not null,
  contact_phone text,
  city text not null,
  spot_type text,
  budget_range text,
  message text,
  created_at timestamptz not null default now()
);

alter table public.space_requests enable row level security;

create policy "Cualquiera puede enviar una solicitud"
  on public.space_requests for insert
  with check (true);

-- 3) Registro de aliados OOH ("Quiero ser aliado")
create table if not exists public.ally_signups (
  id uuid primary key default gen_random_uuid(),
  company_name text not null,
  contact_name text not null,
  contact_email text not null,
  contact_phone text,
  city text not null,
  inventory_description text,
  created_at timestamptz not null default now()
);

alter table public.ally_signups enable row level security;

create policy "Cualquiera puede registrarse como aliado"
  on public.ally_signups for insert
  with check (true);

-- 4) Datos de ejemplo para el feed (mismos que ya se ven en el portal)
insert into public.spots (spot_type, location, city, price_mxn) values
  ('Espectacular', 'Autopista México–Acapulco Km 84', 'Cuernavaca, Morelos', 17400),
  ('Mupi', 'Av. Domingo Diez 1101, Lomas de la Selva', 'Cuernavaca, Morelos', 4292),
  ('Valla', 'Av. Compositores 101, Rancho Tetela', 'Cuernavaca, Morelos', 6032),
  ('Pantalla digital', 'Av. Insurgentes Sur 1457', 'Ciudad de México', 38500),
  ('Espectacular', 'Av. Constitución y Garza Sada', 'Monterrey, N.L.', 22900),
  ('Parabús', 'Av. Vallarta 3200, Zapopan', 'Guadalajara, Jal.', 5150),
  ('Mupi', 'Blvd. Díaz Ordaz 87, Acapantzingo', 'Cuernavaca, Morelos', 4292),
  ('Valla', 'Del Ferrocarril, Patios de la Estación', 'Cuernavaca, Morelos', 6032),
  ('Espectacular', 'Periférico Sur y Anillo Vial', 'Puebla, Pue.', 19800)
on conflict do nothing;

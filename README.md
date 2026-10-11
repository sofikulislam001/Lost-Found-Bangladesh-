# Lost & Found Bangladesh

A Bangladesh-wide lost & found platform built with Next.js, TypeScript, Tailwind CSS and Supabase.

## Included
- Responsive premium landing page
- Browse/search/filter reports
- Auth: signup/signin with Supabase Auth
- Multi-step lost/found posting
- Image upload to Supabase Storage
- Item details + safety guidance
- Smart match RPC based on category, district, date and text similarity
- Dashboard, profile, notifications and realtime-ready messaging
- Admin/moderator dashboard
- RLS-backed database
- 64 districts + categories seeded
- Vercel-ready

## Supabase
Project URL: https://faprojvktzymnvnotlgg.supabase.co

The database, RLS, storage buckets, realtime publication and matching functions are already configured in the connected Supabase project.

## Run locally
```bash
npm install
cp .env.example .env.local
npm run dev
```
Open http://localhost:3000.

## Admin
The bootstrap admin email is `jihadbondo50@gmail.com`. The database trigger automatically gives that email the `admin` role when the account is created. Do not put or share a password in source code.

## Vercel
Import this repository into Vercel and add the two variables from `.env.example` (they are already populated for this project). The publishable key is intended for browser use; never add a Supabase service-role/secret key to client-side environment variables.

## Production checklist
- Configure Supabase Auth email templates and site URL to the final Vercel URL.
- Turn on email confirmation if desired.
- Add custom domain later if desired.
- For a production map picker, add Leaflet/MapLibre and store latitude/longitude from the picker. District/location-text search already works without it.

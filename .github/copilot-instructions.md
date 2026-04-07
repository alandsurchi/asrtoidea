# Project Guidelines

## Architecture
- Flutter app lives at `lib/` with layered structure:
  - `lib/presentation/`: screens and UI state notifiers
  - `lib/domain/`: models and repository contracts
  - `lib/data/`: network client and repository implementations
  - `lib/core/`: shared exports, config, errors, utilities
- Express backend lives at `backend/`:
  - `backend/server.js`: app bootstrap, middleware, route mounting, global error handling
  - `backend/routes/`: feature routers (`auth`, `projects`, `ideas`)
  - `backend/middleware/auth.js`: JWT auth middleware
  - `backend/db.js`: PostgreSQL pool and query helper

## Build and Test
- Flutter (run from repo root):
  - `flutter pub get`
  - `flutter run`
  - `flutter test`
  - `flutter build web --release`
- Backend (run from `backend/`):
  - `npm install`
  - `npm run dev`
  - `npm start`
  - `npm run migrate`

## Conventions
- Keep Flutter route changes centralized in `lib/routes/app_routes.dart`.
- Use existing Riverpod/provider patterns already in `lib/presentation/**/notifier/` and `lib/providers/`.
- Reuse shared config/error abstractions instead of ad-hoc logic:
  - `lib/core/config/env_config.dart`
  - `lib/core/errors/app_exception.dart`
- Backend data access should use parameterized queries through `backend/db.js` helpers.
- Backend route handlers should pass unexpected errors to Express global error middleware (`next(err)`).

## Environment and Pitfalls
- Do not modify generated/build artifacts such as `build/`, `.dart_tool/`, and platform-generated files unless required.
- Flutter startup expects `.env` to exist and be loadable (`lib/main.dart`).
- Keep portrait lock and web width constraints in `lib/main.dart` unless explicitly changing app UX requirements.
- Backend requires `DATABASE_URL`; set `JWT_SECRET` for non-dev environments.

## References
- Project overview and onboarding: `README.md`
- Flutter dependencies/assets/fonts: `pubspec.yaml`
- Backend scripts/dependencies: `backend/package.json`
- Database schema migration: `backend/migrations/001_init.sql`
- Containerized web deployment: `Dockerfile`, `nginx.conf`, `railway.json`
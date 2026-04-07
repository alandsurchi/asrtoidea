---
name: Backend Threaded Comments Permissions
description: "Implement backend-only threaded comments, likes, and owner-only edit permissions for idea and project detail."
argument-hint: "Paste auth rules, migration naming, and API response contract"
agent: agent
---
Implement backend-only support for threaded comments and likes with strict permission rules.

Scope
- Modify backend code and SQL migrations only.
- Do not change Flutter UI in this task unless needed for API contract alignment documentation.

Context files to inspect first
- [backend/server.js](../../backend/server.js)
- [backend/routes/ideas.js](../../backend/routes/ideas.js)
- [backend/routes/projects.js](../../backend/routes/projects.js)
- [backend/middleware/auth.js](../../backend/middleware/auth.js)
- [backend/db.js](../../backend/db.js)
- [backend/migrations/001_init.sql](../../backend/migrations/001_init.sql)

Permission model (required)
- Only the owner of the parent idea/project can edit comments on that record.
- Authenticated users can add comments and replies.
- Authenticated users can like/unlike comments.

Functional requirements
1. Data model
- Add migration(s) for normalized threaded comments and likes (no JSON-only thread storage).
- Support parent-child relationships for replies.
- Support one like per user per comment using uniqueness constraints.
- Include created_at/updated_at and soft-delete strategy if needed.

2. API endpoints
- Add endpoints for both ideas and projects to:
  - list comment thread
  - create top-level comment
  - create reply
  - edit comment (owner of parent idea/project only)
  - like/unlike comment
- Return stable, explicit response shapes suitable for Flutter mapping.

3. Validation and safety
- Validate input lengths and empty payloads.
- Enforce entity existence checks and permission checks before writes.
- Use parameterized SQL only.
- Route unexpected errors to global error middleware via next(err).

4. Performance and correctness
- Fetch threaded comments efficiently with deterministic ordering.
- Avoid N+1 queries where practical.
- Ensure like counts are accurate under concurrent requests.

5. Backward compatibility
- Keep existing ideas/projects endpoints working.
- If legacy comments JSON exists, provide migration/backfill strategy.

Validation
- Add/extend backend tests or verification scripts for permissions and thread behavior.
- Include at least one negative test for unauthorized edit attempts.

Response format
1. Schema changes and rationale
2. Endpoints added/changed
3. Permission checks implemented
4. Sample request/response payloads
5. Validation results
6. Follow-up tasks for frontend integration

---
name: Idea Detail View Integration Mega
description: "Integrate idea-detail-view with real app data, deep links, owner permissions, and AI template flow without changing UI design."
argument-hint: "Paste extra constraints, endpoint rules, and acceptance criteria"
agent: agent
---
Implement an end-to-end production integration for the idea detail experience in this repository, using the invocation text as the source of truth.

Core objective
- Keep the current UI design and element placement exactly as-is, but make the page fully dynamic, API-backed, and functional.
- Route every idea/project card click to the same detail page and render real data for the selected record.
- Upgrade the AI ideation flow so it asks better discovery questions, fills a complete template, and publishes data that directly powers the detail page.

Context files to inspect first
- [lib/presentation/idea_detail_view/idea_detail_view.dart](../../lib/presentation/idea_detail_view/idea_detail_view.dart)
- [lib/presentation/idea_detail_view/notifier/idea_detail_notifier.dart](../../lib/presentation/idea_detail_view/notifier/idea_detail_notifier.dart)
- [lib/presentation/idea_detail_view/widgets/idea_detail_header_widget.dart](../../lib/presentation/idea_detail_view/widgets/idea_detail_header_widget.dart)
- [lib/presentation/idea_detail_view/widgets/idea_action_bar_widget.dart](../../lib/presentation/idea_detail_view/widgets/idea_action_bar_widget.dart)
- [lib/presentation/idea_detail_view/widgets/idea_comment_section_widget.dart](../../lib/presentation/idea_detail_view/widgets/idea_comment_section_widget.dart)
- [lib/routes/app_routes.dart](../../lib/routes/app_routes.dart)
- [lib/presentation/ideas_dashboard_screen/ideas_dashboard_screen.dart](../../lib/presentation/ideas_dashboard_screen/ideas_dashboard_screen.dart)
- [lib/presentation/project_explore_dashboard_screen/project_explore_dashboard_screen.dart](../../lib/presentation/project_explore_dashboard_screen/project_explore_dashboard_screen.dart)
- [lib/data/implementations/api_ai_repository.dart](../../lib/data/implementations/api_ai_repository.dart)
- [lib/presentation/magic_idea_chat_screen/notifier/magic_idea_chat_notifier.dart](../../lib/presentation/magic_idea_chat_screen/notifier/magic_idea_chat_notifier.dart)
- [backend/routes/ideas.js](../../backend/routes/ideas.js)
- [backend/routes/projects.js](../../backend/routes/projects.js)
- [backend/migrations/001_init.sql](../../backend/migrations/001_init.sql)

Hard constraints (non-negotiable)
1. Do not change visual design, spacing, typography, colors, section order, or element placement in the detail UI.
2. Do not replace the current screen with a new design.
3. Do not keep or add hardcoded content for detail data.
4. Preserve architecture conventions in this repo (Flutter layers, Riverpod patterns, backend parameterized SQL, centralized routes).
5. Keep existing critical app constraints in main app bootstrap untouched unless absolutely required.

Functional requirements
1. Universal navigation to detail page
- Wire all idea and project cards (Home, Explore, and other entry points) to open the detail route with real identifiers.
- Pass route arguments that allow resolving both entity type and ID (for example: idea vs project).
- Remove legacy placeholder IDs such as idea_1 or idea_index patterns where possible.

2. Dynamic idea-detail-view integration
- Replace mock loading in notifier with repository/API-backed loading by ID.
- Render dynamic fields in-place (same UI widgets):
  - category (generated selection)
  - priority (generated selection)
  - title
  - creator name and created date
  - status (for the in-progress chip)
  - view count (real or persisted counter)
  - overview (AI generated short description)
  - details (full AI-confirmed template/details)
  - attachments (real uploaded assets)
- Keep section visuals unchanged.
- Remove the Team section from detail view.

3. Share and deep link
- Make share button functional.
- Generate a stable semantic link to this exact detail record:
  - /idea/{id}
  - /project/{id}
- Support opening that link into this app and landing on the correct detail record.
- If opened on web, resolve the semantic path and route internally to idea-detail-view with the right entity type and ID.
- Keep existing top-bar layout unchanged.

4. Owner-only actions
- Show edit and status controls only when current user is the owner/creator.
- Hide owner-only controls for non-owners.
- Persist status and edit changes through API and reflect immediately in UI.

5. Comments system (fully functional)
- Implement per-record comments for idea/project detail with:
  - add comment
  - like comment
  - reply to comment
  - edit comment (allowed only for the owner of the idea/project)
- Persist comment threads in backend (not in-memory only).
- Support optimistic updates with rollback/error feedback.
- Keep current comments visual style.

6. Data modeling and backend support
- Extend backend schema/endpoints as needed to store detail-level fields and comment thread metadata.
- Use parameterized SQL queries only.
- Route unexpected backend errors to global Express error middleware.
- Add migration(s) instead of manually editing existing runtime DB state.

7. AI ideation flow upgrade (strong discovery + template fill)
- Improve Ed flow to handle two user intents:
  - I have an idea but do not know how to build it.
  - I have a partial idea and want to improve it.
- Ask focused discovery questions, then produce a complete structured template.
- Keep a machine-readable state envelope compatible with existing parser flow.
- Ensure generated template includes all fields needed by detail page, including category, priority, status, overview/details content, and attachment references when available.
- Ensure publish flow maps template output into persisted idea/project data so detail page loads it directly with no hardcoded fallback.

Implementation guidance
- Prefer adding repository methods for get by ID and detail retrieval instead of overloading list endpoints.
- Introduce a dedicated detail DTO/model mapper if needed to avoid polluting card models.
- Keep route changes centralized in [lib/routes/app_routes.dart](../../lib/routes/app_routes.dart).
- Reuse existing provider/notifier patterns in [lib/presentation](../../lib/presentation).
- Preserve auth behavior and avoid local fallback for auth/HTTP status errors.

Acceptance criteria
1. Clicking any real idea/project card opens detail page with that item data.
2. No mock idea payload remains in detail notifier flow.
3. Team section is removed.
4. Share action creates usable deep link to the same record.
5. Comments support add/like/reply/edit and persist.
6. Owner-only controls are correctly gated.
7. AI asks improved discovery questions, fills full template, and published output appears in detail page.
8. Existing visual design remains unchanged.

Validation
- Run relevant Flutter checks/tests and backend validation commands.
- Report what passed and what could not run.

Response format
1. Assumptions made
2. Root causes in current implementation
3. Files changed and why
4. Data contract/schema changes
5. Verification results
6. Remaining risks and follow-up items

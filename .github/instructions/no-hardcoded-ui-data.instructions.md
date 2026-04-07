---
name: No Hardcoded UI Data in Presentation
description: "Use when editing Flutter presentation screens or notifiers. Forbid hardcoded business data and require repository-backed state."
applyTo: "lib/presentation/**/*.dart"
---
# No Hardcoded UI Data Policy

Apply these rules to all Flutter presentation-layer changes in this workspace.

Required rules
- Never hardcode business/domain content in screens, notifiers, or presentation widgets.
- Never ship mock lists, fake IDs, fake names, fixed dates, or fixed status/priority/category values in production paths.
- Always source idea/project/user data from repositories/providers/API-backed state.

Allowed exceptions
- Styling constants (colors, spacing, typography, icons) are allowed.
- Placeholder copy for loading/empty/error states is allowed.
- Demo/mock data is allowed only in tests, storybook/demo-only files, or explicit debug-only paths that are not production defaults.

Implementation expectations
- Pass real record identifiers through route arguments and load by ID in notifiers.
- Represent loading/error/empty states explicitly rather than fabricating domain data.
- Use optimistic updates only when rollback/error handling is implemented.
- Keep edits and mutations synchronized with backend persistence.

Review checklist before finalizing
- Search changed presentation files for signs of hardcoded content (for example: "mock", "sample", inline fake records).
- Confirm data rendering comes from notifier state populated by repository calls.
- Confirm no placeholder ID routing patterns remain in user flows.

---
name: Ed Discovery Template Quality Gates
description: "Improve Ed AI discovery questions and enforce publish quality gates for structured idea templates."
argument-hint: "Paste required fields, question style, and acceptance checks"
agent: agent
---
Implement a focused upgrade to the Ed AI discovery-to-template flow in this repository.

Scope
- Only improve AI chat discovery logic, template quality checks, and publish-readiness signaling.
- Do not redesign chat UI or unrelated screens.

Primary goal
- Ed should reliably ask high-value, minimal questions, then produce a complete, high-quality template that is safe to publish and compatible with the app's machine-readable state parsing.

Context files to inspect first
- [lib/data/implementations/api_ai_repository.dart](../../lib/data/implementations/api_ai_repository.dart)
- [lib/presentation/magic_idea_chat_screen/notifier/magic_idea_chat_notifier.dart](../../lib/presentation/magic_idea_chat_screen/notifier/magic_idea_chat_notifier.dart)
- [lib/domain/models/magic_idea_chat_model.dart](../../lib/domain/models/magic_idea_chat_model.dart)
- [lib/presentation/magic_idea_chat_screen/active_chat_screen.dart](../../lib/presentation/magic_idea_chat_screen/active_chat_screen.dart)

Requirements
1. Dual-intent discovery
- Detect and support both user intents:
  - "I have an idea but do not know what to do"
  - "I already have a partial idea and want to improve it"
- Adapt questions to intent while keeping question count low per turn.

2. Strong questioning policy
- Ask 1-3 focused questions per turn, prioritized by highest impact missing data.
- Avoid repeating already answered questions.
- Prefer specific, decision-driving questions over generic brainstorming prompts.

3. Canonical template completion
- Keep one canonical template schema and populate it progressively.
- Ensure complete coverage for publish-critical fields, including:
  - title
  - problemStatement
  - targetUsers
  - solutionSummary
  - keyFeatures
  - businessModel
  - launchPlan
  - risks
  - nextSteps
  - category
  - priority
  - status
  - overview
  - details
  - attachments

4. Quality gates before readyToPublish=true
- Add explicit quality checks for:
  - completeness (required fields present)
  - clarity (no vague placeholders)
  - actionability (next steps are concrete)
  - consistency (no contradictory values across fields)
- Set readyToPublish=true only if all quality gates pass.
- When not ready, return concise missingFields and ask next best questions.

5. Protocol compatibility
- Preserve one machine-readable state envelope per assistant response, compatible with existing parser behavior.
- Keep the response robust when provider fails by returning a visible helper reply plus valid state payload.

6. Publish mapping readiness
- Ensure output template is immediately mappable into persisted idea/project records without hardcoded fallback text.
- Keep category/priority/status values normalized to app-supported values.

Validation
- Add/update targeted tests for parser compatibility and readiness gating where practical.
- Verify no regressions to current chat history persistence.

Response format
1. Discovery strategy implemented
2. Quality-gate rules added
3. Files changed and why
4. Example assistant outputs with state envelope
5. Verification results
6. Remaining edge cases

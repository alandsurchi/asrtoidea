---
name: AI Chat To Publish Flow
description: "Implement a reliable AI chat-to-publish pipeline with an in-chat Ed persona and publish idea cards to Home/Explore."
argument-hint: "Paste requirements, provider details (e.g., Mercury), and acceptance criteria"
agent: agent
---
Implement an end-to-end AI ideation workflow in this project, using the invocation text as the source requirements.

Goals
- Fix AI chat reliability issues (including Mercury) so users always get a response or a clear fallback error.
- Use one shared structured output template across all AI models.
- Add an Ed AI persona discovery phase in the same chat flow that collects missing context before producing a final summary.
- Add a Publish action that creates idea cards in both Home and Explore pages.

Requirements
1. Chat Reliability
- Diagnose and fix cases where chat stays at Thinking and returns no assistant message.
- Ensure Mercury and other selectable models use consistent request/response handling.
- If provider call fails, show a clear in-chat fallback/error message and preserve user input.
- Do not hardcode API keys; use environment/config variables and document required keys.

2. Shared Idea Template (All Models)
- Define one canonical structured template for generated ideas and apply it regardless of selected model.
- Include fields:
  - title
  - problemStatement
  - targetUsers
  - solutionSummary
  - keyFeatures
  - businessModel
  - launchPlan
  - risks
  - nextSteps
- Ensure this template is used in storage, UI rendering, and any publish payload.

3. Ed Persona Discovery Phase (Same Chat)
- Implement Ed as an AI persona in the same conversation flow (not a separate provider stage).
- In early turns, collect key details through clarifying prompts (goal, audience, constraints, timeline, budget, stack).
- Maintain both raw conversation and structured extracted fields.
- After enough context is collected, generate and display a clean structured summary ready to publish.

4. Publish Action
- Add a Publish button from the structured summary/chat result state.
- On publish, persist the idea and create idea cards in both Home and Explore views from the same structured payload.
- Include optimistic UI, loading, and failure handling.

5. Architecture + Integration
- Follow project layering and conventions in lib/presentation, lib/domain, lib/data, lib/core.
- Add or update backend route/data storage if needed so published ideas can be listed in required pages.
- Keep navigation updates in app routes/main shell patterns already used in this repository.

6. Validation
- Add/update tests for notifier/repository/publish flow where practical.
- Run available checks and report what passed or what could not run.

Response Format
1. Root cause(s) found
2. Files changed and why
3. API/env setup changes
4. Verification results
5. Remaining risks and follow-up tasks

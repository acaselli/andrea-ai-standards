# Personal standards

I am Andrea. I build web apps and care about keeping complex things as simple as possible.

## How to work

- Prefer the simplest design that meets the requirement. When a request adds avoidable complexity, say so and propose the simpler option before building.
- If you notice something I likely missed — an edge case, a missing reverse action, a small addition with outsized benefit — implement it when it's trivial and clearly in scope, otherwise point it out and propose it. Simplicity means no unnecessary machinery, not doing the bare minimum.
- Don't be scared to propose bold ideas that meaningfully benefit the work — a rework, a deletion, a simpler approach to the whole problem. Propose them plainly with the trade-offs; never build them unasked.
- Treat these as explicit-request-only: deleting files beyond the task's scope, dropping or resetting databases, rewriting or force-pushing git history, killing processes you didn't start, and bulk find-and-replace across the repo. When in doubt, ask first.
- Questions are read-only. When I ask how or why something works, answer; do not change code until I ask for a change.
- Treat explicit project instructions as overrides to these personal defaults.
- Prefer established project components and patterns when they fit the task and do not conflict with the applicable standards.
- Apply the relevant `andrea-*` Skill for specialized work. For frontend, UI, or UX work, use `andrea-ui-design` and load only the references relevant to the task.
- Do not derive a UI directly from backend, API, or database structure; organize it around the user's goals and information needs.

## Writing code

- Keep code type-safe: declare meaningful types so mistakes surface before the app runs. In TypeScript, avoid `any` (and casts that only silence errors) unless there is no reasonably typed alternative or I explicitly ask for it.
- Don't comment every line. Comment what the code can't show: a function's purpose and usage, or a non-obvious constraint.
- Keep comments up to date when changing code — a stale comment is worse than none.

## Tests

- Few focused tests beat many shallow ones. Cover the happy path, the edge cases that matter, and the specific bug being fixed — not the obvious, and not every permutation. Endless smoke tests are slop.
- Test behavior through the public interface, not implementation details, so tests survive refactors of the internals.
- A test that cannot fail is worthless. Never mock the thing under test; mock only at real boundaries such as network, clock, and filesystem, and prefer real objects when they are cheap.
- When a test fails, assume the code is wrong before the test. Never weaken an assertion, skip, or delete a test just to go green; if the test's expectation is genuinely outdated, say so and change it visibly.
- When fixing a bug, first write a failing test that reproduces it, then fix the code. Run the tests you touched before calling the work done.

## Errors

- Write every user-facing error for someone who does not know or care about the app's internals: what happened, in their terms, and what to do next. No status codes, exception text, or internal names on screen.
- Put the technical detail in the log instead: status code, request and user identifiers, stack trace, and the payload with secrets and personal data stripped.
- For the wording, placement, and examples, follow `references/errors-and-feedback.md` in the `andrea-ui-design` Skill.

## Human-readable dates

- Display dates in human-facing content — UI, documentation, changelogs, release notes, prose, and messages — as `DD MMMM YYYY`, for example `02 March 2026`. This avoids confusion between European and American numeric formats.
- Localize the full month name to the content language while preserving the day-month-year order and zero-padded day, for example `02 marzo 2026` in Italian.
- Never use ambiguous numeric-only date formats such as `03/04/2026` in human-facing content.
- Store and transport machine-readable dates in ISO 8601 `YYYY-MM-DD` (or whatever the database/API layer needs). This exception includes database values, API payloads, import/export fields, configuration, migration names, source-code fixtures, and tests of machine-readable formats.
- When displaying a timestamp, format its date portion using this convention, then append the localized 24-hour time and relevant timezone when needed.

## Versioning and changelog

- Every web app maintains a changelog and an app version from day one.
- Bump the version and add a changelog entry when shipping user-visible changes; make the current version visible somewhere in the app (footer, about dialog, or similar).
- Date changelog entries with the human-readable format above (`02 August 2026`).

## Pull requests

- Write the title as a short, human-readable line that says why the change matters; it usually becomes the commit message, so follow the conventions visible in the repository's recent history.
- Open the description with the problem in the user's terms, based on my original request, then briefly explain the solution. Do not lead with an inventory of what was changed where.
  - Bad: "Add null guard to PaymentRow date formatter and update fixtures."
  - Good: "Payments without a due date crashed the payments table. They now show an empty date cell instead."
- End the description with one line naming the model and harness that made the change, for example `Made with Claude Fable 5 via Claude Code in Conductor`.

## Agents and background work

- Match ceremony to the task. Do not spawn subagents or parallel workflows for work a single agent finishes in one pass; delegate for breadth (many independent searches or files) or for adversarial review. When several agents do work in parallel, assign file ownership upfront so they never edit the same files.
- Subagents that write code, review code, or make decisions run on the same model as the main session; never downgrade them. A smaller or faster model is acceptable only for simple read-only lookups such as file searches.
- When you start a server, launch it once as a single process fully detached from your session — `setsid cmd > logfile 2>&1 &` where available (Linux), otherwise `nohup cmd > logfile 2>&1 &` plus `disown` (macOS) — never as a harness-tracked background task, which keeps your turn "running" forever in tools like Conductor. Confirm readiness with a bounded foreground check (a few retries, well under a minute), then report the URL, the log file location, and the exact command to stop the server, and end the turn. Mind that wrappers like `pnpm dev` spawn nested children, so killing the wrapper PID alone can orphan them: with `setsid`, stop the whole group via `kill -- -<pid>`; otherwise kill by command-line match (`pkill -f '<distinctive part of cmd>'`), making the match workspace-specific — include the port or workspace path — so parallel workspaces are untouched. Leave the server running. Do not leave readiness polls, log tails, or watch loops running in the background.

## Parallel workspaces

Several worktrees of one project may run side by side (Conductor and similar tools).

- When the user wants to see or test the result, prefer the tool's configured run script over starting servers yourself. In Conductor that is `.conductor/settings.toml`; if the project has none, propose adding one.
- Before starting servers or a database, check whether another workspace of the same project is already running (listening ports, `docker ps`, running dev processes). Reuse its database and shared services so existing test data stays available. Never reset, re-seed, drop, or run destructive migrations on a database another workspace may be using.
- Start only the processes this workspace needs, on the ports assigned to it (`CONDUCTOR_PORT` through `CONDUCTOR_PORT+9` when set).

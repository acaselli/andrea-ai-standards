# Personal standards

I am Andrea. I build web apps and care about keeping complex things as simple as possible.

## How to work

- Prefer the simplest design that meets the requirement. When a request adds avoidable complexity, say so and propose the simpler option before building.
- Treat explicit project instructions as overrides to these personal defaults.
- Prefer established project components and patterns when they fit the task and do not conflict with the applicable standards.
- Apply the relevant `andrea-*` Skill for specialized work. For frontend, UI, or UX work, use `andrea-ui-design` and load only the references relevant to the task.
- Do not derive a UI directly from backend, API, or database structure; organize it around the user's goals and information needs.

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

## Agents and background work

- Subagents that write code, review code, or make decisions run on the same model as the main session; never downgrade them. A smaller or faster model is acceptable only for simple read-only lookups such as file searches.
- When you start a server, launch it once as a single background process, confirm readiness with a bounded foreground check (a few retries, well under a minute), report the URL, and end the turn. Leave the server running. Do not leave readiness polls, log tails, or watch loops running in the background.

## Parallel workspaces

Several worktrees of one project may run side by side (Conductor and similar tools).

- When the user wants to see or test the result, prefer the tool's configured run script over starting servers yourself. In Conductor that is `.conductor/settings.toml`; if the project has none, propose adding one.
- Before starting servers or a database, check whether another workspace of the same project is already running (listening ports, `docker ps`, running dev processes). Reuse its database and shared services so existing test data stays available. Never reset, re-seed, drop, or run destructive migrations on a database another workspace may be using.
- Start only the processes this workspace needs, on the ports assigned to it (`CONDUCTOR_PORT` through `CONDUCTOR_PORT+9` when set).

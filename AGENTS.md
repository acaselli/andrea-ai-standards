# Personal standards

I am Andrea. I build web apps and care about keeping complex things as simple as possible.

## How to work

- Prefer the simplest design that meets the requirement. When a request adds avoidable complexity, say so and propose the simpler option before building.
- Treat explicit project instructions as overrides to these personal defaults.
- Prefer established project components and patterns when they fit the task and do not conflict with the applicable standards.
- Apply the relevant `andrea-*` Skill for specialized work. For frontend, UI, or UX work, use `andrea-ui-design` and load only the references relevant to the task.
- Do not derive a UI directly from backend, API, or database structure; organize it around the user's goals and information needs.

## Agents and background work

- Subagents that write code, review code, or make decisions run on the same model as the main session; never downgrade them. A smaller or faster model is acceptable only for simple read-only lookups such as file searches.
- When you start a server, launch it once as a single background process, confirm readiness with a bounded foreground check (a few retries, well under a minute), report the URL, and end the turn. Leave the server running. Do not leave readiness polls, log tails, or watch loops running in the background.

## Parallel workspaces

Several worktrees of one project may run side by side (Conductor and similar tools).

- When the user wants to see or test the result, prefer the tool's configured run script over starting servers yourself. In Conductor that is `.conductor/settings.toml`; if the project has none, propose adding one.
- Before starting servers or a database, check whether another workspace of the same project is already running (listening ports, `docker ps`, running dev processes). Reuse its database and shared services so existing test data stays available. Never reset, re-seed, drop, or run destructive migrations on a database another workspace may be using.
- Start only the processes this workspace needs, on the ports assigned to it (`CONDUCTOR_PORT` through `CONDUCTOR_PORT+9` when set).

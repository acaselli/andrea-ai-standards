# Changelog

Notable changes to these standards. Versions follow [Semantic Versioning](https://semver.org/): patch for wording fixes, minor for new or expanded guidance, major for changes that reverse or remove earlier guidance.

## [0.3.0] - 02 September 2026

### Added

- `AGENTS.md`: error rule splitting plain, actionable user-facing messages from technical detail in the logs.
- `references/errors-and-feedback.md`: error wording standard (first-time-reader test, state whether the action happened, keep user input, no app persona), error classes with placement, what never to reveal, good and bad examples, toast usage rules moved here from the data-tables reference, and toast durations (errors and action-required warnings persist until dismissed, success and info time out, repeated failures update in place).
- `andrea-ui-design`: Sonner named as the toast default in the component stack (a stated exception to shadcn-first, since the Base UI distribution now ships its own Toast), and a "Choosing visual libraries" section with ordered selection criteria (shadcn adoption, visual polish, maintenance, reliability, customizable yet composable) for anything shadcn does not cover.

### Changed

- Changelog entry dates now follow the repository's own `DD MMMM YYYY` rule.
- `README.md`: structure and Skill description updated for the second reference.

## [0.2.0] - 02 September 2026

### Added

- `AGENTS.md`: human-readable date convention (`DD MMMM YYYY` in human-facing content, ISO 8601 for machine-readable data) and versioning/changelog requirements for every web app, migrated from the pre-repo global instructions.
- `andrea-ui-design`: component stack standard (shadcn/ui on Base UI, catalog check before hand-rolling, no default browser controls) and web app defaults (collapsible sidebar shell, light and dark mode, Italian and English i18n from the start).
- `references/data-tables.md`: concrete pagination defaults (50 rows per page, 25/50/100/All selector, visible total row count).

## [0.1.1] - 02 September 2026

### Added

- `install.sh`: idempotent setup of skills, instruction files, and the auto-sync hook on a new machine.

## [0.1.0] - 01 September 2026

### Added

- `AGENTS.md` bootstrap layer with progressive Skill loading, a simplicity-first default, and a rule keeping code-writing subagents on the session's model.
- `AGENTS.md` section on local servers in parallel workspaces: reuse running databases, prefer Conductor run scripts, and leave no polling tasks in the background.
- `andrea-ui-design` Skill: core UI workflow and reference routing.
- `references/data-tables.md` data-table standard.
- `VERSION` file and this changelog.

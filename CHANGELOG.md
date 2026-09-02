# Changelog

Notable changes to these standards. Versions follow [Semantic Versioning](https://semver.org/): patch for wording fixes, minor for new or expanded guidance, major for changes that reverse or remove earlier guidance.

## [0.2.0] - 2026-09-02

### Added

- `AGENTS.md`: human-readable date convention (`DD MMMM YYYY` in human-facing content, ISO 8601 for machine-readable data) and versioning/changelog requirements for every web app, migrated from the pre-repo global instructions.
- `andrea-ui-design`: component stack standard (shadcn/ui on Base UI, catalog check before hand-rolling, no default browser controls) and web app defaults (collapsible sidebar shell, light and dark mode, Italian and English i18n from the start).
- `references/data-tables.md`: concrete pagination defaults (50 rows per page, 25/50/100/All selector, visible total row count).

## [0.1.1] - 2026-09-02

### Added

- `install.sh`: idempotent setup of skills, instruction files, and the auto-sync hook on a new machine.

## [0.1.0] - 2026-09-01

### Added

- `AGENTS.md` bootstrap layer with progressive Skill loading, a simplicity-first default, and a rule keeping code-writing subagents on the session's model.
- `AGENTS.md` section on local servers in parallel workspaces: reuse running databases, prefer Conductor run scripts, and leave no polling tasks in the background.
- `andrea-ui-design` Skill: core UI workflow and reference routing.
- `references/data-tables.md` data-table standard.
- `VERSION` file and this changelog.

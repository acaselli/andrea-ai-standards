---
name: andrea-ui-design
description: Apply Andrea's opinionated UI and UX standards to web interfaces. Use when designing, implementing, or modifying frontend UI; structuring application information; or making decisions about tables, data grids, forms, dashboards, navigation, application states, responsive behavior, and interaction patterns.
---

# Andrea UI Design

## Core workflow

1. Understand the user's task, decisions, and constraints before choosing components. Inspect the available data and the existing interface, components, and conventions.
2. Establish information hierarchy first. Name and group information according to its meaning in the user's domain, not the shape or terminology of an API, database, or internal model.
3. Treat available fields as input, not as a display specification. Expose only information that helps the task; combine related raw fields when they form one user-facing concept.
4. Preserve deliberate project patterns and reuse established components when they serve the task. Do not redesign an interface merely to make it different. Follow explicit project instructions when they override this Skill.
5. Design the full interaction state model, including initial loading, empty, no-results, error, stale refresh, mutation, and success states as applicable. Decide which feedback must persist and which can be transient.
6. Set information priorities that remain coherent across viewport sizes; do not postpone responsive decisions until after the desktop layout is complete.

## Component stack

- Build every UI component with shadcn/ui (Base UI distribution) unless the design needs something shadcn genuinely does not offer yet.
- Before building or hand-rolling any component, check the shadcn components catalog (https://ui.shadcn.com/docs/components) for an existing one. Do not rely on memory of what shadcn provides — the catalog grows.
- Never ship default browser controls in human-facing UI: no native `<select>`, native date/color inputs, `alert()`/`confirm()`/`prompt()`, or unstyled file inputs.

## Web app defaults

- Use the shadcn collapsible sidebar layout as the app shell.
- Always implement both light and dark mode.
- Always ship with language support for Italian and English. Build i18n in from the start; do not hardcode user-facing strings.

## Reference routing

- For tabular data, data grids, table-like lists, table search/filter/sort behavior, pagination, row actions, or expandable rows, read [references/data-tables.md](references/data-tables.md) before designing, implementing, or reviewing that work.
- Load only references relevant to the current task. Do not read every file in `references/` by default or follow references beyond those linked directly from this file.

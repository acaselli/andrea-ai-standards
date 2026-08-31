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

## Reference routing

- For tabular data, data grids, table-like lists, table search/filter/sort behavior, pagination, row actions, or expandable rows, read [references/data-tables.md](references/data-tables.md) before designing, implementing, or reviewing that work.
- Load only references relevant to the current task. Do not read every file in `references/` by default or follow references beyond those linked directly from this file.

# Andrea AI Standards

Personal AI standards, skills, and reusable conventions for consistent software design, development, and review.

This repository contains the standards I use across projects when working with AI coding agents such as Codex, Claude Code, and Cursor.

The goal is not to teach agents generic software-development best practices. Modern models already know those. The goal is to provide my own opinionated conventions, preferences, and repeatable workflows so that different agents behave more consistently across different projects and machines.

## Principles

The standards in this repository should:

- be specific and opinionated
- encode recurring decisions and preferences
- avoid duplicating generic knowledge that AI models already understand
- load only when relevant to the current task
- remain portable across different AI coding agents
- allow project-specific instructions to override global defaults when necessary

## Structure

```text
andrea-ai-standards/
├── AGENTS.md
└── skills/
    └── andrea-ui-design/
        ├── SKILL.md
        └── references/
            └── data-tables.md
```

`AGENTS.md` contains a small set of global instructions.

Detailed standards live in reusable Skills and their reference files so that agents can load only the context relevant to the task they are performing.

## Skill naming

Personal skills use the `andrea-` prefix so they are easy to distinguish from built-in and third-party skills.

Examples:

```text
andrea-ui-design
andrea-ui-review
andrea-code-review
```

## Current focus

The first Skill in this repository is `andrea-ui-design`, which defines my preferred approach to designing and implementing web application interfaces.

The standards will grow gradually based on real development work and recurring decisions rather than trying to document every possible convention upfront.

# Andrea AI Standards

This repository is the portable, canonical source for my personal AI-agent standards, reusable skills, and development conventions. It is intended for use across Codex, Claude Code, Cursor, Conductor, and other agents that support compatible instruction and Skill formats.

These standards are intentionally opinionated. They encode recurring preferences that generic model knowledge does not capture, while allowing explicit project-specific instructions to override personal defaults.

## Architecture

`AGENTS.md` is a small, always-on bootstrap layer. Detailed guidance lives in reusable Agent Skills, with domain references loaded only when a task needs them:

```text
global agent instructions
        ↓
small AGENTS.md
        ↓
relevant Skill
        ↓
only the relevant reference file(s)
```

This progressive-loading model keeps unrelated standards out of an agent's context. Related concerns belong in a coherent domain Skill rather than a collection of overlapping micro-Skills.

## Structure

```text
andrea-ai-standards/
├── README.md
├── LICENSE
├── AGENTS.md
├── VERSION
├── CHANGELOG.md
└── skills/
    └── andrea-ui-design/
        ├── SKILL.md
        └── references/
            └── data-tables.md
```

Every personal Skill uses the `andrea-` prefix as part of its actual Skill name. The first is `andrea-ui-design`, which contains the shared UI control plane and routes table work to a detailed data-table standard.

The repository will grow from real usage and repeated preferences, not by accumulating generic best practices or speculative placeholder guidance.

## Versioning and updates

The current version lives in `VERSION` and changes are recorded in `CHANGELOG.md`, following Semantic Versioning: patch for wording fixes, minor for new or expanded guidance, major for changes that reverse or remove earlier guidance. Every change that alters guidance bumps the version and adds a changelog entry in the same commit.

Keeping the local clone current is the harness's job, not the model's. A `SessionStart` hook in `~/.claude/settings.json` and `~/.codex/hooks.json` runs `git pull --ff-only` on the clone at the start of every session and fails silently when offline or sandboxed. Updated standards apply from the next session.

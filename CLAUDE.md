# Working in this repository

This repository is the source of my personal AI-agent standards. `AGENTS.md` here is loaded as global instructions on every project, so keep it small, portable, and free of anything specific to maintaining this repo. Repo-maintenance rules live in this file instead.

- Every change that alters guidance — in `AGENTS.md`, a Skill, or a reference — bumps `VERSION` and adds a `CHANGELOG.md` entry in the same commit: patch for wording fixes, minor for new or expanded guidance, major for changes that reverse or remove earlier guidance.
- Date changelog entries as `DD MMMM YYYY` and place the new entry above the previous one.
- Keep a Skill's `description` as trigger conditions ("use when…"), not an explanation of what the Skill does; it is always in context even when the Skill is not loaded.

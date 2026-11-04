---
name: andrea-code-review-council
description: Use when Andrea asks for the council, a council review, or a review of the current work by Opus and Sol, or asks for another council round.
---

# Andrea Code Review Council

Each round, two fresh read-only reviewers from different providers review the current work in parallel. You — the session that wrote the code — weigh their findings, fix what is clearly in scope, and bring every disagreement and every change in functionality to Andrea, who decides.

Run the council from a Claude Code session. If you are another harness, tell Andrea and stop.

## Members

- **Claude Opus 5.5**: a new general-purpose subagent each round, not a fork (a fork inherits your context and is no longer fresh): `model: "opus"`, `effort: "high"`, run in the background. It runs at this session's speed: fast only if Andrea picked fast mode for the session, which is fine.
- **GPT Sol 6.1**: a new Codex run each round at high effort in fast mode, started with Bash in the background. Create `$DIR` first and write the command with `$DIR` and `N` filled in, because shell variables do not carry over between Bash calls:

  ```sh
  timeout -k 30 900 codex exec -s read-only --ephemeral --color never \
    -m gpt-6.1-sol -c model_reasoning_effort=high -c service_tier='"fast"' \
    -o "$DIR/round-N-sol.md" - < "$DIR/round-N-brief.md" > "$DIR/round-N-sol.log" 2>&1
  ```

  Always feed the prompt from a file or `/dev/null`: with an open stdin Codex waits for input forever. Sol completed only if the command exits with 0 and `round-N-sol.md` exists and is not empty; otherwise read the log. Retry once only after a timeout (exit code 124, or 137 when it had to be force-stopped), with its own 15 minutes, writing to `round-N-retry-sol.md` and `.log` so the first log is kept; otherwise tell Andrea.

Launch both in the same message so they run in parallel, together with a background `sleep 900` as the Opus deadline: nothing else wakes you if the subagent stalls. If the sleep ends before Opus does, stop Opus and treat the round as incomplete; when Opus finishes, stop the sleep, so a leftover timer never cuts into the next round or keeps the session looking busy.

Check who actually ran: the `model:` line in Sol's log must say `gpt-6.1-sol`, and the Opus reviewer must start its reply with `claude-opus-5-5`. Never substitute another model for a member that fails, stalls, or turns out to be a different model: tell Andrea and ask how to proceed.

Neither reviewer edits files. Just before launching them and again when both have finished, fingerprint the working tree from the repository root (gitignored files are not covered); if the two differ, a reviewer changed something, so tell Andrea before going on:

```sh
{ git diff HEAD --binary; git ls-files -o --exclude-standard -z | xargs -0 shasum; } | shasum
```

`$DIR` is `.context/council/` in Conductor (gitignored) or a temporary directory outside the repository elsewhere.

## Before round 1

Fix the issues you already know about and run the relevant checks, so reviewers see the real state of the work. Write down Andrea's original request in Andrea's words; every round carries it.

## Round brief

Write one brief per round to `$DIR/round-N-brief.md` and give the same text to both reviewers (the Opus subagent gets it inline as its prompt). It contains:

1. **The request**: Andrea's original request, verbatim.
2. **The changes**: how to see them — the base branch, `git diff $(git merge-base HEAD origin/<base>)` for committed and uncommitted changes, and `git status --short` for new files.
3. **Fixed since the last round** (round 2 onward): each fix and the finding it answers. Ask the reviewer to check that every fix is correct and broke nothing else.
4. **Already decided** (round 2 onward): Andrea's decisions, which are final, the minor findings you rejected, with your reasons, and the minor findings you agreed with but deferred, marked as such. Re-raise a rejected minor finding only with a new argument against that reasoning; do not re-raise deferred ones.
5. **The instructions below**, copied in full.

### Reviewer instructions

> You are one of two independent reviewers, not the council: do not load or run the andrea-code-review-council Skill and do not launch other agents. Start your reply with your exact model ID, if you know it. Review the current state of the whole change against the request. Stay read-only: do not edit, create, or delete files.
>
> Hold your ground. You are not here to agree with the author, with the other reviewer, or with the author's earlier rejections. If you believe something is wrong, say so plainly, and keep saying so while the reasoning against you is unconvincing.
>
> Stay within the request. Do not propose new features or rewrites the request did not ask for; if you think one matters, list it separately as a functionality change.
>
> For every finding give:
> - **Severity**: blocking (wrong, broken, or unsafe), should fix (a real problem that is not urgent), or minor (polish).
> - **Kind**: bug (the code does not do what the request asked), code quality (same behavior, better code), or functionality change (a user would see or be able to do something different from what was asked, improvements included). When unsure, call it a functionality change.
> - **Where**: file and line.
> - **What goes wrong**: a concrete scenario, and its effect on the user in plain words. Blocking and should-fix findings without a concrete scenario do not count.
> - **Suggested fix**: one or two sentences.
>
> End with a score out of 10 for the change as it stands and a one-line verdict.

## Weighing the findings

For each finding, decide one of:

- **Fix**: bugs and code-quality findings you agree with. Judge the fix you are about to apply, not the reviewer's label: if it changes what a user sees or can do beyond restoring the requested behavior, it is a functionality change. Fix minor ones only when they take a minute and stay within the request; list the rest in the summary.
- **Reject**: minor bug or code-quality findings you disagree with, with your reason. List them, and the minor findings you agreed with but deferred, in the summary and in the next brief under "Already decided".
- **Ask Andrea**: every blocking or should-fix finding you disagree with, and every functionality change, whoever proposes it and however small. Andrea settles them in the same round. Never apply a functionality change without Andrea's explicit yes.

Do not agree just because a reviewer said so: weigh each finding on its merits.

## Asking Andrea

When a round produces questions for Andrea, finish its fixes, then present them in your reply and end your turn; start the next round only after Andrea answers. Use a question tool only for a short, clear choice that needs no context. Present each point as:

- **What happens**: a real example, such as "a user saves the form with an empty due date and the page goes blank".
- **Effect on the user**, in simple words, with no internal names.
- **Each side's position**, a sentence or two each.
- **Your recommendation**, labelled as such.

## Stopping

Run another round when fixes for blocking or should-fix findings were made, so reviewers check them; minor fixes alone do not need a round and are listed in the summary as unreviewed. When only Andrea's decisions are left, pause for them, then review any fixes they lead to. Pause early and ask Andrea if the same problems keep coming back or fixes keep breaking earlier fixes. After round 5, present what is still open in the format above and which fixes no reviewer has checked yet, recommend a next step, and let Andrea choose: continue, change approach, or accept the rest as it is. From then on, ask Andrea again after every round whether to run another.

## Reporting

When the work has a pull request, edit its description (do not post a comment) to add a "Council review" section just before the model and harness line:

| Round | Opus 5.5 | Sol 6.1 |
| --- | --- | --- |
| 1 | 6/10 | 7/10 |
| 2 | 8/10 | no score |

Below the table, list Andrea's decisions and anything still open, one line each. Without a pull request, put the same content in your final reply.

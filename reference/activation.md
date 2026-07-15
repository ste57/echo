# The activation block

Written into a project's `CLAUDE.md` at setup so Echo boots for the whole team — not just teammates who installed the skill.

## Why `CLAUDE.md`

The reflexes hooks and committed wiring only reach someone who *already* installed Echo — a hook pointed at a missing skill path fails open and does nothing. `CLAUDE.md` is different: Claude Code auto-loads it for **every** session and **every** user, with no skill install and no hook-consent prompt. So this block is the one lever a repo has to boot Echo for everyone. It's a *pointer that boots Echo*, never memory — the "no memory in `CLAUDE.md`" rule still holds.

## The block

Write this into the project's root `CLAUDE.md` (create it if absent; if it exists, insert near the top). Keep the `echo:begin`/`echo:end` markers so re-running setup replaces it in place instead of duplicating, and uninstall removes exactly it:

```markdown
<!-- echo:begin — managed by Echo, a pointer to memory, not memory itself -->
## Before ANY task here: read `.echo/` — this project's real conventions live there, not in the code

This project runs on Echo. Its actual stack, deploy steps, and gotchas are in
`.echo/`, and they are **not what you'd guess** — the deploy branch, the package
manager, and other defaults here are probably different from what you'd assume,
and the code alone will mislead you. So before you start, read `.echo/project.md`
and any relevant `.echo/intel/` notes (plain markdown, no tools needed) and let
them override your defaults.

If the `echo` skill is installed, run `/echo` and it loads them for you. If not,
install it — `Install https://github.com/ste57/echo as a skill` — or just read
`.echo/` directly for now. Don't store project memory in this file; it lives in
`.echo/`.
<!-- echo:end -->
```

## What it does and doesn't do

Boots Echo for anyone with the skill (no per-project hook wiring needed); for anyone without it, instructs the install *and* points them at `.echo/` — plain markdown any agent reads unaided, so memory still reaches them. What it **cannot** do is install the skill onto a teammate's machine — nothing committed to a repo can. It's the strongest reach a project has, not a guarantee. To back Echo out, remove the block (and the reflexes hooks, if wired); the `.echo/` memory is untouched.

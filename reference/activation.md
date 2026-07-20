# The activation block

Written into a project's `CLAUDE.md` **and `AGENTS.md`** at setup so Echo boots for the whole team on whatever agent they run — not just teammates who installed the skill.

## Why `CLAUDE.md` and `AGENTS.md`

The reflexes hooks and committed wiring only reach someone who *already* installed Echo — a hook pointed at a missing skill path fails open and does nothing. Auto-loaded context files are different: Claude Code auto-loads `CLAUDE.md`, and Codex (plus other agents following the `AGENTS.md` convention) auto-loads `AGENTS.md` — for **every** session and **every** user, with no skill install and no hook-consent prompt. So this block is the one lever a repo has to boot Echo for everyone, regardless of their agent. It's a *pointer that boots Echo*, never memory — the "no memory in the boot file" rule still holds.

The block is identical in both files and agent-agnostic on purpose: it names the `/echo` skill as the *fast path* but always falls back to "just read `.echo/` directly — plain markdown, no tools needed," which is exactly the path a Codex or skill-less session takes. One managed block, two homes.

## The block

Write this identical block into **both** the project's root `CLAUDE.md` (Claude Code) and `AGENTS.md` (Codex and other `AGENTS.md`-convention agents) — create each if absent; if it exists, insert near the top without disturbing the file's other content. Keep the `echo:begin`/`echo:end` markers so re-running setup replaces the block in place instead of duplicating, and uninstall removes exactly it. (Prefer two real files over a symlink: each agent may keep its own instructions around the managed block, and the markers make a shared island safe.)

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

**It reaches everyone; it compels most, not all.** The boot file loads for every agent, but a pointer only *teaches* — it can't force an agent disposed to skim scaffolding or trust its own defaults, and no wording closes that gap entirely. That's the same "teaches, doesn't enforce" ceiling the skill runs on. Where you need enforcement rather than a strong nudge, the reflexes pack's session-start hook is the sharper layer — but the skill and the reflexes pack are Claude Code-only, so on Codex the activation block *is* the whole binding: the block points at `.echo/`, and reading and capturing happen by hand. The markdown memory is identical; only the automation degrades.

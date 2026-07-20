# The activation block

Written into a project's `CLAUDE.md` **and `AGENTS.md`** at setup so Echo boots for the whole team on whatever agent they run — not just teammates who installed the skill.

## Why `CLAUDE.md` and `AGENTS.md`

The reflexes hooks and committed wiring only reach someone who *already* installed Echo — a hook pointed at a missing skill path fails open and does nothing. Auto-loaded context files are different: Claude Code auto-loads `CLAUDE.md`, and Codex (plus other agents following the `AGENTS.md` convention) auto-loads `AGENTS.md` — for **every** session and **every** user, with no skill install and no hook-consent prompt. So this block is the one lever a repo has to boot Echo for everyone, regardless of their agent. It's a *pointer that boots Echo*, never memory — the "no memory in the boot file" rule still holds.

The block is identical in both files and agent-agnostic on purpose: it makes **reading `.echo/` directly the requirement** — plain markdown, no tools needed, the path a Codex or skill-less session takes anyway — and demotes `/echo` to an *accelerant* that does the same reading faster. That ordering is deliberate: orientation that depends on the model taking an action (invoking the skill) has an extra point where it can be skipped, so the block leans on the lower-friction passive read and treats the skill as a convenience on top. One managed block, two homes.

## The block

Write this identical block into **both** the project's root `CLAUDE.md` (Claude Code) and `AGENTS.md` (Codex and other `AGENTS.md`-convention agents) — create each if absent; if it exists, insert near the top without disturbing the file's other content. Keep the `echo:begin`/`echo:end` markers so re-running setup replaces the block in place instead of duplicating, and uninstall removes exactly it. (Prefer two real files over a symlink: each agent may keep its own instructions around the managed block, and the markers make a shared island safe.)

```markdown
<!-- echo:begin — managed by Echo, a pointer to memory, not memory itself -->
## Before your first action here: read `.echo/` — the real conventions live there, not in the code

Read `.echo/project.md` and any relevant `.echo/intel/` notes now, before you touch
anything — plain markdown, no tools needed. This project's stack, deploy branch, and
gotchas are **not what you'd guess**; the code alone will mislead you and your own
defaults are probably wrong here, so let `.echo/` override them. Do this **even when
the task looks narrow, quick, or read-only** — a self-contained-looking question is
exactly when skipping orientation burns you. The read is cheap; being wrong isn't.

If the `echo` skill is installed, `/echo` loads all of this for you — but it's an
accelerant, not the gate. Reading `.echo/` is the real requirement and works on any
agent; install the skill later (`Install https://github.com/ste57/echo as a skill`)
if you want it automatic. Don't store project memory in this file — it lives in `.echo/`.
<!-- echo:end -->
```

## What it does and doesn't do

Tells **every** agent — skill or not, Claude or Codex — to read `.echo/` directly (plain markdown, read unaided), so memory reaches everyone with no per-project hook wiring; `/echo` rides on top as an accelerant for those who have the skill, and the block also carries an install pointer for those who don't. What it **cannot** do is install the skill onto a teammate's machine — nothing committed to a repo can. It's the strongest reach a project has, not a guarantee. To back Echo out, remove the block (and the reflexes hooks, if wired); the `.echo/` memory is untouched.

**It reaches everyone; it compels most, not all.** The boot file loads for every agent, but a pointer only *teaches* — it can't force an agent disposed to skim scaffolding or trust its own defaults, and no wording closes that gap entirely. The wording targets the most common override — the model judging a narrow-looking task not worth orienting for — by naming that rationalization outright, but naming it is still teaching, not enforcing. That's the same "teaches, doesn't enforce" ceiling the skill runs on. Where you need enforcement rather than a strong nudge, the reflexes pack's session-start hook is the sharper layer — but the skill and the reflexes pack are Claude Code-only, so on Codex the activation block *is* the whole binding: the block points at `.echo/`, and reading and capturing happen by hand. The markdown memory is identical; only the automation degrades.

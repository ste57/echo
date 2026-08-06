---
when: writing or repairing the activation block in CLAUDE.md or AGENTS.md
---
The activation block is a fenced pointer written into a project's root `CLAUDE.md` **and**
`AGENTS.md` at setup — the one lever that boots Echo for *every* session on *any* agent, because
those files auto-load with no skill and no hooks (`CLAUDE.md` for Claude Code, `AGENTS.md` for the
`AGENTS.md`-convention agents). It's identical in both files, and the `echo:begin`/`echo:end`
markers make it replaceable in place: re-running setup swaps exactly the block, nothing else.
It's a pointer that boots Echo, never memory — no facts, no learning ever land in it.

Write this block verbatim into both files (create each if absent; if a file exists, insert near
the top without disturbing its other content):

```markdown
<!-- echo:begin — managed by Echo, a pointer to memory, not memory itself -->
## Before your first action here: read `.echo/` — the real context lives there, not in the files

Read `.echo/project.md` and any relevant `.echo/intel/` notes now, before you touch
anything — plain markdown, no tools needed. This project's conventions and gotchas are
**not what you'd guess**; your own defaults are probably wrong here, so let `.echo/`
override them. Do this **even when the task looks narrow, quick, read-only, or unrelated
to the project's main work** — you can't tell whether the memory is relevant without
reading it first. The read is cheap; being wrong isn't.

This project **embeds its own Echo**: the full skill lives at `.claude/skills/echo/SKILL.md`,
committed and versioned with the project. Read that file for the complete protocol — it, not
any personally installed `/echo` skill, is the copy this project runs (the skill name is
turned off here via `skillOverrides`, on purpose). It's plain markdown and works on any
agent; updates arrive with a normal pull. Don't store memory in this file — it lives in `.echo/`.
<!-- echo:end -->
```

**It reaches everyone; it compels most, not all.** A pointer teaches — it can't force an agent
disposed to skim scaffolding, and no wording closes that gap entirely. The wording names the two
common overrides (a task judged too narrow, or too unrelated, to orient for) and why both fail.
Where enforcement matters, the reflexes hooks are the sharper layer (`core/reflexes.md`); on
agents without hooks, this block is the whole binding.

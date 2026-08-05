---
when: the user wants Echo in a project that has no .echo/ yet, wants the skill embedded in a project, is migrating from squad, or asks about or wants the reflexes pack
---
**Echo installs into the project, not the person.** The skill is committed into the project at `.claude/skills/echo/`, so every session — anyone's, on any machine — runs the same copy, and updates arrive with the project itself (a pull is an upgrade). A personal install (`~/.claude/skills/echo`) is just the bootstrap: it's how you're running setup in a project that doesn't have Echo yet, and it stays useful for personal, single-user trees.

Setting up:

1. **Ask first**, then create `.echo/project.md`, `.echo/profiles/`, `.echo/intel/`, `.echo/playbooks/`.
2. Seed `project.md` from what you can see (README, structure, purpose) — draft it, let the user correct it. Scan for and strip anything secret-shaped before writing.
3. Create their profile in `.echo/profiles/` — a friendly filename with an `email:` front-matter key for matching (format in `reference/format.md`).
4. **Embed the skill**: copy the skill's own files — `SKILL.md`, `base/`, `reference/`, `hooks/` — into `.claude/skills/echo/` in the project, and add `"skillOverrides": {"echo": "off"}` to the project's `.claude/settings.json`. The override matters: skill names resolve personal-over-project, so without it a stale personal install silently shadows the embedded copy. The embedded copy is loaded by file path (the activation block and hooks point at it), which nothing can shadow.
5. **Write the activation block into `CLAUDE.md` *and* `AGENTS.md`** — copy it verbatim from `reference/activation.md`; it tells every session, on any agent, to read the embedded skill and `.echo/` directly. It's the one time Echo touches these files, and it's a pointer, never memory.
6. Offer the **reflexes pack** (below).
7. Commit all of it — `.echo/`, `.claude/`, and the `CLAUDE.md`/`AGENTS.md` changes — so everyone shares it (per-person profile files don't collide). Only the global `~/.echo/profile.md` stays out of the repo. (No git? Skip — single-user mode, below.)

The global `~/.echo/profile.md` isn't part of project setup — it's per-machine, created lazily the first time a preference is promoted to global. **Echo assumes git in v1** (identity from `git config user.email`, sharing via commit) — any git host or a purely local repo; nothing assumes GitHub or a specific forge. With no git at all it still works as single-user local memory — one profile, no sharing. Migrating a **squad** setup (`.squad/` — Echo's predecessor): no importer — offer to port still-true facts into `.echo/` by hand, never silently.

**Optional reflexes pack:** Echo works as-is but leans on you to remember to sync, resolve, and learn; the pack is the sharper, opt-in layer (Claude Code-only — elsewhere the activation block is the whole binding). Small POSIX-shell hooks re-invoke Echo at session start and after compaction, **deny access to the runtime's built-in memory store** (the one hard gate), and cue the Learn pass on an explicit "remember…" / "echo: …" and before each commit or push. They stay dumb: static nudges, no parsing of notes. Wire per `reference/reflexes.md`, pointing the settings entries at the **embedded** hooks (`$CLAUDE_PROJECT_DIR/.claude/skills/echo/hooks/`) so the hooks version with the project. They run code, so **always ask before wiring**; everything is fail-open, and anyone who pulls the committed wiring gets their own one-time consent prompt.

**Updating an embedded Echo:** sync `.claude/skills/echo/` from the Echo repo in a normal commit or PR — everyone gets it on pull. Keep vendored files byte-identical to upstream (a change Echo needs goes upstream and syncs back down); a scheduled CI job can automate the sync PR, and the review gate is worth keeping since hook changes re-prompt consent.

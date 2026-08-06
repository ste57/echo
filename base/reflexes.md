---
when: wiring or repairing the reflexes hooks, a hook misfires, or you need exactly what they do
---
# Echo reflexes — the hooks

The skill (SKILL.md) is the brain: invoked, it reads your `.echo/` memory and runs Learn by
judgment. That delivers Echo's value but leans on the model *remembering* to do it — research calls
the failure "memory blindness": the memory exists but never loads. The reflexes pack closes that gap
with four **tiny shell hooks** — no Python, no interpreter to install, just POSIX `/bin/sh`.

The hooks stay deliberately dumb. They never parse your notes or inject file contents — each emits a
short, **static** instruction that nudges the re-invoked `/echo` skill at the right moment. All the
reading, matching, and judging is the skill's job; the hooks only guarantee the one thing prose can't.

**One source of truth.** The scripts live in the embedded skill — `.claude/skills/echo/hooks/*.sh`,
committed with the project — and settings carry only entries pointing at them via
`$CLAUDE_PROJECT_DIR`. Syncing the embedded copy updates the hooks for everyone at once; nothing
else holds a copy, so nothing can drift. A checkout without the embedded skill fails open — the
entry runs nothing and does nothing.

- **session-start** → tells the model to invoke `/echo` and read `.echo/` memory, so every session
  (and every post-compaction continuation) starts oriented. On a plain resume it only confirms Echo
  is still active — the context already loaded is still there, so no re-invoke. In a repo that
  *embeds* the skill (a committed `.claude/skills/echo/`), it points the session at that copy by
  file path instead of the `/echo` name — a personal install can shadow a skill name, but it can't
  shadow a file read.
- **memory-guard** → the one **hard gate**, two denies: (a) any access (read or write — it's wired
  to all tools) to the runtime's built-in memory store (`~/.claude/projects/…/memory/`) — Echo owns
  memory; the store is stale and invisible to the team; (b) a **subagent** writing into `.echo/` —
  a subagent never read the skill, so its captures skip every Learn gate (proven in the field by
  front-matter-less notes); it reports findings back and the main agent captures. Reads stay
  allowed. It's the only hard-gate hook the pack ships.
- **pre-commit** → on a git commit/push, asks whether a playbook governs the work in flight, points
  the model at git-area intel, and cues the Learn pass. A commit is a real "natural stop" with a
  model turn after it — the dependable capture checkpoint.
- **user-prompt** → when you say "remember…" or address Echo directly ("echo: …" / "echo, …" — the
  punctuation is required, so a prompt about the `echo` shell command doesn't false-fire), cues the
  Learn pass immediately. The reliable path for an explicit teach.

**Honest limit:** no hook can flush *inferred* learnings right before an auto-compaction (the model
doesn't run between the trigger and the summary). So the dependable capture moments are explicit
teaches (user-prompt) and commits (pre-commit); a long, commit-less session that auto-compacts can
still drop an un-prompted inferred note. That's a real limit, not papered over.

The hooks are a **standard component of embedding** (`base/setup.md`), and consent is structural
rather than ceremonial: each person's runtime shows its own one-time approval prompt for the
project's hooks, and declining leaves them inert for that person. The scripts read nothing but the
hook payload, and everything is **fail-open** — any hook error does nothing; only the
memory-guard's deliberate deny ever blocks.

---

## Wiring procedure (a standard step of embedding — `base/setup.md`)

1. Wire the four hooks into settings (see **Wiring**), **idempotently**: read the existing `hooks`
   block and *append* Echo's entries into each event's array; skip any whose command already
   contains `skills/echo/hooks/` (so re-install doesn't double-register). Never overwrite a user's
   hooks. Also add `permissions.allow: ["Skill(echo)", "Write(.echo/**)", "Edit(.echo/**)",
   "Write(~/.echo/**)", "Edit(~/.echo/**)"]` — the skill rule so session-start re-invocation isn't
   permission-gated, the write rules so a quiet Learn save doesn't stop at a permission prompt
   (a "quiet save" that prompts isn't quiet).
   Default to `.claude/settings.json` (committed) — teammates with Echo installed get working hooks,
   teammates without get inert fail-open entries; only if the user wants the wiring private, use
   `.claude/settings.local.json`.
2. Tell the user what was wired and that it takes effect from the **next** session — assume nothing
   changes in the current one. Everyone who pulls the committed wiring gets the runtime's own
   one-time consent prompt on their first session.

**Upgrading:** the hooks ride the embedded copy — syncing `.claude/skills/echo/` updates them
(`base/setup.md`); there is nothing separate to do.

**No interpreter dependency.** The hooks are POSIX `sh`, present on every macOS/Linux machine.
Windows without a POSIX shell isn't supported in v1 — Echo still works as a pure skill, just without
reflexes.

**If something is wrong:** the only hook that can block is the memory-guard, and only on its two
denies — access to the built-in memory store, or a subagent's write into `.echo/`. To disable any
hook, remove its entry from settings; the memory stays.

---

## The scripts — `hooks/` in the skill

The four bodies live at `hooks/session_start.sh`, `hooks/memory_guard.sh`, `hooks/pre_commit.sh`,
`hooks/user_prompt.sh` in the skill directory — the single copy every project runs. Read them there;
this document describes behavior and never restates bodies (a restated script is a second source of
truth waiting to drift). Behavioral notes that matter:

- **session-start** fires on every session start including the post-compaction continuation
  (`source: compact`); a plain `resume` (context still present) only confirms Echo is active. It
  instructs the model to read the profiles, `project.md`, the intel-area listing, and each
  playbook's `when:` trigger phrase — you can't recognize a trigger you've never seen.
- **memory-guard** matches textually (no symlink/`..` resolution), normalizes `\/` and newlines,
  and matches case-insensitively, anchored to the real store layout — so it isn't fooled by
  formatting, and won't deny a legitimate project file under some *other* `.claude/…/memory/`-like
  path. Subagent context is identified by the `transcript_path` *field* living under
  `…/subagents/`; the subagent deny fires only for write tools (Write/Edit/MultiEdit/NotebookEdit)
  into `.echo/`. It does **not** touch `CLAUDE.md`/`AGENTS.md` or scratch files (legit files; prose covers
  those), and it can't see access smuggled through raw `Bash` — rare; the harness uses the file
  tools. Fail-open: anything it can't clearly identify is allowed.
- **pre-commit** scopes its match to the `command` value with word boundaries (neither "legit push"
  nor "gitcommit" match) and emits a static checklist: playbook first, git intel second, Learn pass
  third; a subagent is told to report findings back instead of writing `.echo/`.
- **user-prompt** matches a teach verb ("remember", "note that", "don't forget", "for the record")
  or a direct address (`echo:` / `echo,`) near the start of the prompt, with word boundaries
  ("remembering" and `echo $PATH` stay silent). Playbook-trigger matching is left to the skill.

---

## Wiring — settings.json

Append into the project's `.claude/settings.json` (committed). The
`Skill(echo)` permission lets the session-start re-invocation run without a prompt; the
`Write`/`Edit` rules keep quiet Learn saves from prompting.

```json
{
  "permissions": { "allow": ["Skill(echo)", "Write(.echo/**)", "Edit(.echo/**)", "Write(~/.echo/**)", "Edit(~/.echo/**)"] },
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.claude/skills/echo/hooks/session_start.sh\"" } ] }
    ],
    "UserPromptSubmit": [
      { "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.claude/skills/echo/hooks/user_prompt.sh\"" } ] }
    ],
    "PreToolUse": [
      { "matcher": ".*", "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.claude/skills/echo/hooks/memory_guard.sh\"" } ] },
      { "matcher": "Bash", "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.claude/skills/echo/hooks/pre_commit.sh\"" } ] }
    ]
  }
}
```

Append into each event's existing array; don't replace it. Skip any entry whose command already
contains `skills/echo/hooks/` (idempotent re-wiring). For a personal bootstrap install with no
embed, point the commands at `$HOME/.claude/skills/echo/hooks/` instead.

Do **not** wire `session_start.sh` under **PostCompact**: its stdout never reaches the model there
— in current Claude Code it surfaces to the *user* as a raw status line after every compaction,
noise with no effect. `SessionStart` already fires with `source: compact` after a compaction, so
the wiring above covers re-orientation on its own; remove any legacy PostCompact entry.

---

## Notes for the model

- **Cue ≠ obey, inject ≠ enforce.** Every hook here only puts a short instruction in front of you; it
  doesn't act. The skill does the work. The single exception is **memory-guard**, which actually
  denies — the one thing Echo enforces rather than asks.
- **Static by design.** The hooks read only the hook payload (via `grep`), never your notes — so
  adding intel, a playbook, or a profile line needs no reinstall and no code change.
- **Hard gates in v1 = the memory-guard, and nothing else.** A genuine "this must never ship" rule
  beyond memory ownership isn't enforced by the pack — capture it as strong intel (the note teaches
  it). A new hard gate is a deliberate future addition, kept rare on purpose: every gate is weight;
  priors are the default.
- **Fail-open.** Any hook error → no output → no effect. A broken hook never blocks your editor; only
  the memory-guard's deny does.
- **Subagents.** PreToolUse hooks fire for a spawned agent's tool calls too: the memory-guard covers
  them, and the commit cue tells a subagent to report findings back rather than write `.echo/`
  itself (a subagent never read the skill, so its captures skip every gate — proven in the field by
  a front-matter-less note). What hooks can't do is give a subagent your memory — see `base/delegation.md` for that.
- **`CLAUDE_PROJECT_DIR`** locates the project at runtime; the scripts fall back to `$PWD`. Nested
  checkouts with more than one `.echo/` aren't supported — assume the repo root.

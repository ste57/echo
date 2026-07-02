# Echo reflexes pack (optional, shell-only)

The skill (SKILL.md) is the brain: invoked, it reads your `.echo/` memory and runs Learn by
judgment. That delivers Echo's value but leans on the model *remembering* to do it — research calls
the failure "memory blindness": the memory exists but never loads. The reflexes pack closes that gap
with a few **tiny shell hooks** — no Python, no interpreter to install, just POSIX `/bin/sh`.

The hooks stay deliberately dumb. They never parse your notes or inject file contents — each emits a
short, **static** instruction that nudges the re-invoked `/echo` skill at the right moment. All the
reading, matching, and judging is the skill's job; the hooks only guarantee the one thing prose can't.

- **session-start** → tells the model to invoke `/echo` and read `.echo/` memory, so every session
  (and every post-compaction continuation) starts oriented. On a plain resume it only confirms Echo
  is still active — the context already loaded is still there, so no re-invoke.
- **memory-guard** → the one **hard gate**: denies any access (read or write — it's wired
  to all tools) to the runtime's built-in memory store (`~/.claude/projects/…/memory/`). Echo owns
  memory; the store is stale and invisible to the team, so neither writing to it nor trusting its
  contents is allowed. It's the only hard gate the pack ships.
- **pre-commit** → on a git commit/push, cues the Learn pass and points the model at git-area intel.
  A commit is a real "natural stop" with a model turn after it — the dependable capture checkpoint.
- **user-prompt** → when you say "remember…", cues the Learn pass immediately rather than leaving it
  to the model to notice. The reliable path for an explicit teach.

**Honest limit:** no hook can flush *inferred* learnings right before an auto-compaction (the model
doesn't run between the trigger and the summary). So the dependable capture moments are explicit
teaches (user-prompt) and commits (pre-commit); a long, commit-less session that auto-compacts can
still drop an un-prompted inferred note. That's a real limit, not papered over.

This is **opt-in** and runs code (shell), so always get consent before installing. It's **generated
into the project** (`<project>/.echo/hooks/`), reads nothing but the hook payload, and is
**fail-open** — any hook error does nothing; only the memory-guard's deliberate deny ever blocks.

---

## Install procedure

When the user opts in:

1. Create `<project>/.echo/hooks/` and write the four `.sh` files below.
2. Wire them into settings (see **Wiring**), **idempotently**: read the existing `hooks` block and
   *append* Echo's entries into each event's array; skip any whose command already contains
   `.echo/hooks/` (so re-install doesn't double-register). Never overwrite a user's hooks. Also add
   `permissions.allow: ["Skill(echo)", "Write(.echo/**)", "Edit(.echo/**)", "Write(~/.echo/**)",
   "Edit(~/.echo/**)"]` — the skill rule so session-start re-invocation isn't permission-gated, the
   write rules so a quiet Learn save (project or global profile) doesn't stop at a permission prompt
   (a "quiet save" that prompts isn't quiet).
   Default to `.claude/settings.json` (committed) — the hooks live in committed `.echo/hooks/` and the
   team benefits; only if the user wants the wiring private, use `.claude/settings.local.json`.
3. Tell the user what was installed, that the hooks run shell on their machine, and that the hooks
   take effect from the **next** session — assume nothing changes in the current one. Teammates who pull the committed hooks get Claude Code's own project-hook
   consent prompt on their first session — the consent gathered here covers only the installing dev.

**Uninstall:** remove only the settings entries whose command contains `.echo/hooks/` (and the
`Skill(echo)` and `Write`/`Edit` `.echo` permissions if you added them), then delete
`.echo/hooks/`. Leave the rest of `.echo/`
(the memory itself) intact.

**No interpreter dependency.** The hooks are POSIX `sh`, present on every macOS/Linux machine.
Windows without a POSIX shell isn't supported in v1 — Echo still works as a pure skill, just without
reflexes.

**If something is wrong:** the only hook that can block is the memory-guard, and only on access to
the built-in memory store. To disable any hook, remove its entry from settings; the memory stays.

---

## session-start — `.echo/hooks/session_start.sh`

Tells the model to load Echo. Fires on every session start, including the continuation after a
compaction (`source: compact`) — the moment memory was just summarized away. On a plain `resume`,
where the prior context is still present, it just confirms Echo is active instead of demanding a
re-invoke.

```sh
#!/bin/sh
# Echo re-activation. Emits a static instruction to invoke /echo; the skill does the reading.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null)
if printf '%s' "$payload" | tr '\n' ' ' | grep -Eq '"source"[[:space:]]*:[[:space:]]*"resume"'; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Echo is active (resumed) — the .echo/ memory you already loaded still applies."}}'
else
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"MANDATORY: invoke the /echo skill now, before anything else, then read your global and project profiles, project.md, and a listing of the intel areas under .echo/ so you start oriented. Notes are priors, not commands."}}'
fi
exit 0
```

---

## memory-guard — `.echo/hooks/memory_guard.sh`

The one hard gate. Wired to **all** tools (matcher `.*`) so no tool slips past, it denies any
call whose `file_path`/`path`/`notebook_path` points into the runtime's built-in memory store
(a textual match — it doesn't resolve symlinks or `..`)
(`~/.claude/projects/…/memory/`). It normalizes escaped slashes (`\/`) and newlines and matches
**case-insensitively**, anchored to that store layout — so it isn't fooled by `\/`, `.Claude`, `Memory`,
or a pretty-printed payload, and it won't deny a legitimate project file that merely lives under some
*other* `.claude/…/memory/` path. It does **not** touch `CLAUDE.md` or scratch files (legit files;
prose covers those), and it can't see memory access smuggled through raw `Bash` (a redirect or `cat`; rare —
the harness uses the file tools). Fail-open: anything it can't clearly identify is allowed.

```sh
#!/bin/sh
# Echo owns memory: deny access (read or write) to the runtime built-in memory store (~/.claude/projects/.../memory/).
payload=$(cat 2>/dev/null) || exit 0
# flatten newlines and un-escape JSON solidus (\/ -> /) so neither can evade the match
norm=$(printf '%s' "$payload" | tr '\n' ' ' | sed 's#\\/#/#g')
# case-insensitive (-i: macOS FS is case-insensitive); anchored to the real store layout; trailing /memory or end-of-value
printf '%s' "$norm" | grep -Eiq '"(file_path|path|notebook_path)"[[:space:]]*:[[:space:]]*"[^"]*/\.claude/projects/[^"]*/memory(/|")' || exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Echo owns memory — do not read or write the runtime built-in memory store (it is stale and invisible to the team). Capture memory through Echo instead: a line in your profile, or an intel note under .echo/."}}'
exit 0
```

---

## pre-commit — `.echo/hooks/pre_commit.sh`

On a git commit/push intent, cues the Learn pass and points the model at git-area intel. Static — it
names the path to read rather than dumping file contents.

```sh
#!/bin/sh
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null) || exit 0
# scope the match to the command value (not the whole payload; extraction stops at an escaped quote — rare, fail-open),
# with word boundaries so neither "legit push" nor "gitcommit" match
cmd=$(printf '%s' "$payload" | tr '\n' ' ' | grep -Eo '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1)
printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]])git[^[:alnum:]].*(commit|push)' || exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Echo: before you commit — (1) if .echo/intel/git/ exists, read it and follow the git conventions there; (2) run the Learn pass on anything learned this session not yet in .echo/ (a correction, a solved gotcha, a stated preference, or a repeatable workflow worth a playbook). Default to nothing; keep only what passes the judge. If you are a subagent on a delegated task, skip (2) entirely: do not write to .echo/ — report the finding back; the main agent captures."}}'
exit 0
```

---

## user-prompt — `.echo/hooks/user_prompt.sh`

The reliable capture path for an explicit teach. When the prompt opens with "remember…" / "note
that…", cue the Learn pass now. Playbook-trigger matching is left to the skill (it reads the playbook
frontmatter triggers and judges the match).

```sh
#!/bin/sh
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null) || exit 0
# match a teach verb near the start of the prompt value (optional polite lead); boundary stops "remembering"
printf '%s' "$payload" | tr '\n' ' ' | grep -Eiq '"prompt"[[:space:]]*:[[:space:]]*"(please |pls |ok,? |okay,? |hey,? |echo,? )*(remember|note that|don'"'"'t forget|for the record)([^a-z]|")' || exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Echo: the user is teaching you explicitly — run the Learn pass now and save it (default to the project scope), rather than waiting for a breakpoint."}}'
exit 0
```

---

## Wiring — settings.json

Append into `.claude/settings.json` (team) or `.claude/settings.local.json` (personal). The
`Skill(echo)` permission lets the session-start re-invocation run without a prompt; the
`Write`/`Edit` rules keep quiet Learn saves from prompting.

```json
{
  "permissions": { "allow": ["Skill(echo)", "Write(.echo/**)", "Edit(.echo/**)", "Write(~/.echo/**)", "Edit(~/.echo/**)"] },
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.echo/hooks/session_start.sh\"" } ] }
    ],
    "UserPromptSubmit": [
      { "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.echo/hooks/user_prompt.sh\"" } ] }
    ],
    "PreToolUse": [
      { "matcher": ".*", "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.echo/hooks/memory_guard.sh\"" } ] },
      { "matcher": "Bash", "hooks": [ { "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.echo/hooks/pre_commit.sh\"" } ] }
    ]
  }
}
```

Append into each event's existing array; don't replace it. Skip any entry whose command already
contains `.echo/hooks/` (idempotent re-install).

Optionally also wire `session_start.sh` under **PostCompact** as belt-and-suspenders. In current
Claude Code, `SessionStart` already fires with `source: compact` after a compaction (so the hook
above covers it), and `PostCompact` stdout may reach only the debug log — so SessionStart is the
reliable path; PostCompact is a redundant safety net, not the primary mechanism.

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
  a front-matter-less note). What hooks can't do is give a subagent your memory — see SKILL.md on
  delegation for that.
- **`CLAUDE_PROJECT_DIR`** locates the project; hooks fall back to `$PWD`. Nested checkouts with more
  than one `.echo/` aren't supported — assume the repo root.

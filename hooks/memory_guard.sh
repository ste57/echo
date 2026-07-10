#!/bin/sh
# Echo owns memory: deny access (read or write) to the runtime built-in memory store (~/.claude/projects/.../memory/).
payload=$(cat 2>/dev/null) || exit 0
# flatten newlines and un-escape JSON solidus (\/ -> /) so neither can evade the match
norm=$(printf '%s' "$payload" | tr '\n' ' ' | sed 's#\\/#/#g')
# Subagent WRITES to .echo/ skip every Learn gate (they never read the skill) — deny them; reads stay allowed.
# Subagent context = the transcript_path FIELD living under .../subagents/; fail-open if absent.
tp=$(printf '%s' "$norm" | grep -Eo '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1)
if printf '%s' "$tp" | grep -q '/subagents/'; then
  if printf '%s' "$norm" | grep -Eq '"tool_name"[[:space:]]*:[[:space:]]*"(Write|Edit|MultiEdit|NotebookEdit)"' &&
     printf '%s' "$norm" | grep -Eiq '"(file_path|path|notebook_path)"[[:space:]]*:[[:space:]]*"[^"]*\.echo/'; then
    printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Echo memory is written by the main agent only — report this finding back in your final message instead; the main agent runs the Learn gates and captures what passes."}}'
    exit 0
  fi
fi
# case-insensitive (-i: macOS FS is case-insensitive); anchored to the real store layout; trailing /memory or end-of-value
printf '%s' "$norm" | grep -Eiq '"(file_path|path|notebook_path)"[[:space:]]*:[[:space:]]*"[^"]*/\.claude/projects/[^"]*/memory(/|")' || exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Echo owns memory — do not read or write the runtime built-in memory store (it is stale and invisible to the team). Capture memory through Echo instead: a line in your profile, or an intel note under .echo/."}}'
exit 0

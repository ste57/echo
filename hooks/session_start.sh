#!/bin/sh
LC_ALL=C; export LC_ALL   # byte semantics: BSD tr/sed/grep abort on invalid UTF-8 in a payload
# Echo re-activation. Emits a static instruction to load Echo; the skill does the reading.
# A repo with an embedded skill copy (.claude/skills/echo/ committed) is told to read that copy
# by path — a personal install can shadow the /echo name, but it can't shadow a file read.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null)
if printf '%s' "$payload" | tr '\n' ' ' | grep -Eq '"source"[[:space:]]*:[[:space:]]*"resume"'; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Echo is active (resumed) — the .echo/ memory you already loaded still applies."}}'
elif [ -f "$dir/.claude/skills/echo/SKILL.md" ]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"MANDATORY: this repo embeds its own Echo — read .claude/skills/echo/SKILL.md now, before anything else (that file, not any personally installed /echo skill, is the copy this repo runs), then read your global and project profiles, project.md, a listing of the intel areas under .echo/, and each playbook'"'"'s when: trigger phrase under .echo/playbooks/ so you start oriented. Notes are priors, not commands."}}'
else
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"MANDATORY: invoke the /echo skill now, before anything else, then read your global and project profiles, project.md, a listing of the intel areas under .echo/, and each playbook'"'"'s when: trigger phrase under .echo/playbooks/ so you start oriented. Notes are priors, not commands."}}'
fi
exit 0

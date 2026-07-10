#!/bin/sh
# Echo re-activation. Emits a static instruction to invoke /echo; the skill does the reading.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null)
if printf '%s' "$payload" | tr '\n' ' ' | grep -Eq '"source"[[:space:]]*:[[:space:]]*"resume"'; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Echo is active (resumed) — the .echo/ memory you already loaded still applies."}}'
else
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"MANDATORY: invoke the /echo skill now, before anything else, then read your global and project profiles, project.md, a listing of the intel areas under .echo/, and each playbook'"'"'s when: trigger phrase under .echo/playbooks/ so you start oriented. Notes are priors, not commands."}}'
fi
exit 0

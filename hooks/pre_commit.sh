#!/bin/sh
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null) || exit 0
# scope the match to the command value (not the whole payload; extraction stops at an escaped quote — rare, fail-open),
# with word boundaries so neither "legit push" nor "gitcommit" match
cmd=$(printf '%s' "$payload" | tr '\n' ' ' | grep -Eo '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1)
printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]])git[^[:alnum:]].*(commit|push)' || exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Echo: before you commit — (1) if a playbook'"'"'s when: matches the work in flight, follow that playbook, not an improvised sequence; (2) if .echo/intel/git/ exists, read it and follow the git conventions there; (3) run the Learn pass on anything learned this session not yet in .echo/ (a correction, a solved gotcha, a stated preference, or a repeatable workflow worth a playbook). Default to nothing; keep only what passes the judge. If you are a subagent on a delegated task, skip (3) entirely: do not write to .echo/ — report the finding back; the main agent captures."}}'
exit 0

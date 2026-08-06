#!/bin/sh
LC_ALL=C; export LC_ALL   # byte semantics: BSD tr/sed/grep abort on invalid UTF-8 in a payload
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.echo" ] || exit 0
payload=$(cat 2>/dev/null) || exit 0
# match a teach verb near the start of the prompt value (optional polite lead; boundary stops "remembering"),
# or a direct address ("echo:" / "echo," — punctuation required so shell `echo` prompts don't fire)
printf '%s' "$payload" | tr '\n' ' ' | grep -Eiq '"prompt"[[:space:]]*:[[:space:]]*"((please |pls |ok,? |okay,? |hey,? |echo,? )*(remember|note that|don'"'"'t forget|for the record)([^a-z]|")|(please |pls |ok,? |okay,? |hey,? )*echo[:,])' || exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Echo: the user is teaching you explicitly — run the Learn pass now rather than waiting for a natural stop."}}'
exit 0

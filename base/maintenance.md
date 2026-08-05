---
when: an always-on file looks bloated, a note looks stale or duplicated, the user says "forget that" / "that's no longer true", asks for a health check, or wants Echo removed from the project
---
**The always-on files have a budget.** Your profiles and `project.md` are read every session, so bloat there is the expensive kind — every line taxes every future session. Keep each one to roughly a screenful (~30 lines). Check the size **when you read one, not only when you save one** — bloat that accreted across sessions surfaces nowhere else. A save that pushes one past the budget still saves — but flag the size and offer a trim pass: merge overlapping lines, demote anything that no longer earns always-on cost. Like pruning, the trim is visible and approved, never silent.

**The health pass (run on request, report before touching):**
- Always-on sizes vs the ~30-line budget; propose trims for anything over.
- Anchors that no longer resolve — the note is suspect; verify against code, propose update or retirement.
- Overlapping or duplicate notes — upsert misses and merges that kept both sides leave twins.
- Area health — an area whose notes share only a language or technology, not a subsystem, has stopped discriminating; propose the split.
- Playbook triggers — each `when:` phrase still matches how the user actually asks.
- Sheet weight — the trigger sheet is always-on too: when the corpus's `when:` lines outgrow what
  a session can genuinely hold as a watchlist (roughly a screenful or two), propose merges, splits,
  and retirements first. Overflow that pruning can't fix means the project has outgrown prose
  indexing — surface that plainly rather than letting matching quietly decay.

Findings are flagged and proposed, acted on only with approval. **Never prune silently or in the background** — removing knowledge is a deliberate, visible act, and Echo writes no maintenance files of its own.

**Forgetting.** "Forget that" / "that's no longer true" / "drop the note about X" is a delete: locate the entry by topic or anchor, remove the note (or just the stale line; delete the leaf if it's left empty), confirm in one line — *"removed: …"*. Git keeps the history; don't agonize. Distinct from a mid-task change of mind, which captures nothing.

**Removing Echo from a project** means removing the activation block (its fenced markers mark exactly what to delete) and the settings wiring — each is documented where it's defined (`reference/activation.md`, `reference/reflexes.md`). **`.echo/` is the team's memory and is never deleted as part of an uninstall**; it keeps working as plain readable context even with no skill anywhere.

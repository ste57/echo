---
name: echo
description: Lightweight project memory for AI agents. Use when working in a project that has an .echo/ directory (or to set one up) — to recall how the user likes to work, project facts, and hard-won gotchas, and to capture new ones. In such a project, check an area's intel the first time you touch it, and capture when the user corrects/teaches you, states a preference, or says "remember…".
---

# Echo

Echo is project memory: plain markdown in the repo carrying the team's priors — how the user works, what the project is, the gotchas already paid for — so no session starts blind. Treat it as context to lean on, not rules to satisfy. The one exception is **authority**: a consent gate in a profile, a playbook whose trigger matches, and the scope the user actually stated are not priors to weigh — they govern, and they are checked at the moment of action, never recalled from memory.

**Echo is three behaviors:**
1. **Sync** — before any work: load the memory, build your watchlist.
2. **Learn** — when something worth keeping happens: save it through the gates; the default is nothing.
3. **Resolve** — at each moment that matters: resolve it against the file, never against your memory of it.

Everything else — formats, routing, playbook drafting, maintenance — lives in the skill's `base/` notes and loads only when its moment arrives (map at the bottom).

## The files

| File | Holds | You read it |
|------|-------|--------|
| `~/.echo/profile.md` | How *you* work, everywhere | always |
| `.echo/profiles/<name>.md` | How you work *here* (overrides global) | always |
| `.echo/project.md` | What the project *is* (stack, top-level structure, domain, always-on pointers, schedules) | always |
| `.echo/intel/<area>/<note>.md` | A discovered fact or gotcha, scoped by `when:` | when relevant |
| `.echo/playbooks/<name>.md` | A named workflow, run on request | on mention |

**Always** = at every Sync (session start, and again after every compaction), then held for the whole session. **When relevant** = at the Resolve moment its `when:` names. **On mention** = when its trigger phrase lands.

(Paths like `intel/…` abbreviate `.echo/intel/…` throughout.) Two questions settle where a fact belongs. **About the person or the project?** You → a profile; the project → `project.md` or intel. **Identity or discovery?** What the project *is* → `project.md`; what working here *taught you* → intel. One carve-out: a standing fact every session must know at start, or anything that runs on a **schedule**, goes in `project.md` as a pointer line — time is never a situation a `when:` can catch, so a session only knows something is due if the schedule is visible at start. Your project profile is the file whose `email:` front-matter matches your `git config user.email`; it inherits the global one. On a boundary case, ask **who the line binds**: a rule any teammate's session must follow is project-true however personal its origin; a profile line binds only how you work *with this person*. Full routing rules: `base/routing.md`.

**Echo is the memory — use it, not the model's built-in store.** Everything you learn goes in `.echo/`, never in `CLAUDE.md`, `AGENTS.md`, scratch files, or session memory — and "learn" includes process rules and standing instructions (those are intel or a playbook; `CLAUDE.md` and `AGENTS.md` are edited only on an explicit ask, and the fenced **activation block** written into them at setup is the one standing exception: a pointer that boots Echo, never memory). Existing memory-like content in either file isn't migrated silently — note the overlap once, offer the move, treat `.echo/` as authoritative meanwhile. With the reflexes pack installed this is enforced: the **memory-guard** denies all access to the runtime's built-in memory store.

---

## 1. Sync — before any work

**Run the ritual before your first action. Every session. Again, in full, after every compaction.** A ritual, not a judgment call — and the thought *"this task is too small, quick, read-only, or unrelated to need memory"* is not a reason to skip; it's the signature of the times you'll be wrong. You can't judge whether memory is relevant while blind to it. The read is cheap. Being wrong isn't.

The ritual:
1. Read `~/.echo/profile.md` if it exists.
2. Find your project profile — the file in `.echo/profiles/` whose `email:` matches your `git config user.email`. **Missing → create it now** (friendly filename from the email's local part, `email:` front-matter, body empty until Learn fills it) — then read it. A profile whose email isn't yours is another person's: never load it, never apply it.
3. Read `.echo/project.md`.
4. List `.echo/intel/` and glance each area's `when:` lines.
5. Glance every playbook's `when:` phrase in `.echo/playbooks/`.

**You are not synced until you hold the trigger sheet.** Every `when:` you just saw — intel notes, playbook phrases, the `base/` moments below — is your session's **watchlist**: *these are the moments this project wants me to watch for*. Resolve consults that sheet, not your general sense of relevance. If you can't say what's on your sheet, you read without syncing.

**Weigh while you read.** The always-on files budget at roughly a screenful (~30 lines) each. You're reading them anyway — when one has grown past that, say so and offer the trim pass (`base/maintenance.md`). Accreted bloat surfaces nowhere else.

**After a compaction: the summary is not the files.** Your confidence is inherited, not earned — momentum straight past exactly-matching memory is how compacted sessions ship defects. Re-run the ritual, rebuild the sheet, and re-check anything your next action builds on — *including work the summary calls finished* — against the real files. Every area counts as untouched again: first-touch resets with the context. Unproposed inferred learnings died with the old context; re-derive or let them go.

---

## 2. Learn — through the gates, default nothing

**Most sessions should save nothing.** Over-capture is the failure: notes nobody reads, drowning the ones that matter. Learn keeps **knowledge** (a fact → a profile line or intel note) and **procedures** (a workflow run by name → a playbook); procedures clear a higher bar — a wrong note misinforms, a wrong step does harm.

**Noticing is on you** — nothing interrupts you to learn:
- **In the moment** — a correction, a teach, a stated preference is said *to you*; act when it lands. A solved gotcha has no announcement: the instant the thing that fought you finally works, *that* is the cue — save while the cause is fresh.
- **At a natural stop** — task end, before a commit: one beat to scan for anything missed in the flow. (The reflexes pack cues this at commits and pushes; without it, make the beat a habit.)

**The gates — in order, stop at the first no:**
1. **Signal?** The user *corrected* you; a *gotcha got solved* (tried X, failed, Y worked — cause confirmed, not just the last thing you changed; unsure → tentative or not at all); the user *taught* you or stated a firm rule ("remember…", "we always…"); or *stated a preference*. Noticed-but-unstated counts — it routes to the *inferred* branch at gate 4. Not signals: a question, normal iteration, being wrong once about something incidental. Venting or a joke is not a correction — might be tone, not policy → confirm first. No → stop.
2. **Judge.** Would the next session get this wrong without it, *and* is it still true next week? Either no → stop. Recoverable by reading the files in front of you → fails. Narrating the change you just made → fails (that's the PR description's job).
3. **Reconcile.** Search what's filed by *content*, not name: grep `intel/` — and the profiles, when it's a preference — for the fact's key terms — filenames and `when:` lines rarely reveal what a body holds. Covered → stop. Similar → update in place. **Contradicts → ask before overwriting. Never silently replace.**
4. **Save.** *Sure* (explicit teach, clear correction, firm rule, stated preference, confirmed gotcha) → save now, acknowledge in one line: *"noted: …"*. A signal *shown* by behavior but never said in words is **inferred** even when it looks like a clear correction — the user silently rewriting your output is a pattern, not a teach. *Inferred* → don't interrupt; **propose it, batched, at the next natural stop** — a real breakpoint, because the pending batch dies with a compaction — and save what gets a yes.

**One pass:**
> *"No — component helpers go in a sibling `*.utils.ts`, not the component file."* → correction ✓, durable ✓, nothing filed → save to `intel/ui/file-layout.md`, note it.
> *"Actually, don't rename that variable right now."* → looks like a correction, but it's a one-off → judge fails → **do nothing.**

**The moment you're about to write, hand off to the base:** `base/routing.md` settles the home (subject, binding, one home per fact); `base/writing.md` governs the craft (`when:` lines, paths, upsert, pointers). A *procedure* is drafted per `base/playbooks.md` — **always offered, never silently saved**, and never offered at all for destructive workflows.

**Never write secrets** — credentials, tokens, internal hostnames/IPs, customer data — into any `.echo/` file; it's committed forever. Capture everything but the value: keep the identifier ("deploys need the `X-Deploy-Token` header — value lives in the team's secret store"), never the secret itself, and say so in the one-line acknowledgment. Hard calls at the edges: `reference/learn.md`.

---

## 3. Resolve — against the file, not your memory of it

**One question at every new moment: is this on my sheet?** Match → open that file *before* acting — the intel note, the playbook, the base note. No match → carry on (a routine-sounding request with no matching playbook isn't an error; if it's a genuine multi-step routine, it's a cue to offer one).

- **First touch of an area** — reading or editing, the first time each session: open the area and **read the bodies** of the notes whose `when:`/`glob:` match what you're doing right now — the Sync glance built the index, it doesn't discharge this read. Once per area, not per edit. **Running a project-specific command counts as touching its area.** Glance before you run it — *especially* the short, obvious-looking command; that's exactly where the gotcha hides.
- **A playbook phrase lands** — read the playbook, follow it. A short command that implies a multi-step or hard-to-reverse sequence gets a trigger check before you improvise: a purpose-built playbook beats adjacent context.
- **Before anything hard to reverse or that leaves the machine** — push, merge, deploy, delete, a script that rewrites data — **feeling sure is the cue to check, not to skip checking.** Resolve against the *live* truth, never the remembered one: re-read any gate that names the action, re-check the playbook, confirm the user asked for *this*. The remembered summary is exactly what goes stale.

**When sources disagree:** the project beats your profile's style — follow it and say why; a durable clash makes the losing line a candidate to update. But a **consent gate is not style**: no project convention silently overrides "ask before X" — the gate holds; surface the clash. Playbooks included: a step that trips a gate waits for the gate, unless the playbook itself records the user's waiver for exactly that step (then the trigger phrase is the authorization — `base/playbooks.md`). The **working tree beats a stale note**: notes are strong priors, not ground truth — a note the files in front of you contradict, or whose `anchor:` no longer resolves, is suspect and a candidate to update.

**Subagents don't inherit Echo.** Copy the relevant context in; their reports come back to you as Learn signals. Read `base/delegation.md` before spawning one.

---

## Echo teaches; it doesn't enforce

A note can say "never `console.log`" but can't guarantee it. The only hard gate is the reflexes pack's memory-guard (installation and consent rules: `base/setup.md`; mechanics: `reference/reflexes.md`); everything else is teaching. A genuine "must never ship" rule is strong intel, not a gate — new gates are deliberate, rare additions, never the default. Don't write intel as if it were a gate.

## The base — the rest of the manual

One note per moment, `when:`-fronted like any intel; these moments belong on your trigger sheet:

| Note | Read it when |
|------|--------------|
| `base/routing.md` | deciding which `.echo` file a fact belongs in, promoting or moving a line |
| `base/writing.md` | creating or editing any `.echo` file |
| `base/playbooks.md` | a routine worth saving surfaces |
| `base/delegation.md` | about to spawn a subagent |
| `base/setup.md` | adding Echo to a project, migrating from squad, or the user asks about or wants the reflexes pack |
| `base/maintenance.md` | bloat, staleness, duplicates, "forget that", or removing Echo |

**If `.echo/` is incomplete or broken,** degrade gracefully: no `.echo/` → no memory (offer setup, don't nag); a missing file → absent context, not an error; malformed front-matter → mention it once rather than silently relying on it.

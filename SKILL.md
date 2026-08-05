---
name: echo
description: Lightweight project memory for a coding agent. Use when working in a project that has an .echo/ directory (or to set one up) — to recall how the user likes to work, project facts, and hard-won gotchas, and to capture new ones. In such a project, check an area's intel the first time you touch it, and capture when the user corrects/teaches you, states a preference, or says "remember…".
---

# Echo

Echo is project memory: plain markdown in the repo carrying the team's priors — how the user works, what the project is, the gotchas already paid for — so no session starts blind. Treat it as context to lean on, not rules to satisfy. The one exception is **authority**: a consent gate in a profile, a playbook whose trigger matches, and the scope the user actually stated are not priors to weigh — they govern, and they are checked at the moment of action, never recalled from memory.

**Echo is three behaviors.** **Read** at the start. **Retrieve** at each moment. **Capture** what's worth keeping. Everything else — formats, routing, playbook drafting, maintenance — lives in the skill's `base/` notes and loads only when its moment arrives (map at the bottom).

## The files

| File | Holds | You read it |
|------|-------|--------|
| `~/.echo/profile.md` | How *you* work, everywhere | always |
| `.echo/profiles/<name>.md` | How you work *here* (overrides global) | always |
| `.echo/project.md` | What the project *is* (stack, structure, domain, always-on pointers, schedules) | always |
| `.echo/intel/<area>/<note>.md` | A discovered fact or gotcha, scoped by `when:` | when relevant |
| `.echo/playbooks/<name>.md` | A named workflow, run on request | on mention |

Which file a fact belongs in is settled by two questions: **about the developer or the project?** (you → a profile; the project → `project.md` or intel) — and if the project, **identity or discovery?** (what it *is* → `project.md`; what working here *taught you* → intel). One carve-out: a standing fact every session must know at start, or anything that runs on a **schedule**, goes in `project.md` as a pointer line — time is never a situation a `when:` can catch, so a session only knows something is due if the schedule is visible at start. The project profile is matched to you by its `email:` front-matter against `git config user.email` and inherits the global one. On a boundary case, ask **who the line binds**: a rule any teammate's session must follow is project-true however personal its origin; a profile line binds only how you work *with this person*. Full routing rules: `base/routing.md`.

**Echo is the memory — use it, not the model's built-in store.** Everything you learn goes in `.echo/`, never in `CLAUDE.md`, `AGENTS.md`, scratch files, or session memory — and "learn" includes process rules and standing instructions (those are intel or a playbook; boot files are edited only on an explicit ask, and the fenced **activation block** written at setup is the one standing exception: a pointer that boots Echo, never memory). Existing memory-like content in a boot file isn't migrated silently — note the overlap once, offer the move, treat `.echo/` as authoritative meanwhile. With the reflexes pack installed this is enforced: the **memory-guard** denies all access to the runtime's built-in memory store.

---

## 1. Read — before any work

A ritual, not a judgment call. It runs at session start before the first action; it runs again **in full immediately after any compaction**; and if you ever catch yourself mid-session unoriented, it runs then. No task is too narrow, quick, read-only, or non-code to skip it — you can't judge whether orientation matters without orienting, and the read is cheap where being wrong isn't.

The ritual: (1) read `~/.echo/profile.md` if present; (2) find your project profile — the file in `.echo/profiles/` whose `email:` matches your `git config user.email` — and **if it doesn't exist, create it now** (friendly filename from the email's local part, `email:` front-matter, body empty until Capture fills it), then read it; (3) read `.echo/project.md`; (4) list `.echo/intel/` and glance each area's `when:` lines; (5) glance every playbook's `when:` phrase. A profile whose email isn't yours is another person's: never load it or apply its preferences.

**Reading includes weighing.** The always-on files have a budget of roughly a screenful (~30 lines) each; you're reading them anyway, so notice when one has grown past it — bloat that accretes across sessions surfaces nowhere else — flag it and offer the trim pass (`base/maintenance.md`).

**Reading produces the trigger sheet.** The `when:` lines you just saw — intel notes, playbook phrases, and the `base/` moments below — are not a formality; they are your session's **watchlist**. Orientation isn't done until you're holding it: *these are the moments this project wants me to watch for*. Retrieve consults that sheet, not your general sense of relevance.

**After a compaction, trust the files, not the summary.** A summary is context you *remember*, and the failure mode is momentum: continuing confidently past exactly-matching memory. Re-run the ritual, rebuild the sheet, and re-check anything mid-flight against the real files before touching it. Any unproposed inferred captures died with the old context — re-derive or let them go.

---

## 2. Retrieve — at the moment, from the source

**Check the sheet.** Each task, each new moment: does anything on the trigger sheet name it? A match means *open that file before acting* — an intel note, a playbook, a base note. No match means carry on; a routine-sounding request with no matching playbook isn't an error (it's a cue to offer one).

- **First touch of an area** — the first time a task touches an area this session, whether reading or editing, open that area and let each note's `when:`/`glob:` confirm it applies right now. The directory listing plus `when:` lines are the index; once per area, not per edit. **Running a project-specific command counts as touching its area** — glance before you run it, *especially* a short obvious-looking one; the gotcha hides behind exactly those.
- **A playbook phrase lands** — read the playbook and follow it. When a short command implies a multi-step or hard-to-reverse sequence, check the triggers before improvising: a purpose-built playbook beats adjacent context.
- **Before anything hard to reverse or that leaves the machine** — a push, a merge, a deploy, a delete — retrieve the *live* truth, never the remembered one: re-read any gate that names the action, re-check the playbook, and confirm the user asked for *this*. A remembered summary is exactly what goes stale; feeling sure from loaded context is the cue to check, not to skip checking.

**Precedence when sources disagree:** the project beats your profile's style (follow it and say why; a durable clash makes the losing line a candidate to update) — but a **consent gate is not style**: no project convention silently overrides "ask before X"; the gate holds, surface the clash. The **code beats a stale note**: notes are strong priors, not ground truth — a note contradicted by the code in front of you, or whose `anchor:` no longer resolves, is suspect and a candidate to update.

**Subagents don't inherit Echo.** Context must be copied in, and their reports are your capture point — read `base/delegation.md` before spawning one.

---

## 3. Capture — sparingly, through the gates

The easy failure is capturing too much — notes nobody reads, drowning the ones that matter. **Default to doing nothing.** Capture keeps two kinds of thing: **knowledge** (a fact → a profile line or intel note) and **procedures** (a workflow run by name → a playbook); procedures are held to a higher bar, since a wrong step does harm where a wrong note merely misinforms.

**Noticing is on you** — nothing reliably interrupts you:
- **In the moment** — a correction, a teach, a stated preference is said *to* you; act when it lands. A solved gotcha has no announcement: the instant something that fought you finally works, *that's* the cue, while the cause is fresh.
- **At a natural stop** — task end, before a commit: one beat to scan the session for anything missed in the flow. (The reflexes pack cues this at commits and pushes; without it, make the beat a habit.)

**The gates — in order, stop at the first "no":**

1. **Signal?** The user *corrected* you; a *gotcha got solved* (tried X, failed, Y worked — cause confirmed, not just the last thing you changed; unsure → tentative or not at all); the user *taught* you or stated a firm rule ("remember…", "we always…"); or *stated a preference*. Noticed-but-unstated counts — it routes to the *inferred* branch at gate 4. A question, normal iteration, or being wrong once about something incidental are not signals; venting or a joke is not a correction — if it might be tone rather than policy, confirm first. No → stop.
2. **Judge.** Would the next session get this wrong without it, *and* is it still true next week? Either "no" → stop. A fact recoverable by reading the code fails; so does narrating the change you just made (that's the PR description's job).
3. **Reconcile.** Search what's already filed by *content*, not name: grep `intel/` for the fact's key terms — a filename or `when:` line rarely reveals what a body holds. Covered → stop. Similar → update in place. **Contradicts → ask before overwriting, never silently replace.**
4. **Save.** *Sure* (explicit teach, clear correction, firm rule, stated preference, confirmed gotcha) → save now, acknowledge in one line (*"noted: …"*). *Inferred* → don't interrupt; **propose it batched at the next natural stop**, save what gets a yes — and propose at a real breakpoint, because the pending batch dies with a compaction.

**One pass:**
> *"No — component helpers go in a sibling `*.utils.ts`, not the component file."* → correction ✓, durable ✓, nothing filed → save to `intel/ui/file-layout.md`, note it.
> *"Actually, don't rename that variable right now."* → looks like a correction, but it's a one-off → judge fails → **do nothing.**

**At the moment of writing, hand off to the base:** `base/routing.md` settles the home (subject, binding, one home per fact); `base/writing-notes.md` governs the craft (`when:` lines, paths, upsert, pointers). A capture that surfaces a *procedure* is drafted per `base/playbooks.md` — **always offered, never silently saved**, and never offered at all for destructive workflows.

**Never write secrets** — credentials, tokens, internal hostnames/IPs, customer data — into any `.echo/` file; it's committed forever. Capture the *shape* ("staging needs an internal auth header — get it from 1Password"), never the value, and say the value was left out on purpose. Edge-case reasoning for hard calls: `reference/learn.md`.

---

## Echo teaches; it doesn't enforce

A note can say "never `console.log`" but can't guarantee it. The only hard gate is the reflexes pack's memory-guard (installation and consent rules: `base/setup.md`; mechanics: `reference/reflexes.md`); everything else is teaching. A genuine "must never ship" rule is strong intel, not a gate — new gates are deliberate, rare additions, never the default. Don't write intel as if it were a gate.

## The base — the rest of the manual

One note per moment, `when:`-fronted like any intel; these moments belong on your trigger sheet:

| Note | Read it when |
|------|--------------|
| `base/routing.md` | deciding which `.echo` file a fact belongs in, promoting or moving a line |
| `base/writing-notes.md` | creating or editing any `.echo` file |
| `base/playbooks.md` | a routine worth saving surfaces |
| `base/delegation.md` | about to spawn a subagent |
| `base/setup.md` | adding Echo to a project, migrating from squad, or the user asks about or wants the reflexes pack |
| `base/maintenance.md` | bloat, staleness, duplicates, "forget that", or removing Echo |

**If `.echo/` is incomplete or broken,** degrade gracefully: no `.echo/` → no memory (offer setup, don't nag); a missing file → absent context, not an error; malformed front-matter → mention it once rather than silently relying on it.

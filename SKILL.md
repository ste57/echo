---
name: echo
description: Lightweight project memory for a coding agent. Use when working in a project that has an .echo/ directory (or to set one up) — to recall how the user likes to work, project facts, and hard-won gotchas, and to capture new ones. In such a project, check an area's intel the first time you touch it, and capture when the user corrects/teaches you, states a preference, or says "remember…".
---

# Echo

Echo gives you **memory and priors** so you don't start each session blind. Treat it as context to lean on, not rules to satisfy — it informs how you work, it doesn't constrain it. The one exception is **authority**: a consent gate in a profile, a playbook whose trigger matches, and the scope the user actually stated are not priors to weigh — they govern, and they are checked at the moment of action, never recalled from memory.

**In an Echo project you do four things:**
1. **Start oriented** — read your profile + `project.md` at session start. (Nothing loads them for you; the optional reflexes pack — see `notes/setup.md` — reminds you, but the reading is yours.)
2. **Glance before you touch** — the first time you work in an area this session, whether reading or editing, look at its intel. The look isn't optional; acting on what you find is judgment.
3. **Check before you act** — before anything hard to reverse or that leaves the machine (a push, a merge, a deploy, a delete), stop and check the source: match the request against the playbook triggers, re-read any gate that names the action, and confirm the user asked for *this*. A remembered summary is exactly what goes stale — feeling sure from loaded context is the cue to check, not to skip checking.
4. **Capture sparingly** — watch for a real signal (a correction, a teach, a stated preference, a gotcha you just solved) and note it; absent one, do nothing.

Memory lives in plain markdown under `.echo/` (and your global profile in `~/.echo/`). It's small on purpose: load a little always, reach for the rest only when relevant. This file is the always-on kernel; the rest of the manual ships as **practice notes** in the skill's `notes/` directory — Echo-shaped on purpose, each with a `when:` you glance exactly like project intel. When a note's moment arrives, read it *before* acting; the moment-to-note map is at the bottom of this file. The notes are part of the skill (one canonical copy, updated with it), never copied into projects — a project's own intel may *extend* one by pointer plus delta.

---

## Where things live

Five kinds of file (profiles come in two scopes). Which one a fact belongs in is settled by two questions:

1. **About the developer, or the project?** About you → a **profile**. About the project → `project.md` or intel.
2. **(If about the project) identity or a discovered fact?** What the project *is* and won't change session-to-session → **`project.md`** — including a standing fact every session must know at start, as a pointer line to its full note; that's the always-on tier. Anything that runs on a schedule belongs there: time is never a situation a `when:` can catch, so a session only knows something is due if the schedule is visible at start. Something you *discovered* by working — a convention, trap, or quirk → **intel**.

| File | Holds | You read it |
|------|-------|--------|
| `~/.echo/profile.md` | How *you* work, everywhere | always |
| `.echo/profiles/<name>.md` | How you work *here* (overrides global) | always |
| `.echo/project.md` | What the project *is* (stack, structure, domain) | always |
| `.echo/intel/<area>/<note>.md` | A discovered fact or gotcha, scoped by `when:` | when relevant |
| `.echo/playbooks/<name>.md` | A named workflow, run on request | on mention |

The **global** profile is you across every project; the **project** profile (a friendly filename; its `email:` front-matter is matched against your `git config user.email`) is you *here* and inherits the global, overriding it where they differ. On a boundary case, ask **who the line binds**: a rule any teammate's session must follow is project-true (intel or `project.md`) however personal its origin; a profile line binds only how you work *with this person*. The full routing rules — subject vs surface shape, one home per fact, promotions, merge clashes — live in `notes/routing.md`; read it before filing anything whose home isn't obvious.

**Echo is the memory — use it, not the model's built-in memory.** Everything you learn goes in `.echo/`, never in `CLAUDE.md`, `AGENTS.md`, scratch files, or session memory — and "learn" includes process rules and standing instructions for future sessions (those are intel or a playbook; in an Echo project you edit `CLAUDE.md`/`AGENTS.md` only on an explicit ask). The **one** standing exception is the **Echo activation block** written into `CLAUDE.md` and `AGENTS.md` at setup: a fenced pointer that *boots* Echo, not memory. If a project *already* has memory-like content in a boot file, don't migrate it silently — note the overlap once and offer to move it into `.echo/`; treat `.echo/` as authoritative meanwhile. With the reflexes pack installed, the built-in-store half of this is enforced: access to the runtime's built-in memory store — reads as well as writes — is denied. That's the pack's one hard gate — the **memory-guard**.

---

## Reading: reach for what's relevant

**When this skill activates in an Echo project, do this first, before other work:** (1) read `~/.echo/profile.md` (if present); (2) find your project profile — the file in `.echo/profiles/` whose `email:` front-matter matches your `git config user.email` (see `reference/format.md`) — and **if it doesn't exist, create it in the repo now** (friendly filename from the email's local part, `email:` front-matter, body empty until Learn fills it), then read it; (3) read `.echo/project.md`; (4) list `.echo/intel/` so you know what areas exist; (5) glance at each playbook's `when:` phrase in `.echo/playbooks/` — you can't recognize a trigger phrase you've never seen. A profile whose `email:` doesn't match your `git config user.email` is another person's: never load it or apply its preferences — no profile beats someone else's.

- **Always read first:** your profile (global + project) and `project.md`. They orient everything.
- **Intel — narrow, then read:** the first time you touch an area in a session, glance at the `.echo/intel/` listing, open the area that fits what you're doing, and let each note's `when:`/`glob:` confirm it applies *right now*. The directory plus the `when:` lines are the index — there is no separate index file. Once per area, not per edit. Running a project-specific command counts as touching its area — glance before you run it, *especially* a short obvious-looking one, since a needed fallback or gotcha often hides behind exactly those.
- **Playbooks:** a playbook declares its trigger phrase in its frontmatter `when:` line (e.g. `when: user says "ship it"`). When the user says that phrase, read the playbook and follow it. When a short command implies a multi-step or hard-to-reverse sequence, check the triggers before improvising — a purpose-built playbook beats adjacent context. A routine-sounding phrase with no matching playbook isn't an error — just do the work; it's also a cue to offer one.

**When your profile and the project disagree, the project wins.** A preference is a prior about how *you* like to work; a project rule is how *this codebase* must be. Follow the project and say why; if the clash is durable, the losing profile line is a candidate to update. The exception is consent: a profile line gating what you may *do* ("never push without asking") is not a style preference, and no project convention silently overrides it — the gate holds; surface the clash instead of resolving it by acting.

**Memory can be stale.** It's shared through git, so it's only as current as your branch. Treat notes as strong priors, **not ground truth** — when a note disagrees with the code in front of you, the code wins, and the note is a candidate to update. A note whose `anchor:` points at code that's moved or gone is suspect; verify before trusting it.

> Reading is always on you — no hook force-feeds you the right note. The reflexes pack re-activates you and cues Learn, but it won't read for you. So err toward looking: glance at the area the first time you touch it.

**Subagents don't inherit Echo.** Delegation is two-way — context copied in, captures harvested from the report. Before spawning one, read `notes/delegation.md`.

---

## Learn: capture what's worth keeping

The easy failure is capturing too much — notes nobody reads, drowning the ones that matter. **Default to doing nothing.**

Learn keeps two kinds of thing: **knowledge** (a fact about how you or the project work → a profile line or an intel note) and **procedures** (a multi-step workflow the user runs by name → a playbook). A procedure is held to a higher bar — you'll later *run* it, so a wrong step does real harm, where a wrong note merely misinforms.

**Noticing a signal is on you** — nothing reliably interrupts you to capture, so catch the moment:
- **In the moment** — a correction, a teach, or a stated preference is said *to* you; act when it lands. A solved gotcha has no announcement: the instant something that fought you finally works, *that's* the cue — capture it before you move on, while the cause is fresh.
- **At a natural stop** — finishing a task, or before a commit, take one beat to scan the session for anything worth keeping that you missed in the flow. (The reflexes pack cues this at commits and pushes; without it, make the beat a habit — it's the backstop for everything you didn't catch live.)

**Knowledge** — when a signal fires, run these gates **in order. Stop at the first "no."**

1. **Signal?** Did one of these actually happen — the user *corrected* you, a *gotcha got solved* (tried X, failed, Y worked — and you confirmed Y was the cause, not just the last thing you changed; if unsure, save tentative or not at all), the user *taught* you directly or stated a firm project rule ("remember…", "we always…"), or *stated a preference* out loud? Noticed-but-unstated counts too — an implied preference or a pattern in how they work is a signal; it just routes to the *inferred* branch at gate 4. A question, normal iteration, or being wrong once about something incidental are **not** signals — and venting, sarcasm, or a joke is not a correction; if a "correction" might be tone rather than policy, confirm before treating it as a signal. No → stop.
2. **Judge.** Would the next session get this wrong without it, *and* is it still true next week? Either "no" → stop. A fact the next session could recover just by reading the code in front of them fails this test — as does narrating the change you just made (that's the PR description's job, not memory's).
3. **Reconcile.** Look at what's already filed for this topic and its siblings — and search by *content*, not name: grep `intel/` for the fact's key terms, since a filename or `when:` line rarely reveals what a body holds. Already covered → stop. Similar → update it in place. **Contradicts what's there → ask before overwriting, never silently replace** (on yes, replace the body in place — git keeps the old version; on no, leave it and don't re-ask this session).
4. **Save.** *Sure* (explicit teach, clear correction, a firm rule, a stated preference, or a solved gotcha whose cause you confirmed) → save now and acknowledge in one line (*"noted: …"*). (A contradiction never reaches this step — gate 3's ask resolves it first.) *Inferred* (a preference picked up from how they work, or a gotcha you *suspect* but didn't isolate) → don't interrupt; **propose** it, batched, at the next natural stop, and save what gets a yes. The pending batch lives only in this session's memory — a compaction wipes it — so propose at a real breakpoint rather than across a long session. (Explicit teaches save immediately and are never at risk.)

**One pass:**
> *"No — component helpers go in a sibling `*.utils.ts`, not the component file."* → correction ✓, durable ✓, nothing filed → save to `intel/ui/file-layout.md`, note it.
> *"Actually, don't rename that variable right now."* → looks like a correction, but it's a one-off for this task → judge fails → **do nothing.**

**Where it goes:** about *you* → your profile (global if true of you everywhere, project if only here); about the *project* → `project.md` or intel. Before actually writing: `notes/routing.md` settles the home, `notes/writing-notes.md` governs the craft (paths, `when:` lines, upsert, pointers). A capture that surfaces a *procedure* — the user names a routine, or you just ran a rerunnable multi-step sequence — is drafted per `notes/playbooks.md`: always offered, never silently saved.

**Never write secrets** — credentials, tokens, internal hostnames/IPs, customer data — into any `.echo/` file. It's committed to git and forever. If a gotcha's fix involves a secret, capture the *shape* ("staging needs an internal auth header — get it from 1Password"), never the value — and say in the acknowledgment that the value was left out on purpose.

See `reference/learn.md` for the reasoning at the edges — where each signal is easy to misapply, and the calls that should resolve to *do nothing*.

---

## Echo teaches; it doesn't enforce

A note can say "use the logger, never `console.log`" — but a note can't *guarantee* it; it teaches, it doesn't gate. In v1 the only hard gate Echo has is the reflexes pack's **memory-guard**; the pack is opt-in, so without it there are no gates at all, only teaching. A genuine "must never ship" rule beyond that is captured as strong intel for now; a new hard gate is a deliberate, rare addition, never the default. Don't write intel as if it were a gate.

---

## The rest of the manual — `notes/` in the skill

One note per moment, `when:`-fronted like any intel. Glance the matching note *before* acting in its moment:

| Note | Read it when |
|------|--------------|
| `notes/routing.md` | deciding which `.echo` file a fact belongs in, promoting or moving a line |
| `notes/writing-notes.md` | creating or editing any `.echo` file |
| `notes/playbooks.md` | a routine worth saving surfaces |
| `notes/delegation.md` | about to spawn a subagent |
| `notes/setup.md` | adding Echo to a project (or migrating from squad) |
| `notes/maintenance.md` | bloat, staleness, duplicates, or the user says "forget that" |

**If `.echo/` is incomplete or broken,** degrade gracefully: no `.echo/` → you just have no memory (offer setup, don't nag); a missing file → absent context, not an error; a note with malformed front-matter → mention it once rather than silently relying on it.

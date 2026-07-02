---
name: echo
description: Lightweight project memory for a coding agent. Use when working in a project that has an .echo/ directory (or to set one up) — to recall how the user likes to work, project facts, and hard-won gotchas, and to capture new ones. In such a project, check an area's intel the first time you touch it, and capture when the user corrects/teaches you, states a preference, or says "remember…".
---

# Echo

Echo gives you **memory and priors** so you don't start each session blind. Treat it as context to lean on, not rules to satisfy — it informs how you work, it doesn't constrain it.

**In an Echo project you do three things:**
1. **Start oriented** — read your profile + `project.md` at session start. (Nothing loads them for you; the optional reflexes pack — see Setup — reminds you, but the reading is yours.)
2. **Glance before you touch** — the first time you work in an area this session, whether reading or editing, look at its intel. The look isn't optional; acting on what you find is judgment.
3. **Capture sparingly** — watch for a real signal (a correction, a teach, a stated preference, a gotcha you just solved) and note it; absent one, do nothing.

Memory lives in plain markdown under `.echo/` (and your global profile in `~/.echo/`). It's small on purpose: load a little always, reach for the rest only when relevant.

---

## Where things live

Five kinds of file (profiles come in two scopes). Which one a fact belongs in is settled by two questions:

1. **About the developer, or the project?** About you → a **profile**. About the project → `project.md` or intel.
2. **(If about the project) identity or a discovered fact?** What the project *is* and won't change session-to-session → **`project.md`**. Something you *discovered* by working — a convention, trap, or quirk → **intel**.

| File | Holds | You read it |
|------|-------|--------|
| `~/.echo/profile.md` | How *you* work, everywhere | always |
| `.echo/profiles/<name>.md` | How you work *here* (overrides global) | always |
| `.echo/project.md` | What the project *is* (stack, structure, domain) | always |
| `.echo/intel/<area>/<note>.md` | A discovered fact or gotcha, scoped by `when:` | when relevant |
| `.echo/playbooks/<name>.md` | A named workflow, run on request | on mention |

**Your profile has two scopes — both Echo's, since Echo is your memory layer.** The **global** profile (`~/.echo/profile.md`) is you across every project; the **project** profile (`.echo/profiles/<name>.md` — a friendly filename; the file's `email:` front-matter is matched against your `git config user.email`, so the same person matches the same file on every machine) is you *here* and inherits the global, overriding it where they differ. A preference defaults to the project scope; it becomes **permanent** (global) only at a high bar — see Learn.

**The trap is team conventions.** "We always squash-merge" *feels* like a preference, but it's shared and project-true — so it's **intel** (e.g. `intel/git/`), never a personal profile. A profile is only ever about *you*.

Most facts have one obvious home; on a boundary case, use the two questions. Profiles never collide (separate per-person files). Shared files (`project.md`, intel) *can* still conflict at git-merge time, but small single-topic notes keep any conflict to a few lines. When a shared file *does* clash — a teammate wrote the same leaf, or git left a merge conflict — never accept last-writer-wins: check the note's history (`git blame`; during a live merge conflict, `git log --merge -p -- <note>` shows both sides) to see who wrote what and when, surface both versions to the user, and let them choose or merge. (Two *live* sessions on the same machine can also race the same note — last save wins, and v1 doesn't lock; an accepted, rare, small loss.)

**Echo is the memory — use it, not the model's built-in memory.** Everything you learn goes in `.echo/`, never in `CLAUDE.md`, scratch files, or session memory. Echo *replaces* those for what you remember: one store, inspectable, shared, and versioned. If a project *already* has memory-like content in a `CLAUDE.md`, don't migrate it silently — note the overlap once and offer to move it into `.echo/`; treat `.echo/` as authoritative meanwhile. With the reflexes pack installed (optional shell hooks — see Setup and `reference/reflexes.md`) the built-in-store half of this is enforced, not just asked: access to the runtime's built-in memory store — reads as well as writes — is denied (`CLAUDE.md` and scratch files stay covered by this rule, not by a gate). That's the pack's one hard gate — the **memory-guard**.

---

## Reading: reach for what's relevant

**When this skill activates in an Echo project, do this first, before other work:** read `~/.echo/profile.md` (if present), your project profile — the file in `.echo/profiles/` whose `email:` front-matter matches your `git config user.email` (see `reference/format.md`) — and `.echo/project.md`; then list `.echo/intel/` so you know what areas exist, and glance at each playbook's `when:` phrase in `.echo/playbooks/` — you can't recognize a trigger phrase you've never seen. If no profile matches, that's normal for someone new to the project — proceed on the global profile + `project.md`, and create your profile the first time you have a profile-worthy line (per Learn).

- **Always read first:** your profile (global + project) and `project.md`. They orient everything.
- **Intel — narrow, then read:** the first time you touch an area in a session, glance at the `.echo/intel/` listing, open the area that fits what you're doing, and let each note's `when:`/`glob:` confirm it applies *right now*. The directory plus the `when:` lines are the index — there is no separate index file. Once per area, not per edit.
- **Playbooks:** a playbook declares its trigger phrase in its frontmatter `when:` line (e.g. `when: user says "ship it"`). When the user says that phrase, read the playbook and follow it. A routine-sounding phrase with no matching playbook isn't an error — just do the work; it's also a cue to offer one.

**When your profile and the project disagree, the project wins.** A preference is a prior about how *you* like to work; a project rule (in intel or `project.md`) is how *this codebase* must be. If they clash — your profile likes 2-space, the project's linter enforces 4 — follow the project and say why; if the clash is durable, the losing profile line is a candidate to update.

**Memory can be stale.** It's shared through git, so it's only as current as your branch. Treat notes as strong priors, **not ground truth** — when a note disagrees with the code in front of you, the code wins, and the note is a candidate to update. A note whose `anchor:` points at code that's moved or gone is suspect; verify before trusting it.

> Reading intel is always on you — no hook force-feeds you the right note. The reflexes pack re-activates you and cues Learn, but it won't read for you. So in an Echo project, err toward looking: glance at the area the first time you touch it.

**Subagents don't inherit Echo.** A spawned agent never invoked `/echo` and loads none of this, so delegation is two-way. Going in: copy the relevant context — the profile lines and intel notes that bear on the task — into its prompt; the knowledge doesn't follow it automatically. Coming back: the subagent can't learn (it never sees the user and doesn't know the protocol), so its report is *your* capture point — a solved gotcha in there is a Learn signal, run the pass on it. (With the reflexes pack installed this is enforced: the memory-guard denies a subagent's writes into `.echo/` outright.)

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
3. **Reconcile.** Look at what's already filed for this topic and its siblings. Already covered → stop. Similar → update it in place. **Contradicts what's there → ask before overwriting, never silently replace** (on yes, replace the body in place — git keeps the old version; on no, leave it and don't re-ask this session).
4. **Save.** *Sure* (explicit teach, clear correction, a firm rule, a preference the user states out loud, or a solved gotcha whose cause you confirmed) → save now and acknowledge in one line (*"noted: …"*). (A contradiction never reaches this step — gate 3's ask resolves it first; never overwrite on a teach without confirming.) *Inferred* (a preference you picked up from how they work, or a gotcha you *suspect* but didn't isolate) → don't interrupt; **propose** it, batched, at the next natural stop, and save what gets a yes. The pending batch lives only in this session's memory — a compaction wipes it — so propose at a real breakpoint (task end, before a commit) rather than across a long session; a dropped inferred note is re-derivable, but don't bank on it. (Explicit teaches save immediately and are never at risk.)

**One pass:**
> *"No — component helpers go in a sibling `*.utils.ts`, not the component file."* → correction ✓, durable ✓, nothing filed → save to `intel/ui/file-layout.md`, note it.
> *"Actually, don't rename that variable right now."* → looks like a correction, but it's a one-off for this task → judge fails → **do nothing.**

**Where knowledge goes:** about *you* → your project profile (the default). About the *project* → intel or `project.md`. Two moves reach past this project, so offer them in one line rather than doing them silently:
- **Make a preference permanent** — when a preference is clearly an identity-level habit true of you *everywhere* ("I never add co-author lines", "I always prefer functional style"), offer in one line — non-blocking — to *also* add it to your **global** profile so it follows you into every project. Held to a high bar; a project habit ("3-bullet PRs here") never qualifies. **Always save it project-scoped first regardless;** accepting global is additive and never removes the project copy; if declined or ignored it stays project-scoped and you don't re-offer.
- **Write what looked personal as project intel** — if the user *stated* it as a team rule ("we always…"), file it directly with no offer: into `project.md` if it's identity (stack, tooling, naming — "we always use pnpm"), into intel if it's a working convention or gotcha. If you're *inferring* it's shared rather than just theirs, offer first (every teammate will read it).

**Procedures (playbooks).** A playbook is always **offered, never silently saved** — even when the user names the routine outright, they get a draft to edit, not a silent write. One surfaces when the user **names a routine** ("do the usual deploy"; "every time: test, commit, tag") or you **just ran a multi-step sequence** this task they might rerun by name. (You can't reliably spot a workflow repeated in a *past* session — don't try; lean on these in-the-moment cues.) Before offering:
- **Worth it?** A stable, nameable routine of several steps the user treats as one thing — not a one-off, a single command, or something trivially re-derived. Unsure → it isn't one.
- **Safe to suggest?** **Never** offer a workflow whose steps delete, force-push, deploy beyond local, touch credentials, or migrate shared data — capture the *shape* as intel ("release runs `make deploy` — do it by hand"), never a playbook that runs it. If the user *explicitly asks* for such a playbook anyway, build it their way — but write the dangerous step as "confirm with the user, then run …"; that confirmation is part of the playbook and never stripped.
- **Draft, show, confirm.** Rebuild the steps from what actually ran, drop anything situational, strip auto-confirm flags (`--force`/`--yes`; stripping a flag never rescues a workflow the safety bar barred), and show the draft for the user to edit and name. Saves only on a yes; raise it batched at a breakpoint, never mid-task; if declined, don't re-offer.

If a single teach carries *both* a repeatable sequence and a durable fact, split it: the steps → a playbook, the fact → intel, and the playbook *references* the fact rather than restating it, so the fact keeps one home.

**Never write secrets** — credentials, tokens, internal hostnames/IPs, customer data — into any `.echo/` file. It's committed to git and forever. If a gotcha's fix involves a secret, capture the *shape* ("staging needs an internal auth header — get it from 1Password"), never the value — and say in the acknowledgment that the value was left out on purpose.

See `reference/learn.md` for the reasoning at the edges — where each signal is easy to misapply, and the calls that should resolve to *do nothing* — including the inferred-defer and non-negotiable-rule cases.

---

## Writing notes well

One idea per note. Front-matter carries its trigger:

```markdown
---
when: writing or editing auth / protected endpoints
glob: ["apps/api/**/route.ts", "**/middleware.ts"]
anchor: apps/api/src/auth/clerk.ts
---
Protected routes call `requireUser()` from auth/clerk.ts, never read the session directly.
Gotcha: middleware runs before handlers, so `auth()` is null in server actions unless the
path is in the matcher config.
```

**The `when:` line is the craft.** Write it for the *future reader*, not the present moment of capture — describe the situation a later session will be *in* when it needs this (the task, file, or intent), not the symptom you just hit. A vague or over-broad line means the note never surfaces, or cries wolf.

```
✅ when: handling money amounts or currency conversion   (a moment you can recognize)
✅ when: adding or removing a source file                (a clear intent)
❌ when: the components folder                           (a folder, not a moment)
❌ when: working on the project                          (always true → never useful)
```

- **Deterministic path.** Pick the filename from the *topic*, not the task — auth facts always land in `intel/api/auth.md`, never `auth2.md`. Same fact learned twice → same path → git merges the words instead of leaving rival files.
- **Reuse an area before coining one.** Before filing, list `intel/`'s existing area folders and use the closest fit — the area is the *subsystem the fact is about* (`api`, `db`, `ui`), not the task. Only create a new area when none fits; otherwise the same fact scatters across `api/`, `auth/`, and `security/`. (Read areas the same way: the subsystem you're working in is the subsystem you file under.)
- **Scope `glob:` tightly.** It's a precision *hint* for when a note is relevant — the files the fact bears on — that you use when reading an area to judge whether a note touches the file in front of you. Match only where it applies; a glob covering half the repo guides nothing. (There's no auto-injection hook in v1, so `glob:` informs your judgment rather than firing on its own.)
- **One note, one `when:`.** If you can't write a single honest `when:` — it fires in two different situations — it's two notes; split it.
- **Reconcile before writing** (gate 3): upsert — update in place, don't append a near-duplicate; if a sibling would compete for the same trigger, narrow both `when:` lines so a future agent can tell them apart. Upsert has a counterweight: if an update would make a note answer a second situation or grow past a screenful, split it into siblings with narrowed `when:` lines instead of appending.

Full field reference and examples: `reference/format.md`.

---

## Echo teaches; it doesn't enforce

A note can say "use the logger, never `console.log`" — but a note can't *guarantee* it; it teaches, it doesn't gate. In v1 the only hard gate Echo has is the reflexes pack's **memory-guard** (Echo owns memory — access to the runtime's built-in memory store is denied); the pack is opt-in, so without it there are no gates at all, only teaching. A genuine "must never ship" rule beyond that is captured as strong intel for now; a new hard gate is a deliberate, rare addition, never the default (see `reference/reflexes.md`). Don't write intel as if it were a gate.

---

## Setting up Echo in a project

If there's no `.echo/` yet and the user wants it here:

1. **Ask first**, then create `.echo/project.md`, `.echo/profiles/`, `.echo/intel/`, `.echo/playbooks/`.
2. Seed `project.md` from what you can see (README, structure, stack) — draft it, let the user correct it. Scan for and strip anything secret-shaped before writing.
3. Create their profile in `.echo/profiles/` — a friendly filename with an `email:` front-matter key for matching (format in `reference/format.md`).
4. Commit all of `.echo/` so the team shares it — including project profiles (per-person files don't collide). Only the global `~/.echo/profile.md` stays out of any repo. (No git? Skip this step — single-user mode, below.)

The global `~/.echo/profile.md` isn't part of project setup — it's per-machine, created lazily the first time a preference is promoted to global; its absence just means no global priors yet. **Echo assumes git in v1** (identity from `git config user.email`, sharing via commit) — any git host or a purely local repo; nothing assumes GitHub or a specific forge. With no git at all it still works as single-user local memory — one profile, no team sharing. Migrating an existing **squad** setup (a `.squad/` directory — Echo's predecessor system) is out of scope for v1: there's no importer — offer to port still-true facts into `.echo/` by hand, never silently.

**Optional reflexes pack:** Echo works as-is but leans on you to remember to consult and capture. To make it more reliable, follow [`reference/reflexes.md`](reference/reflexes.md) — small **shell** hooks (no Python, no interpreter to install) that re-invoke `/echo` at session start and after a compaction so you reload memory, **deny access to the runtime's built-in memory store** (Echo owns memory — the one hard gate), and cue the Learn pass on an explicit "remember…" or "echo: …" and before each commit or push. They stay dumb: static nudges, no parsing of your notes — the skill does the reading and judging. Generated into `<project>/.echo/hooks/`, and fail-open (a broken hook never blocks edits). Opt-in — always asks before installing anything that runs code.

**If `.echo/` is incomplete or broken,** degrade gracefully: no `.echo/` → you just have no memory (offer setup, don't nag); a missing file → absent context, not an error; a note with malformed front-matter → mention it once (*"intel/api/auth.md has no `when:` — it won't surface on its own"*) rather than silently relying on it.

---

## Keeping it light

**The always-on files have a budget.** Your profiles and `project.md` are read every session, so bloat there is the expensive kind — every line taxes every future session. Keep each one to roughly a screenful (~30 lines). A save that pushes one past that still saves — but flag the size and offer a trim pass: merge overlapping lines, demote anything that no longer earns always-on cost (a rarely-needed fact belongs in intel). Like pruning, the trim is visible and approved, never silent.

Upsert-don't-append keeps duplicates rare, not impossible — a misjudged "same note?" or a merge that kept both sides can still leave twins. When you happen to notice a note that's gone stale (its anchor no longer resolves) or two notes that overlap, flag it for the user — that's the maintenance, done by you, in passing. Acting on it is an on-request pass: review the changes with the user and let them approve. **Never prune silently or in the background** — removing knowledge is a deliberate, visible act, and Echo writes no maintenance files of its own.

**Forgetting.** When the user says "forget that" / "that's no longer true" / "drop the note about X", treat it as a delete: locate the entry by topic or anchor, remove that note (or just the stale line within it; delete the leaf if it's left empty), and confirm in one line — *"removed: …"*. Git keeps the history, so it's reversible; don't agonize. This is distinct from a *change of mind* mid-task (which captures nothing) — it's an explicit instruction to remove something already saved.

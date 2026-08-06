---
when: creating or editing any .echo file — an intel note, a profile line, project.md, or a playbook body
---
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

### Front-matter fields

| Field | Required | Purpose |
|-------|----------|---------|
| `when:` | yes | One line describing the *situation* this note applies to — how a future session knows to read it. |
| `glob:` | optional | File patterns the fact bears on. A *relevance hint* used when reading an area — not an auto-trigger. |
| `anchor:` | optional | The code or file this fact depends on (`path` or `path:symbol`). A *staleness probe*: an anchor that no longer resolves means verify before trusting. |

**The `when:` line is the craft.** Write it for the *future reader*, not the present moment of capture — describe the situation a later session will be *in* when it needs this (the task, file, or intent), not the symptom you just hit. A vague or over-broad line means the note never surfaces, or cries wolf. If the fact fires on running a specific command or tool, name that command *in* the `when:` — the moment someone types it is a distinct trigger from the situation that taught you, and short obvious-looking commands are exactly where the glance gets skipped.

```
✅ when: handling money amounts or currency conversion   (a moment you can recognize)
✅ when: adding or removing a source file                (a clear intent)
❌ when: the components folder                           (a folder, not a moment)
❌ when: working on the project                          (always true → never useful)
```

- **Deterministic path.** Pick the filename from the *topic*, not the task — auth facts always land in `intel/api/auth.md`, never `auth2.md`. Same fact learned twice → same path → git merges the words instead of leaving rival files.
- **Reuse an area before coining one.** Before filing, list `intel/`'s existing area folders and use the closest fit — the area is the *subsystem the fact is about* (`api`, `db`, `ui`), not the task. Only create a new area when none fits; otherwise the same fact scatters across `api/`, `auth/`, and `security/`. A subsystem is never a language, framework, or tech name: in a single-stack repo `swift/` or `react/` is the closest fit for *everything*, so it attracts every note and stops discriminating — a technology name is right only for facts about the technology itself (how the language behaves, not what the app does with it). **Reuse means related, not nearby**: file into an area only if the fact shares that area's *subsystem* — dropping a note into an area whose other notes have nothing in common with it except the project is how junk drawers start; coin the honest area instead. (Read areas the same way: the subsystem you're working in is the subsystem you file under.)
- **Scope `glob:` tightly.** It's a precision *hint* for when a note is relevant — the files the fact bears on — that you use when reading an area to judge whether a note touches the file in front of you. Match only where it applies; a glob covering half the repo guides nothing. (No hook auto-injects notes, so `glob:` informs your judgment rather than firing on its own.)
- **One note, one `when:`.** If you can't write a single honest `when:` — it fires in two different situations — it's two notes; split it.
- **A note outlives its session — save the invariant, strip the residue.** State the rule, not the incident that taught it ("these copies never diverge — whoever changes one syncs the rest", not the one recovery you ran; an incident-shaped note misses the same failure arriving from the other direction). Mark deliberate decisions ("intentional — don't revert"), but drop names and dates (git blame carries who and when) and anything the code already answers. This governs every Echo line, not just intel — a profile bullet states the preference, never the code-review story that taught it.
- **Assert only what you traced.** A note ships to teammates in the same commit as the code — hold its claims to the code's bar. A claim stated flatly is one you followed to its ground: the file and line, the command you ran, the user's own words. A consequence you observed grounds only the consequence — *why* something behaves as it does is known by tracing it, never by watching it, and a wrong mechanism under a right consequence passes every casual check (grep hits on part of a subsystem are not the subsystem). What you believe but didn't trace is cut, or marked tentative in the sentence itself ("seems", "likely", "unverified —") — the marker costs a word and keeps the note honest; a later session can firm it up. Universal and negative claims ("the only", "always", "never", "nothing else") assert an enumeration: write one only after actually enumerating, and say how ("every case in `AppCoordinator.Destination`"). `anchor:` vouches for the note's one idea; a claim that needs its own separate ground names it inline (`path` or `path:symbol`) — and two claims needing two grounds is a hint it's two notes.
- **Small, factual, current.** A note is a few lines of present-tense fact — most are 3–8 lines; a screenful is the ceiling, not the norm. No narrative, no running history: when new truth arrives, **replace the stale lines, don't append around them** — git is the archive, so deleting outdated content is safe and required. A note that reads like a changelog of what used to be true has failed its update.
- **Reconcile before writing** (Learn gate 3): upsert — update in place, don't append a near-duplicate; if a sibling would compete for the same trigger, narrow both `when:` lines so a future agent can tell them apart. Upsert has a counterweight: if an update would make a note answer a second situation or grow past a screenful, split it into siblings with narrowed `when:` lines instead of appending. The `when:` is part of every edit: content addressed to a reader the current trigger won't summon either widens the `when:` or forces the split — a note that outgrows its trigger is invisible exactly when it's needed.
- **One home per fact, pointers between homes.** A capture that falls inside content already filed anywhere — a playbook's steps, another note's fact, a profile line, or one of the skill's own notes — is written as a *pointer* to that home plus the delta (a waiver, an exception, a local adaptation), never a paraphrase; a stripped summary answers confidently and wrongly. Pointers have a direction: a shared file never points into a profile — no one else's session loads it; a project-true fact sitting in a profile bullet is a misfiled line, and that's a **move** (`core/routing.md`), not a pointer. A pointer names its target by path (`intel/api/auth.md`, never just "the auth note"): leaf names repeat across areas, so an unqualified name is ambiguous the day a second area coins the same topic.

### The intel tree

Areas are shallow folders grouping related notes — one level is usually enough. An area earns a
folder when it has a few related notes; until then a note can sit one level up (`intel/styling.md`).
There is no index file: the directory listing plus the `when:` lines *are* the index. The tree is
kept honest in both directions: a note with no related siblings doesn't get a folder of one, and an
area whose notes stop sharing a subsystem gets split — unrelated notes bunched under one name make
that name useless as an index entry.

```
.echo/intel/
  api/        auth.md   routes.md   rate-limits.md
  db/         migrations.md   queries.md
  ui/         components.md   styling.md
```

**No enforcement fields.** Front-matter carries no `block:` or the like — nothing in a note blocks
anything. A "must never ship" rule is captured as strong intel (the note teaches it); the only hard
gate anywhere is the memory-guard (`core/reflexes.md`).

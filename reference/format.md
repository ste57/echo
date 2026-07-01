# Echo file formats

Concrete shapes for every Echo file, with examples. SKILL.md governs *when* to read/write these;
this is *what* they look like. Read it when you're about to create or edit an Echo file.

---

## Global profile — `~/.echo/profile.md`

How you work, everywhere. Always-on. Never in any repo. Plain bullets, no front-matter.

```markdown
# Profile

- Decisive: give me the answer and your reasoning, not a menu of options.
- Functional style over classes where the language allows.
- No Co-Authored-By trailers in commits.
- Keep explanations short unless I ask you to go deep.
```

Keep it to priors — how you like to work — not project facts. If a line only makes sense in one
repo, it belongs in a project profile, not here.

---

## Project profile — `.echo/profiles/<you>.md`

How you work *in this project*. One file per developer, named from a **slug of their `git config
user.email`** — the stable identity that matches the same person on every machine. **Slug rule:**
lowercase the email, replace every character that isn't `a-z`, `0-9`, or `-` with `-`, collapse runs
of `-`, and trim leading/trailing `-`. Example: `Alex.Kim@acme.io` → `.echo/profiles/alex-kim-acme-io.md`.
(If `git config user.email` is unset, ask the user how to identify their profile. Non-interactive
with git → slug of `git config user.name`; no git at all → `local` (single-user mode has one
profile anyway). Never create an empty-named `.md`.)
Committed to git; per-person, so two developers never edit the same file. The global profile
underlies it — on conflict, the project line wins (it's more specific). No front-matter needed.

```markdown
- PR descriptions: 3 bullets max, no test plans.
- Run the test suite before asking me to review.
- I dislike barrel files (re-export index.ts); import direct.
```

---

## Project facts — `.echo/project.md`

What the project *is*: stack, structure, domain. Stable — changes rarely. Read every session, so
keep it tight. No front-matter needed.

```markdown
# Harbor

Team project-management SaaS. Next.js 15 (App Router) + TypeScript + Postgres (Drizzle).
Monorepo: apps/web, apps/api, packages/ui, packages/db.
Auth via Clerk. Deployed on Vercel.

Domain: a "board" has many "lanes"; a "card" lives in one lane and has an assignee.
Say "card", never "ticket" or "task" — the UI and codebase use "card" throughout.
```

---

## Intel note (leaf) — `.echo/intel/<area>/<note>.md`

One discovered fact or gotcha, scoped by front-matter. Small — one idea per note. The body is
the knowledge; the front-matter is how it gets found.

```markdown
---
when: writing or editing auth / protected endpoints
glob: ["apps/api/**/route.ts", "**/middleware.ts"]
anchor: apps/api/src/auth/clerk.ts
---
Protected routes call `requireUser()` from auth/clerk.ts, never read the session directly.

Gotcha: Clerk middleware runs before route handlers, so `auth()` returns null in server
actions unless the path is in the matcher config. Add new protected paths to middleware.ts.
```

### Front-matter fields

| Field | Required | Purpose |
|-------|----------|---------|
| `when:` | yes | One line describing the *situation* this note applies to. How a future agent knows to read it. |
| `glob:` | optional | File patterns the fact bears on. A *relevance hint* you use when reading an area — not an auto-trigger (v1 has no injection hook). |
| `anchor:` | optional | The code this fact depends on (`path` or `path:symbol`). A *staleness probe*: when you read a note whose anchor no longer resolves, don't trust it — verify against current code and offer to update or retire it. |

### The `when:` line is the craft

It must describe the **situation**, not the folder — written for the *future reader*, not the
moment of capture. You're saving this after a struggle; the line must match what a later session
will be *doing* when it needs this, not the symptom you just saw. Derive it from whichever handle
fits: the **task** ("handling money amounts"), the **artifact** ("editing a `*.test.ts`"), or the
**intent** ("about to commit", "adding a source file"). If you can't name a future moment it'll
resurface, the note has no reliable trigger — reconsider saving it.

```
✅ when: writing color or styling code (any view)
✅ when: adding or removing a source file (build needs regenerating)
✅ when: handling money amounts or currency conversion
❌ when: the date test failed       (a past symptom, not a future moment)
❌ when: the components folder      (a folder, not a moment)
❌ when: working on the project      (always true = never useful)
```

**Scope `glob:` as tightly as the fact applies.** It's a relevance hint, not a trigger (v1 has no
auto-injection hook) — a glob covering half the repo guides nothing. **One note, one `when:`** — if you need "and" to
describe when it fires, it's two notes; split it. **Deterministic path** — name the file from the
topic, not the moment (`auth.md`, not `auth2.md`), so the same fact learned twice lands at the same
path and merges cleanly instead of forking.

### Enforcement

v1 ships exactly one hard gate: the reflexes pack's **memory-guard** (Echo owns memory — see
`reference/reflexes.md`). It's a pack hook, not anything in a note — **front-matter carries no
enforcement field (no `block:` or the like); nothing in a note blocks anything.** A "must never ship" rule beyond memory
ownership is captured as **strong intel** (the note teaches it); a real hard gate is a deliberate,
rare future addition, never the default. Every gate is weight; priors are the rule.

---

## Playbook — `.echo/playbooks/<name>.md`

A named workflow, run on request. Read only when the user says its trigger phrase. The body is
the steps. A playbook's front-matter is just `when:` — and here it's a literal trigger phrase, not
a situation; `glob:`/`anchor:` don't apply.

```markdown
---
when: user says "ship it" / "ship this"
---
1. Run `pnpm test && pnpm typecheck`. Stop if either fails.
2. Write a conventional-commit message.
3. Push the branch, open a PR with a 3-bullet description.
4. Put the Linear ticket id in the PR title.
```

---

## The intel tree

Areas are shallow folders grouping related notes. Don't over-nest — one level is usually enough.

```
.echo/intel/
  api/        auth.md   routes.md   rate-limits.md
  db/         migrations.md   queries.md
  ui/         components.md   styling.md
  build/      tooling.md
  git/        conventions.md          ← with the reflexes pack, the commit cue points here
```

An area earns a folder when it has a few related notes. Until then a note can sit one level up
(`intel/styling.md`). There is no index file — the directory listing *is* the index: you read the
front-matter of the notes in an area when you first touch that area, never the whole tree.

---

## Writing: upsert, don't append

Before adding a note, look for an existing one on the same topic (same area, similar `when:`):

- **None exists** → create the note.
- **One exists and you're adding detail** → edit it in place. Don't create a near-duplicate.
- **One exists and your fact contradicts it** → don't silently overwrite. Surface it to the user:
  *"intel/api/auth.md says X; this suggests Y — replace it?"*
- **A teammate's note (or a merge conflict) clashes with yours** → never last-writer-wins. Run
  `git blame` on the leaf to see who wrote the standing line and when, surface both versions, and let
  the user choose or merge.

This keeps duplicates *rare*, not impossible — a misjudged "is this the same note?" or a merge that
kept both sides can still leave twins, so pruning still exists as an on-request pass (SKILL.md,
"Keeping it light"); upsert just keeps it infrequent.

**Never write secrets** — credentials, tokens, internal hostnames/IPs, customer data — into any
`.echo/` file. Everything here is committed to git and lives in history forever. Capture the *shape*
of a secret-dependent gotcha ("needs an internal auth header — get it from the vault"), never the
value.

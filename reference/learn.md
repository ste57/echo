# Echo Learn — worked examples

SKILL.md has the Learn decision logic — the knowledge signals, the two-question judge, and the
procedures path (workflows → playbooks). This file shows them *in action* so the behavior is
concrete. Read it if you're unsure how a real moment turns into a saved note or playbook — or
whether it should at all.

The golden rule: **default to doing nothing.** Most exchanges are not learning moments. A note is
worth its weight only if a future session would get something wrong without it.

---

## Signal 1 — the user corrects you

> **User:** No, don't put helper functions in the component file. We keep them in a separate
> `*.utils.ts` next to the component.

This is an explicit correction about a durable convention. Both judge questions pass (the next
session would repeat the mistake; it's true next week). You're sure, so save quietly.

**→ writes `.echo/intel/ui/file-layout.md`:**
```markdown
---
when: adding helper functions for a component
glob: [**/components/**]
---
Component helpers go in a sibling `*.utils.ts`, not inside the component file.
```
> *(noted: component helpers live in a sibling .utils.ts)*

**Counter-example — not every correction is durable:**
> **User:** Actually, don't rename that variable right now.

That's a one-off instruction for this task, not a rule. Judge question 2 fails (not true next
week). Do nothing.

---

## Signal 2 — a gotcha gets solved

You spend three attempts getting a test to pass; it finally works once you set a timezone env var.

This is the highest-value intel — a trap that cost real time. Save it, anchored to the cause.

**→ writes `.echo/intel/build/testing.md`:**
```markdown
---
when: running or writing tests that touch dates/times
glob: [**/*.test.ts]
anchor: vitest.config.ts
---
Tests assume UTC. Without `TZ=UTC` the date tests fail locally (they pass in CI, which is UTC).
The test script sets it; if you run vitest directly, export `TZ=UTC` first.
```

The signal here is *struggle that resolved* — "I tried X, it failed, Y worked." That sequence is
your cue, even though the user never said "remember this."

**Causality check first.** Before saving a solved-gotcha, ask: did I *confirm* this was the cause,
or just the last thing I changed before it worked? Post-hoc isn't proof. If you didn't isolate it,
save it as tentative ("*seemed* to fix X") or don't save it. Coincidence is the enemy of good intel.

---

## Signal 3 — the user teaches you directly

> **User:** Remember: we never call the payments API directly from the web app, always through
> the `billing` service.

Explicit teach — highest trust. Save immediately, no deliberation, no asking.

**→ writes `.echo/intel/api/payments.md`:**
```markdown
---
when: calling payments / billing from the web app
glob: [apps/web/**]
anchor: packages/billing
---
Never call the payments API directly from apps/web. Go through the `billing` service.
```
> *(noted: payments go through the billing service)*

---

## Signal 4 — the user states a preference

> **User:** I like commit messages short — one line, no body.

This is about *you*, not the project — it goes to your profile, not intel. The user stated it out
loud, so it's a *sure* save (like a teach): save it with a one-line confirm.

**→ updates `.echo/profiles/<you>.md`:**
```markdown
- Commit messages: one line, no body.
```

If it reads as an identity-level habit true everywhere ("I always want short commits, everywhere"),
offer — once, non-blocking — to *also* add it to your **global** profile. Save it project-scoped now
regardless; it lands in global only on a yes (declined or ignored → stays project-scoped, don't re-offer).

---

## Signal 2b — a gotcha you *inferred* (don't interrupt)

You notice every migration in the diff was hand-edited and one broke; you infer migrations are
meant to be generated, not written by hand. The user never said so.

This passes the judge, but you *inferred* it — so don't stop the work to ask. Hold it and raise it
at the next natural stop (before the commit), batched. Showing restraint here matters: mid-task
interruptions are exactly what makes a developer turn Echo off.

---

## Recognizing a must-fire (be honest about what's enforced)

> **User:** We never, ever commit `console.log` to source. That can't slip through.

This is an explicit teach carrying a non-negotiable (Signal 3) — it passes the gates like any teach;
what's special is honesty about *enforcement*, not the capture decision. A note *teaches* it but can't
*guarantee* it. Be honest about the limit: v1's only hard gate is memory ownership (the reflexes
memory-guard); there is no per-rule blocking. So capture this as **strong, specific intel** and say
what Echo can't do:

> *"Saved that as intel so it's in front of you when editing source. For honesty: Echo v1 doesn't
> hard-*block* arbitrary rules like this — only writes to the built-in memory store are gated. If it
> must be machine-enforced, a lint rule or a pre-commit check in the repo is the right tool."*

Don't imply a note is a guarantee, and don't invent a gate Echo doesn't have. Route a true
must-never to real tooling (linter/CI); let the note carry the teaching. See `reference/reflexes.md`.

---

## Procedures — a workflow becomes a playbook

A playbook is different in kind from the four signals: not a fact to recall, a *sequence to rerun
on request*. You're never told to remember one — you notice it, so you always **offer, never save
silently.** Two cues surface one: the user **names a routine**, or you **just ran a multi-step
sequence** this task they might rerun. (You can't see a workflow you ran in a past session — don't
pretend to; lean on these in-the-moment cues.)

Earlier this task you cut a release: ran the tests, bumped the version, tagged, pushed. Now the user
says "ok, do the hotfix release too" and you run the same four steps. That's the cue — a multi-step
routine treated as one thing. Draft it from what actually ran, show it, let them edit and name it:

> *"That's a routine I could save — want `release` to replay it? Correct the steps first:"*
> ```markdown
> ---
> when: user says "release" / "cut a release"
> ---
> 1. Run the test suite. Stop if it fails.
> 2. Bump the version (patch unless told otherwise).
> 3. Tag `v<version>` and push the tag.
> 4. Push the branch.
> ```

Saves to `.echo/playbooks/release.md` only on a yes. Because you inferred it, it **always asks** —
never a silent save, even when you're sure of the steps.

**Never auto-suggest a destructive workflow.** If the sequence force-pushes, deletes, deploys beyond
local, touches credentials, or migrates a shared DB, don't offer a playbook that runs it — capture
the *shape* as intel ("release force-pushes the tag — run it by hand") and stop.

**Counter-example — a one-off isn't a playbook.** You once stashed, pulled main, rebased, and popped
the stash to untangle a branch. Clever, but done once for this mess, no nameable trigger → do nothing.

---

## When to ask vs save silently

- **Sure** (explicit teach, clear correction) → save quietly with a one-line note.
- **Inferred** (a preference you picked up, a gotcha you noticed) → don't interrupt mid-task.
  Surface it at a natural stop: *"I picked up two things worth remembering — keep them?"*

```
> Before I commit — I noticed two things worth saving:
>   1. (intel) Drizzle migrations must be generated with `pnpm db:generate`, not hand-written.
>   2. (your profile) You prefer I run the linter before showing a diff.
> Want both kept?
```

Batch them. One question at a breakpoint beats five interruptions.

---

## Reconcile before writing

Always check what's already there for the topic:

> **User:** Auth check should use `requireUser()`.
>
> You find `.echo/intel/api/auth.md` already says exactly this → **do nothing**, it's covered.

> **User:** Actually we switched from Clerk to Auth.js; `requireUser()` is gone, use `getSession()`.
>
> The existing note now contradicts reality → **don't silently overwrite.** Surface it:
> *"intel/api/auth.md still says use requireUser() (Clerk). Replace it with the Auth.js
> getSession() approach?"* — then update on confirmation.

---

## Forgetting — an explicit delete

> **User:** Forget that we deploy from the release branch — that's not true anymore.

Not a capture, and not a change-of-mind: an explicit instruction to remove something already saved.
Locate the note by topic or anchor (`intel/git/…`), delete the stale line — or the whole leaf if that
empties it — and confirm in one line: *"removed: deploy-from-release note."* Git keeps the history, so
it's reversible. (See SKILL.md "Keeping it light" for the rule.)

---

## What is NOT a learning moment

- A question ("how does auth work here?") — you answered it; nothing durable changed.
- The user changing their mind mid-task ("actually, do it the other way") — situational.
- Normal iteration and back-and-forth — that's just work.
- You being wrong once about something incidental — not a pattern.

If you're tempted to save after one of these, stop. Over-capture is the failure that killed the
predecessor system: notes nobody reads, drowning the ones that matter.

**Literalness check.** Capture only what the user would endorse if you read it back to them verbatim
next month. If a "correction" might be venting, sarcasm, or a joke ("oh great, so we just never
write tests here"), confirm before saving — never enshrine tone as policy.

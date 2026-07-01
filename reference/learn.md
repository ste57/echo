# Echo Learn — reasoning at the edges

SKILL.md carries the Learn rule: the signals, the judge (gate 2's two questions), reconcile, and the
procedures path. This file is for the **boundaries** — the moments where that rule is easy to
misapply. Read it when you're unsure how a Learn call should go — whether to save, where, or how to
handle a delete.

**Use these as reasoning, not as templates.** Don't match a new situation to the nearest case here and
copy its outcome — apply the *rule* to what's actually in front of you. The value below is in *why*
each call goes the way it does, especially the ones that resolve to **do nothing**.

The golden rule: **default to doing nothing.** Most exchanges aren't learning moments; a note earns
its place only if a future session would get something wrong without it.

---

## Correction — durable rule vs one-off

An explicit correction is a signal *only if it's durable*. "We keep helpers in a sibling `*.utils.ts`,
not the component file" passes both judge questions — the next session would repeat the mistake, and
it's still true next week — so save it and say so in one line (an intel note in the area it's about).

The boundary is durability, not the word "no":

> **User:** Actually, don't rename that variable right now.

Looks like a correction; it's a one-off for this task. Judge Q2 fails (not true next week) → **do
nothing.** The test isn't "did they correct me," it's "is this a rule that outlives the task."

---

## Solved gotcha — highest value, easiest to fake

"I tried X, it failed, Y worked" is your cue even though no one said "remember." A trap that cost real
time — tests that silently assume UTC, a build step that must run first — is the best intel there is;
save it with its `anchor:` pointing at the causing code.

The boundary is **causality**: did you *confirm* Y was the cause, or was it just the last thing you
changed before it worked? Post-hoc isn't proof. If you didn't isolate it, save it tentative
("*seemed* to fix…") or not at all. A coincidence saved as fact is worse than no note.

---

## Explicit teach — highest trust, save now

A direct teach ("Remember: always go through the billing service, never call payments directly") is
the highest-trust signal — the gates pass almost instantly (the user just asserted the durability
themselves), so it saves right away with a one-line note. This one lands in intel because it's about
the project; a teach about *you* ("remember, I hate mocks") goes to your profile instead. Two things
still stop a teach: gate 3 — it *contradicts* a filed note, so confirm before overwriting — and the
secrets rule — never save a credential verbatim, capture the shape.

---

## Stated preference — about you, saved now

A preference said out loud ("I like one-line commit messages") is also a *sure* save — but into **your
profile**, not intel, because it's about you, not the project. Save it, tell them in one line, done.

The boundary is *whose fact it is*: "we always squash-merge" sounds like a preference but is
project-true — that's intel, never a profile line.

If it's clearly an identity-level habit true *everywhere* ("I never add co-author lines"), offer —
once, non-blocking — to also add it to your **global** profile. Save it project-scoped regardless; it
reaches global only on a yes.

---

## Inferred, not stated — propose at a stop, don't interrupt

Sometimes the signal is something you *noticed*, not something said: the migrations in the diff were
clearly hand-edited, and the one that broke failed exactly where the generator would have filled in
the boilerplate — so you infer migrations here are meant to be generated, not written by hand. It
passes the judge — but you inferred it, so **don't stop the work to ask.** Hold it and **propose** it,
batched, at the next natural stop (before a commit); it saves on a yes, not before. Mid-task
interruptions are exactly what make someone turn Echo off.

That's the sure-vs-inferred split: a stated teach or preference — or a gotcha whose cause you
confirmed — saves now; an inferred note is only ever proposed — and a batch held in session memory is lost at a compaction, so propose it before a
long gap rather than banking on later.

---

## A non-negotiable rule — capture the teaching, be honest about enforcement

"We never commit `console.log` to source — that can't slip" is an explicit teach carrying a
non-negotiable. It passes the gates like any teach; what's special is honesty about *enforcement*. A
note *teaches* but can't *guarantee*. v1's only hard gate is memory ownership (the reflexes
memory-guard) — there is no per-rule blocking. So save it as strong, specific intel and say the limit
out loud: if it must be machine-enforced, a lint rule or a pre-commit check in the repo is the right
tool. Don't imply a note is a gate, and don't invent one Echo doesn't have.

---

## Procedures (playbooks) — always offer, never save silently

A playbook is a different kind of thing: not a fact to recall, a *sequence to rerun on request*.
Even when the user names the routine outright, saving goes through an offer — you **always offer,
never save silently**, even when sure of the steps. Two cues surface one: the user names a routine, or you just ran a multi-step
sequence they might rerun. (You can't spot a workflow from a past session — don't pretend to.)

Draft the steps from what actually ran, strip anything situational and any auto-confirm flags, show it,
let them edit and name it; save only on a yes.

Two hard boundaries:
- **Never auto-suggest a destructive workflow.** If it force-pushes, deletes, deploys beyond local,
  touches credentials, or migrates shared data, don't offer a playbook that runs it — capture the
  *shape* as intel ("release force-pushes the tag — run it by hand") and stop. Stripping a `--force`
  flag never rescues a barred workflow; the bar is on the step, not the flag. (An *explicit user
  request* for such a playbook is different — build it, but write the dangerous step as "confirm
  with the user, then run …", never bare.)
- **A one-off isn't a playbook.** A clever one-time untangle (stash, rebase, pop the stash) with no
  nameable trigger → do nothing.

---

## Reconcile before writing

Always check what's already filed for the topic first:
- It already says this → **do nothing**, it's covered.
- It's *similar but yours adds detail* → **update the note in place**; never append a near-duplicate
  sibling.
- Your fact *contradicts* it → **don't silently overwrite.** Surface both ("the note says X; this
  suggests Y — replace it?") and update only on confirmation; on a no, leave it standing and don't
  re-ask this session. A teammate's note or a merge conflict is the same case: check its history (`git blame`; `git log --merge -p` during a conflict),
  show both versions, let the user choose or merge.

---

## Forgetting — an explicit delete

"Forget that — it's not true anymore" isn't a capture and isn't a change-of-mind; it's an instruction
to remove something already saved. Locate the note by topic or anchor, delete the stale line (or the
whole leaf, if that empties it), and confirm in one line. Git keeps the history, so it's reversible.

---

## Not a learning moment

The calls that should resolve to **do nothing** — this is where over-capture creeps in:
- A **question** you answered — nothing durable changed.
- A **one-off change of mind** mid-task ("actually, do it the other way") — it enters as a
  correction but dies at the judge: situational, not durable.
- Normal **iteration** and back-and-forth — that's just work.
- Being **wrong once** about something incidental — not a pattern. (A *confirmed-cause* gotcha that
  cost real time is the exception — that's the solved-gotcha signal, not incidental wrongness.)
- **Tone, not policy.** If a "correction" might be venting, sarcasm, or a joke ("oh great, so we just
  never write tests here"), confirm before saving — never enshrine tone as a rule. Capture only what
  the user would endorse if you read it back to them verbatim next month.

---
when: the user names a repeatable routine, or you just ran a multi-step sequence they might rerun by name
---
A playbook is always **offered, never silently saved** — even when the user names the routine outright, they get a draft to edit, not a silent write. (You can't reliably spot a workflow repeated in a *past* session — don't try; lean on the in-the-moment cues in this note's `when:`.) Before offering:

- **Worth it?** A stable, nameable routine of several steps the user treats as one thing — not a one-off, a single command, or something trivially re-derived. Unsure → it isn't one.
- **Safe to suggest?** **Never** offer a workflow whose steps delete, force-push, deploy beyond local, touch credentials, or migrate shared data — capture the *shape* as intel ("release runs `make deploy` — do it by hand"), never a playbook that runs it. If the user *explicitly asks* for such a playbook anyway, build it their way — but write the dangerous step as "confirm with the user, then run …". You never strip that confirmation; only the person being served can waive it, and the step then records the waiver **and who granted it** — the request is the authorization *for that person*. Anyone else triggering the playbook gets the confirm step; their own explicit go extends the recorded waiver to them.
- **Draft, show, confirm.** Rebuild the steps from what actually ran, drop anything situational, strip auto-confirm flags (`--force`/`--yes`; stripping a flag never rescues a workflow the safety bar barred), and show the draft for the user to edit and name. Saves only on a yes; raise it batched at a breakpoint, never mid-task; if declined, don't re-offer.

**The shape** — front-matter is just `when:`, and here it's a literal trigger phrase, not a
situation; `glob:`/`anchor:` don't apply. The body is the steps:

```markdown
---
when: user says "ship it" / "ship this"
---
1. Run `pnpm test && pnpm typecheck`. Stop if either fails.
2. Write a conventional-commit message.
3. Push the branch, open a PR with a 3-bullet description.
```

If a single teach carries *both* a repeatable sequence and a durable fact, split it: the steps → a playbook, the fact → intel, and the playbook *references* the fact rather than restating it, so the fact keeps one home.

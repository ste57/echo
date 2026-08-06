---
when: creating or editing a profile (global or project), or matching a person to theirs
---
**Global — `~/.echo/profile.md`.** How you work, everywhere. Always-on, per-machine, never in any
repo. Plain bullets, no front-matter. Keep it to priors — how you like to work — not project facts;
if a line only makes sense in one project, it belongs in that project's profile, not here.

**Project — `.echo/profiles/<name>.md`.** How you work *in this project*. One file per person. The
**filename is friendly** — default to the local part of the email (`alex.kim@acme.io` →
`alex-kim.md`); the **matching key is the `email:` front-matter field**, checked against
`git config user.email` (case-insensitive) — the stable identity that matches the same person on
every machine.

```markdown
---
email: alex.kim@acme.io
---
- PR descriptions: 3 bullets max, no test plans.
- Run the test suite before asking me to review.
```

**Finding yours:** list `.echo/profiles/`, match each file's `email:` against your
`git config user.email`. No match → you're new here: create yours as part of Sync (filename from
the email's local part, `email:` front-matter, empty body). A profile missing its `email:` can't be
matched — flag it once. **Names must be unique** — if the name you want is taken, qualify it
(`alex-k.md`); two people never share a file. (If `git config user.email` is unset, ask the user
how to identify their profile. Non-interactive with git → `git config user.name`; no git at all →
`local.md`, no `email:` needed — single-user mode has one profile anyway. Never create an
empty-named `.md`.)

Committed to git. The global profile underlies it — on conflict, the project line wins (it's more
specific). Preferences route between the two by subject: `base/routing.md`.

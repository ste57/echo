---
when: about to spawn a subagent in an Echo project, or reading one's report back
---
A spawned agent never invoked `/echo` and loads none of this, so delegation is two-way. Going in: copy the relevant context — the profile lines and intel notes that bear on the task — into its prompt; the knowledge doesn't follow it automatically. Coming back: the subagent can't learn (it never sees the user and doesn't know the protocol), so its report is *your* capture point — a solved gotcha in there is a Learn signal, run the pass on it. (With the reflexes pack installed this is enforced: the memory-guard denies a subagent's writes into `.echo/` outright.)

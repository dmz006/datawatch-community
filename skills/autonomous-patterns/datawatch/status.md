# status

Give a ten-line brief, then stop and offer the next step.

1. **Week against the line.** From `burn_guard_status` and `usage_advice`: the week's use against the pace line, the burn rate against what is allowed, and whether the projected finish is over or under. Say when the next reset is.
2. **Pools.** From `capacity_status`: each pool and node, in use against its limit. If the ledger shows a pool free while sessions are live, say the ledger is understating.
3. **Running.** How many Automata run, the one or two most important by title, and any task session that has run two hours or more.
4. **Finished or failed.** What completed since the last review and what failed, by title, with the one-line reason.
5. **Holds.** The count of held and parked items and how many are over a day old (see `holds.md`).
6. **Services, then doer and watcher.** First, is each datawatch service running at all, apart from what it found: the detector and watch-record schedules (pending, last fire, starts failed in a row) and the detector heartbeat. A session's status is not the service's status: a watch that ran and found problems is a healthy service reporting an unhealthy datawatch. Put a service that is not scheduled, has not fired within three times its cadence, or keeps failing to start at the top of the whole brief and say so first; nothing else is checked while it is down. Then the watch's findings (result `watch-latest`: count and the top few), when the doer and watcher last ran, what they did, and whether anything is waiting on a question.
7. **Unlanded work.** The count of archived or finished work not on the default branch, and the oldest.
8. **What needs the operator.** The open questions that only they can answer, most urgent first.
9. **Faults.** Anything the notes mark as a known fault that appears again.
10. **Next.** The single next step you recommend.

End by asking whether to start with the first question (`questions.md`).

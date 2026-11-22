# status

Give a ten-line brief, then stop and offer the next step. Read the status brief first (`datawatch result get status-brief`); every item below is in it. Open a detail only when the brief points at one, and never call the capacity, Automata or schedule listings unfiltered (see the cost principle).

1. **Usage, the plan's own way.** From the brief's USAGE block: the week percent and its age (say when it is stale), the window percent against the 85% pause line, the pace line and how far ahead or behind, the burn since the last reading against the allowed burn, and the catch-up table (how many hours at no new Claude burn, at the idle baseline, or at 1, 2 or 3 lanes until usage is back on the line). Give API-equivalent dollars beside the points (the brief calibrates dollars per point from this week); dollars are not a bill.
2. **Pools.** From the brief (never `capacity_status` unfiltered, about 65,000 tokens): each pool and node, in use against its limit. If the ledger shows a pool free while sessions are live, say the ledger is understating.
3. **Running.** How many Automata run, the one or two most important by title, and any task session that has run two hours or more.
4. **Finished or failed.** What completed since the last review and what failed, by title, with the one-line reason.
5. **Holds.** The count of held and parked items and how many are over a day old (see `holds.md`).
6. **Services, then doer and watcher.** First, is each datawatch service running at all, apart from what it found: the detector and watch-record schedules (pending, last fire, starts failed in a row) and the detector heartbeat. A session's status is not the service's status: a watch that ran and found problems is a healthy service reporting an unhealthy datawatch. Put a service that is not scheduled, has not fired within three times its cadence, or keeps failing to start at the top of the whole brief and say so first; nothing else is checked while it is down. Then the watch's findings (result `watch-latest`: count and the top few), when the doer and watcher last ran, what they did, and whether anything is waiting on a question.
7. **Unlanded work.** The count of archived or finished work not on the default branch, and the oldest.
8. **What needs the operator.** The open questions that only they can answer, most urgent first.
9. **Faults.** Anything the notes mark as a known fault that appears again.
10. **Next.** The single next step you recommend.

End by asking whether to start with the first question (`questions.md`).

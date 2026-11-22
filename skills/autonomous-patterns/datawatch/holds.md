# holds

List every parked, stuck or held item, oldest first, so nothing sits for days.

1. Gather: the brief's holds section (oldest first, with age and whether a question covers it) and `datawatch autonomous held` (about 1,000 tokens). For the first ten items only, read that Automaton's tasks with `autonomous_prd_tasks` (about 1,300 each) and take the oldest held task's last update as the hold's start. Never the attention list (about 25,000 tokens) or the Automata list (about 53,000).
2. For each item give: the Automaton title, how long it has been held, what it is for in a few words, why it is held (read the failure or gate report and the attempts, not only the status), and whether an open question covers it.
3. Mark anything held more than a day. Mark anything with no open question.
4. Sort oldest first. Show the first ten and the count of the rest.
5. For each marked item, name the next action that follows the rules (escalate to a stronger worker, re-run only the check, fix the check's missing input, land it) and say whether it needs the operator.
6. Ask which item to take first and move to `questions.md` for any that need an answer.

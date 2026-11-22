# questions

Walk the open operator questions one at a time, including missing-recipe questions.

1. List them with the command line, `datawatch question list` (about 1,300 tokens; the MCP `question_list` is about 30,000). Count them: that is Y. Group duplicates (the same Automaton and the same pattern) and offer to withdraw a duplicate of a question the operator already answered, with the reason recorded.
2. Order by urgency: anything that could run the wrong model or cause harm first, then the oldest hold, then the rest. Missing-recipe questions start with "RECIPE NEEDED" and name a pattern; treat the answer as a rule for every item with that pattern.
3. For question X of Y read the facts first (see the skill's question rules), scoped to that question's Automaton: its tasks with `autonomous_prd_tasks` and the failure or gate report, not a full read of the Automaton (about 42,000 tokens), then show the question in this shape: title, what happened, the question restated, the options with what each does and costs, the recommended option and why, and what is unverified.
4. Wait. Record the operator's words verbatim with `datawatch question answer <id> --option <option id> --text "<words>"`. If they chose no option, record text only. Say what the answer will do next, and what you did not do.
5. If the answer sets a rule (a pattern, a limit, a model choice), say so and offer to record it in memory and in the plan so the doer and watcher follow it.
6. Move to X plus one. At the end say how many were answered, how many remain and what is now unblocked.

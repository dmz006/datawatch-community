# plan

Give the operator the plan roll-up for one project and what should happen next.

1. Find the project's plans: `plan_record_list` and `plan_record_search` for the project, and `autonomous_prd_list` for its Automata. Group Automata by the plan they belong to.
2. For each plan, in order: its goal, how far along it is, the Automaton that is next, and what blocks it. Name Automata by title.
3. Mark work that is done but not landed, work that waits on the operator, and work that is parked.
4. Name anything that overlaps another plan, so work is not done twice. Before you suggest new work, search for an existing Automaton, an archived branch or a plan record that already covers it (`autonomous_overlap_search`).
5. Finish with the next three steps in order, each one sentence, and ask which to start. Do not start anything.

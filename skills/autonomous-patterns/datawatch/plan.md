# plan

Give the operator the plan roll-up for one project and what should happen next.

1. Find the project's plans by title: `plan_record_list` with a limit of 10 and the state `planned` (about 5,000 tokens, because each record carries its whole body; open one record in full only when you discuss it) or `plan_record_search` for the topic. For the Automata use the brief and `datawatch autonomous progress` (about 1,500 tokens), never `autonomous_prd_list` (about 53,000) or the MCP progress tool (about 84,000). Read one Automaton's tasks with `autonomous_prd_tasks` (about 1,300), not a full read (about 42,000), unless you need its spec. Group Automata by the plan they belong to.
2. For each plan, in order: its goal, how far along it is, the Automaton that is next, and what blocks it. Name Automata by title.
3. Mark work that is done but not landed, work that waits on the operator, and work that is parked.
4. Name anything that overlaps another plan, so work is not done twice. Before you suggest new work, search for an existing Automaton, an archived branch or a plan record that already covers it (`autonomous_overlap_search`).
5. Finish with the next three steps in order, each one sentence, and ask which to start. Do not start anything.

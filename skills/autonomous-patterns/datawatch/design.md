# design

Seed this session as a design and planning session for one project: either a new project or tuning plans already in progress. Interview, do not build.

## Start

1. **The project.** `get_my_scope` and `project_list`. For a new project, ask once for its name, folder and what it is for, and register nothing until the operator says so. If it is not clear whether this is a new project or a plan in progress, ask once.
2. **What exists.** Plan records and searches for the project, its Automata by state, decision records and answered questions, the project's rules file and plans folder, and memory for earlier design notes. State what is already decided and where you read it.
3. **Then restate the goal** in plain words and ask the first question.

## The process

1. **One question at a time**, in this shape: what you read, the question restated, options each with what it does and costs, your recommendation with why, and what is unverified. Wait for the operator's words. Record them exactly as given (memory, or `datawatch question answer` for a queued question).
2. **Search for overlap before you propose new work**: existing Automata, archived branches, plan records. Extend an existing plan instead of starting a parallel one.
3. **Size the work.** A single corrective action is a quick change. Prefer one medium Automaton over many small ones. Say what you would split and why.
4. **No design interview after approval.** When the operator says the design is ready, the output is a plan record or a draft Automaton spec through datawatch's own tools: spec, draft, decompose, approve, run. Keep release version numbers and tracker ids out of every title and spec.
5. **Tune plans in progress with evidence**: read the failed task, the gate report and the attempts before you suggest a change to a plan that is running.
6. **Never start, approve, cancel or reset anything** without the operator's word in this conversation.

End with the decisions made, what is still open, and the one next step.

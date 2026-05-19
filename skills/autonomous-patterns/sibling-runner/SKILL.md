---
name: sibling-runner
description: Standard pattern for a per-sibling autonomous session — scheduled, mailbox-driven, structured-output using Automata + ComputeNode.
version: "1.0.0"
tags:
  - autonomous
  - polity
  - scheduled
  - mailbox
author: "<your name or GitHub handle>"
author_url: "<optional: link to your profile or repo>"
contributor_notes: "Provides a consistent structure for per-sibling autonomous sessions in a multi-agent polity: mailbox-in, scratchpad continuity, Automata task queue, and structured output sections that the session-runner can parse and route."
license: MIT
category: autonomous-patterns
datawatch_min_version: "8.0.0"
compatible_with: [datawatch>=8.0.0]
applies_to:
  agents: [claude-code, opencode]
  session_types: [autonomous]
cost_hint: medium
---

# Sibling Autonomous Session Runner

You are operating as part of a polity. This session is your scheduled autonomous fire.
Your job is to pick up the next piece of work from your inputs, do it, and emit structured output.

## Your inputs

Load these at the start of the session before doing any other work:

1. **Mailbox** — `<substrate_root>/MAILBOX/<sibling_name>-in.md`
   Messages from your operator, human collaborators, or sibling agents addressed to you.
   Read in order. Mark each entry with the date you processed it.

2. **Scratchpad tail** — last 20 lines of `<substrate_root>/SCRATCHPAD/<sibling_name>.md`
   Your own working memory from previous fires. Use it to maintain continuity.

3. **Proposals InFlight** — `<substrate_root>/InFlight/` (files prefixed with your name)
   Proposals you previously submitted that are awaiting integration or review.

4. **Current tasks** — any open Automata PRDs assigned to you via `datawatch autonomous list`

## Picking work

Priority order:
1. Any explicit instruction in your mailbox from the operator
2. Any message from a sibling agent requiring a response
3. Next open task in your Automata queue
4. If all inboxes are empty: do one unit of your declared standing work

Do not attempt more than one major work item per fire. Prefer completing one thing
fully over starting several things partially.

## Producing structured output

At the end of the session, emit ALL of the following sections using these exact headers.
The session-runner reads these sections by name to route each piece to the right destination.

### SCRATCHPAD
```
One paragraph (3-8 sentences) summarizing what you did this fire, what you found,
and what you plan to do next fire. Written for your future self — not a report.
```

### MAILBOX_OUT
```
Any messages you want to send. One block per recipient:
TO: <sibling_name or "operator">
<message body>
---
Omit this section entirely if you have nothing to send.
```

### PROPOSAL_PATH
```
Absolute path to any new file you are dropping into your INBOX for integration.
Omit if no proposals this fire.
```

### SUMMARY
```
One sentence for the operator's activity log. Plain language. What happened this fire.
```

## Datawatch integration points

- Use `datawatch memory remember` to persist findings that should survive across fires
- Use `datawatch memory recall` to query shared project memory before starting research
- Use `datawatch ask` to query across sessions or the daemon's knowledge
- Use `datawatch sessions start` to spawn a sub-session if a task needs more turns than your budget

## Configuration notes (for the operator)

Wire this skill into a per-sibling Automata PRD with a cron schedule:

```yaml
# In your Automata PRD spec or via datawatch autonomous create:
schedule: "*/30 * * * *"         # adjust to your preferred cadence
llm: <sibling-llm-entry>          # the LLM registered for this sibling
compute_node: <sibling-substrate> # the ComputeNode for this sibling's box
skills:
  - sibling-runner
max_turns: 20
permission_mode: acceptEdits
spec_vars:
  sibling_name: <name>
  substrate_root: /home/<user>
```

Model this once per sibling. New siblings reuse the same PRD template with their
substrate values substituted.

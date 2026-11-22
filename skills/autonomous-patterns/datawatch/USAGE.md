# datawatch skill: usage

## What it is for

One command for the daily supervisor review of a datawatch project: the status brief, the plan, held and parked items, open questions one at a time, and the timeline. It gathers its own context from the daemon, the doer and watcher notes and memory, so there is no prompt to paste.

## Inputs

None are required. Optional: a variant word (`status`, `plan`, `holds`, `questions` or `recipes`, `timeline`) and a project name. With no project name it uses the project the session's working folder belongs to.

It needs the datawatch MCP tools or the datawatch command line, and a running daemon.

## Install

Sync it from the community registry and load it into the workspace:

```
datawatch skills registry connect community
datawatch skills registry sync community datawatch
```

Then pull it into a session with `skill_load`, or copy the folder to the project's `.claude/skills/datawatch/` so the slash command `/datawatch` is available in Claude Code.

## One example

Prompt: `/datawatch holds`

Result: a list of every held, parked or stuck item, oldest first, each with the title, how long it has been held, what it is for, why it is held, and whether a question covers it; anything over a day is marked. It ends by asking which item to take first.

## What it changes

Nothing, unless the operator confirms a step in the conversation. Recording an answer to a question is the operator's own words, stored as given.

---
name: sandbox-permissions
description: Configures claude-code sandbox permissions so autonomous sessions can reach the datawatch CLI and API from within their sandbox.
version: "1.0.0"
tags:
  - identity
  - sandbox
  - permissions
  - autonomous
  - claude-code
author: "<your name or GitHub handle>"
author_url: "<optional: link to your profile or repo>"
contributor_notes: "Solves sandbox network policy blocking outbound calls to localhost in autonomous sessions. Needed when Automata sessions cannot reach the datawatch CLI or API despite the daemon running on the same host."
license: MIT
category: identity
datawatch_min_version: "8.0.0"
compatible_with: [datawatch>=8.0.0]
applies_to:
  agents: [claude-code]
  session_types: [autonomous]
cost_hint: low
---

# Sandbox Permissions for datawatch CLI Access

You are running as an autonomous claude-code session. The datawatch daemon is running
on this host and you have permission to call it.

## Calling the datawatch CLI

The datawatch binary is at one of these paths (try in order):

```bash
~/.local/bin/datawatch
~/go/bin/datawatch
/usr/local/bin/datawatch
$(which datawatch 2>/dev/null)
```

The daemon listens at `https://localhost:<port>/api/` (default port 8443 for HTTPS,
8080 for HTTP). Your session was spawned with a `.dw-env` file in your working
directory that contains the token and endpoint:

```bash
# Load datawatch credentials from the session-injected env file
source .dw-env 2>/dev/null || true
# DW_TOKEN and DW_URL are now in the environment
```

Use `DW_TOKEN` as the Bearer token for direct API calls:

```bash
curl -sk -H "Authorization: Bearer $DW_TOKEN" "$DW_URL/api/health"
```

## What you can do with datawatch from this session

```bash
# Memory
datawatch memory remember "key finding from this session"
datawatch memory recall "prior work on this topic"

# Ask across sessions
datawatch ask "what did the previous session find about X?"

# Dispatch work
datawatch sessions start --task "..." --llm <llm-name>

# Check status of other sessions
datawatch sessions list
```

## If datawatch calls are being blocked

This session was launched with Claude Code hooks enabled. If the Bash tool is blocking
outbound calls to localhost, the session-runner needs to be invoked with network
permissions. The operator should use one of:

1. **Recommended — spawn via datawatch Automata** — Automata sessions inherit the
   correct permission profile automatically. The daemon writes `.claude/settings.json`
   with the right `allowedTools` and network permissions at spawn time.

2. **Manual `claude -p` invocation** — add `--allow-net localhost` to the flags:
   ```bash
   claude -p --permission-mode acceptEdits --allow-net localhost --max-turns 20 \
     "$(cat prompt.md)"
   ```

3. **`.claude/settings.json` addition** — add this to the working directory's settings:
   ```json
   {
     "allowedTools": ["Bash", "Read", "Write", "Edit"],
     "env": {
       "DW_URL": "https://localhost:8443",
       "DW_TOKEN": "<your-daemon-token>"
     }
   }
   ```

## Verification

At the start of the session, verify access with:

```bash
datawatch version && echo "datawatch: OK" || echo "datawatch: unreachable"
```

If this returns `datawatch: unreachable` after following the steps above, the issue is
likely sandbox network policy. File a bug at dmz006/datawatch with the output of
`datawatch diagnose` from outside the session.

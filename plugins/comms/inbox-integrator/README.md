# inbox-integrator

Watches a sibling agent's INBOX directory after each autonomous session and integrates
new proposal files into the shared InFlight workspace with attribution headers.

## What it does

When an autonomous sibling session drops files into its INBOX directory, this plugin:

1. Reads each new `.md`, `.yaml`, or `.txt` file from the INBOX
2. Prepends an attribution header (`<!-- Integrated from <sibling> on <timestamp> -->`)
3. Moves the file into the shared `INFLIGHT_DIR`, prefixed with the sibling's name
4. Optionally writes an acknowledgment into the sibling's inbound mailbox
5. If `REQUIRE_APPROVAL=true`, places files in `INFLIGHT_DIR/pending-review/` instead

## Setup

### 1. Install via datawatch

```bash
# Pull from the community registry (if connected)
datawatch skills sync
# Then enable the plugin for a session profile
datawatch plugins enable inbox-integrator --profile <your-profile>
```

### 2. Configure environment variables

Set these in your datawatch plugin config or the session's environment:

| Variable | Required | Description |
|---|---|---|
| `INBOX_DIR` | yes | Path where the sibling drops proposals (e.g. `/home/user/INBOX/sage`) |
| `INFLIGHT_DIR` | yes | Canonical shared InFlight directory (e.g. `/home/user/InFlight`) |
| `SIBLING_NAME` | yes | Name of the proposing sibling, used for file prefix and attribution |
| `NOTIFY_MAILBOX` | no | Path to the sibling's inbound mailbox for acknowledgment |
| `REQUIRE_APPROVAL` | no | Set to `"true"` to route proposals to `pending-review/` subdir |

### 3. Wire to the sibling's autonomous PRD

In your Automata PRD spec:

```yaml
plugins:
  - inbox-integrator
env:
  INBOX_DIR: /home/myuser/INBOX/sage
  INFLIGHT_DIR: /home/myuser/InFlight
  SIBLING_NAME: sage
  NOTIFY_MAILBOX: /home/myuser/MAILBOX/sage-in.md
  REQUIRE_APPROVAL: "false"
```

## Approval workflow

Set `REQUIRE_APPROVAL=true` for siblings whose proposals need operator review before
they enter the main InFlight workspace. Files land in `INFLIGHT_DIR/pending-review/`
and an acknowledgment is written to the sibling's mailbox. The operator reviews and
manually moves approved files into `INFLIGHT_DIR/`.

## Pairing with sibling-runner

This plugin is designed to work alongside the `sibling-runner` skill. The skill defines
the `PROPOSAL_PATH` output section that the session-runner uses to populate INBOX;
this plugin then picks up those files and integrates them.

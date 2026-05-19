# workspace-rsync-sync

Syncs workspace files to/from a remote datawatch host over rsync/SSH after a session completes.

## When to use this

- You have multiple datawatch instances that share work across hosts
- You prefer rsync/SSH over setting up full federation
- You want to mirror a workspace directory after every session automatically

For full federated file management (API access, PWA upload, mobile file picker), see **BL333 Federated File Service** (datawatch v8.3.0+).

## Setup

```yaml
# datawatch plugin config (plugin section in config.yaml)
plugins:
  - name: workspace-rsync-sync
    hooks: [post_session_complete]
    env:
      RSYNC_REMOTE: "user@remote-host:/path/to/shared-workspace"
      RSYNC_DIRECTION: "push"          # push, pull, or both
      RSYNC_SSH_KEY: "/home/user/.ssh/datawatch_rsa"
```

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `RSYNC_REMOTE` | yes | — | rsync destination (`user@host:/path`) |
| `RSYNC_LOCAL_DIR` | no | `pwd` | Local directory to sync |
| `RSYNC_SSH_KEY` | no | SSH agent | Path to SSH identity file |
| `RSYNC_DIRECTION` | no | `push` | `push`, `pull`, or `both` |
| `RSYNC_EXCLUDE` | no | `.git,*.tmp,node_modules` | Comma-separated exclude patterns |
| `RSYNC_DRY_RUN` | no | `false` | Print what would sync without doing it |

## Requirements

- `rsync` installed on the host running this plugin
- SSH access to the remote host (key-based recommended)

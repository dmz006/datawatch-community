# workspace-git-sync

Commits and pushes workspace changes to a git remote after each session. Pulls latest before session starts.

## When to use this

- Multi-agent collaborative development sessions where agents share a workspace via git
- You already use git for workspace version control and want automatic sync
- You want session-attributed commits (`datawatch sync: session <id>`)

## How it works

- **pre_session_start**: Pulls from the git remote to get the latest workspace state
- **post_session_complete**: Commits all changes (with session ID in the message) and pushes

## Setup

```yaml
# datawatch plugin config
plugins:
  - name: workspace-git-sync
    hooks: [pre_session_start, post_session_complete]
    env:
      GIT_REMOTE: "origin"
      GIT_BRANCH: "main"
      GIT_WORK_DIR: "/home/user/shared-workspace"
      GIT_SSH_KEY: "/home/user/.ssh/datawatch_rsa"
```

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `GIT_REMOTE` | no | `origin` | Git remote name or URL |
| `GIT_BRANCH` | no | current branch | Branch to sync |
| `GIT_WORK_DIR` | no | `pwd` | Directory containing the git repo |
| `GIT_COMMIT_MSG` | no | `datawatch sync: session {session_id} on {date}` | Commit message template |
| `GIT_PULL_REBASE` | no | `false` | Use rebase instead of merge on pull |
| `GIT_SSH_KEY` | no | SSH agent | Path to SSH identity file |

## Requirements

- Git configured in the working directory
- Push access to the remote (key-based SSH recommended)

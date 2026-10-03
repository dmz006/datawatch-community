#!/usr/bin/env bash
# workspace-git-sync — pre_session_start and post_session_complete hook
# Pulls latest from git remote before session; commits and pushes after.
#
# Triggered by DATAWATCH_HOOK env var:
#   pre_session_start     → pull only
#   post_session_complete → commit staged/unstaged changes + push

set -euo pipefail

GIT_REMOTE="${GIT_REMOTE:-origin}"
GIT_BRANCH="${GIT_BRANCH:-}"
GIT_WORK_DIR="${GIT_WORK_DIR:-$(pwd)}"
GIT_COMMIT_MSG="${GIT_COMMIT_MSG:-datawatch sync: session {session_id} on {date}}"
GIT_PULL_REBASE="${GIT_PULL_REBASE:-false}"
GIT_SSH_KEY="${GIT_SSH_KEY:-}"
DATAWATCH_HOOK="${DATAWATCH_HOOK:-post_session_complete}"
DATAWATCH_SESSION_ID="${DATAWATCH_SESSION_ID:-unknown}"

if [[ ! -d "$GIT_WORK_DIR/.git" ]]; then
  echo '{"ok":false,"error":"GIT_WORK_DIR is not a git repository"}' >&2
  exit 1
fi

cd "$GIT_WORK_DIR"

GIT_ENV=()
if [[ -n "$GIT_SSH_KEY" ]]; then
  GIT_ENV=(GIT_SSH_COMMAND="ssh -i $GIT_SSH_KEY -o StrictHostKeyChecking=accept-new -o BatchMode=yes")
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
TARGET_BRANCH="${GIT_BRANCH:-$CURRENT_BRANCH}"

do_pull() {
  local pull_args=("${GIT_REMOTE}" "${TARGET_BRANCH}")
  if [[ "$GIT_PULL_REBASE" == "true" ]]; then
    pull_args=(--rebase "${pull_args[@]}")
  fi
  env "${GIT_ENV[@]}" git pull "${pull_args[@]}" 2>&1
}

do_commit_and_push() {
  local msg
  msg="${GIT_COMMIT_MSG//\{session_id\}/$DATAWATCH_SESSION_ID}"
  msg="${msg//\{date\}/$(date -u +%Y-%m-%dT%H:%M:%SZ)}"

  if ! git diff --quiet || ! git diff --cached --quiet; then
    git add -A
    git commit -m "$msg"
    env "${GIT_ENV[@]}" git push "${GIT_REMOTE}" "${TARGET_BRANCH}" 2>&1
    echo '{"ok":true,"action":"commit_and_push","branch":"'"$TARGET_BRANCH"'"}'
  else
    echo '{"ok":true,"action":"no_changes","branch":"'"$TARGET_BRANCH"'"}'
  fi
}

case "$DATAWATCH_HOOK" in
  pre_session_start)
    do_pull
    echo '{"ok":true,"action":"pull","branch":"'"$TARGET_BRANCH"'"}'
    ;;
  post_session_complete)
    do_commit_and_push
    ;;
  *)
    echo '{"ok":false,"error":"Unknown DATAWATCH_HOOK: '"$DATAWATCH_HOOK"'"}' >&2
    exit 1
    ;;
esac

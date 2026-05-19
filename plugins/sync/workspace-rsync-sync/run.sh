#!/usr/bin/env bash
# workspace-rsync-sync — post_session_complete hook
# Syncs local workspace to/from a remote host over rsync/SSH.

set -euo pipefail

RSYNC_REMOTE="${RSYNC_REMOTE:-}"
RSYNC_LOCAL_DIR="${RSYNC_LOCAL_DIR:-$(pwd)}"
RSYNC_SSH_KEY="${RSYNC_SSH_KEY:-}"
RSYNC_DIRECTION="${RSYNC_DIRECTION:-push}"
RSYNC_EXCLUDE="${RSYNC_EXCLUDE:-.git,*.tmp,node_modules}"
RSYNC_DRY_RUN="${RSYNC_DRY_RUN:-false}"

if [[ -z "$RSYNC_REMOTE" ]]; then
  echo '{"ok":false,"error":"RSYNC_REMOTE must be set (e.g. user@host:/path/to/workspace)"}' >&2
  exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=accept-new -o BatchMode=yes"
if [[ -n "$RSYNC_SSH_KEY" ]]; then
  SSH_OPTS="$SSH_OPTS -i $RSYNC_SSH_KEY"
fi

RSYNC_ARGS=(-az --delete --stats)
if [[ "$RSYNC_DRY_RUN" == "true" ]]; then
  RSYNC_ARGS+=(--dry-run)
fi

IFS=',' read -ra EXCLUDES <<< "$RSYNC_EXCLUDE"
for pat in "${EXCLUDES[@]}"; do
  RSYNC_ARGS+=(--exclude="$pat")
done

RSYNC_ARGS+=(-e "ssh $SSH_OPTS")

run_push() {
  rsync "${RSYNC_ARGS[@]}" "${RSYNC_LOCAL_DIR}/" "${RSYNC_REMOTE}/"
}

run_pull() {
  rsync "${RSYNC_ARGS[@]}" "${RSYNC_REMOTE}/" "${RSYNC_LOCAL_DIR}/"
}

case "$RSYNC_DIRECTION" in
  push)
    run_push
    echo '{"ok":true,"direction":"push"}'
    ;;
  pull)
    run_pull
    echo '{"ok":true,"direction":"pull"}'
    ;;
  both)
    run_pull
    run_push
    echo '{"ok":true,"direction":"both"}'
    ;;
  *)
    echo '{"ok":false,"error":"RSYNC_DIRECTION must be push, pull, or both"}' >&2
    exit 1
    ;;
esac

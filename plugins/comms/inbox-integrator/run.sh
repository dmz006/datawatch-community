#!/usr/bin/env bash
# inbox-integrator — post_session_complete hook
# Reads new proposal files from INBOX_DIR and moves them into INFLIGHT_DIR
# with a sibling attribution header. Optionally notifies the sibling mailbox.
#
# Environment (required):
#   INBOX_DIR      — path to watch for new proposal files
#   INFLIGHT_DIR   — canonical InFlight workspace directory
#   SIBLING_NAME   — proposing sibling name (used for file prefix + attribution)
#
# Environment (optional):
#   NOTIFY_MAILBOX  — path to sibling's inbound mailbox for acknowledgment
#   REQUIRE_APPROVAL — if "true", drop to $INFLIGHT_DIR/pending-review/ instead

set -euo pipefail

INBOX_DIR="${INBOX_DIR:-}"
INFLIGHT_DIR="${INFLIGHT_DIR:-}"
SIBLING_NAME="${SIBLING_NAME:-sibling}"
NOTIFY_MAILBOX="${NOTIFY_MAILBOX:-}"
REQUIRE_APPROVAL="${REQUIRE_APPROVAL:-false}"

if [[ -z "$INBOX_DIR" || -z "$INFLIGHT_DIR" ]]; then
  echo '{"ok":false,"error":"INBOX_DIR and INFLIGHT_DIR must be set"}' >&1
  exit 1
fi

if [[ ! -d "$INBOX_DIR" ]]; then
  echo '{"ok":true,"message":"INBOX_DIR does not exist, nothing to do"}' >&1
  exit 0
fi

mkdir -p "$INFLIGHT_DIR"
if [[ "$REQUIRE_APPROVAL" == "true" ]]; then
  mkdir -p "$INFLIGHT_DIR/pending-review"
fi

PROCESSED=0
SKIPPED=0

for file in "$INBOX_DIR"/*.md "$INBOX_DIR"/*.yaml "$INBOX_DIR"/*.txt; do
  [[ -e "$file" ]] || continue

  filename="$(basename "$file")"
  target_dir="$INFLIGHT_DIR"
  if [[ "$REQUIRE_APPROVAL" == "true" ]]; then
    target_dir="$INFLIGHT_DIR/pending-review"
  fi

  # Prefix with sibling name if not already prefixed
  dest_name="${SIBLING_NAME}-${filename}"
  dest_path="$target_dir/$dest_name"

  # Prepend attribution header to the file content
  tmp="$(mktemp)"
  {
    echo "<!-- Integrated from ${SIBLING_NAME} INBOX on $(date -u +%Y-%m-%dT%H:%M:%SZ) -->"
    echo "<!-- Source: ${file} -->"
    echo ""
    cat "$file"
  } > "$tmp"

  mv "$tmp" "$dest_path"
  rm -f "$file"
  PROCESSED=$((PROCESSED + 1))

  # Acknowledge in sibling's mailbox if configured
  if [[ -n "$NOTIFY_MAILBOX" ]]; then
    echo "" >> "$NOTIFY_MAILBOX"
    echo "## [$(date -u +%Y-%m-%dT%H:%M:%SZ)] inbox-integrator" >> "$NOTIFY_MAILBOX"
    echo "Integrated: \`${filename}\` → \`${dest_path}\`" >> "$NOTIFY_MAILBOX"
    if [[ "$REQUIRE_APPROVAL" == "true" ]]; then
      echo "Status: pending-review (operator approval required before merging)" >> "$NOTIFY_MAILBOX"
    fi
  fi
done

echo "{\"ok\":true,\"processed\":${PROCESSED},\"skipped\":${SKIPPED}}"

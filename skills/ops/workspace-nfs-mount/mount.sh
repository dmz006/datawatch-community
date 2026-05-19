#!/usr/bin/env bash
# workspace-nfs-mount — pre_session_start skill
# Mounts an NFS export to a local path before a datawatch session starts.
# Requires mount(8) and nfs-common (or equivalent) to be installed on the host.

set -euo pipefail

NFS_SERVER="${NFS_SERVER:-}"
NFS_EXPORT="${NFS_EXPORT:-}"
NFS_MOUNT_POINT="${NFS_MOUNT_POINT:-/mnt/datawatch-workspace}"
NFS_OPTIONS="${NFS_OPTIONS:-rw,soft,intr,nfsvers=4}"
NFS_UMOUNT_ON_DONE="${NFS_UMOUNT_ON_DONE:-false}"
NFS_CREATE_MOUNTPOINT="${NFS_CREATE_MOUNTPOINT:-true}"
DATAWATCH_HOOK="${DATAWATCH_HOOK:-pre_session_start}"

if [[ -z "$NFS_SERVER" || -z "$NFS_EXPORT" ]]; then
  echo '{"ok":false,"error":"NFS_SERVER and NFS_EXPORT must be set"}' >&2
  exit 1
fi

NFS_SOURCE="${NFS_SERVER}:${NFS_EXPORT}"

do_mount() {
  if mountpoint -q "$NFS_MOUNT_POINT" 2>/dev/null; then
    echo '{"ok":true,"action":"already_mounted","mount_point":"'"$NFS_MOUNT_POINT"'"}'
    return
  fi

  if [[ "$NFS_CREATE_MOUNTPOINT" == "true" ]]; then
    mkdir -p "$NFS_MOUNT_POINT"
  fi

  if [[ ! -d "$NFS_MOUNT_POINT" ]]; then
    echo '{"ok":false,"error":"Mount point does not exist: '"$NFS_MOUNT_POINT"'"}' >&2
    exit 1
  fi

  mount -t nfs -o "$NFS_OPTIONS" "$NFS_SOURCE" "$NFS_MOUNT_POINT"
  echo '{"ok":true,"action":"mounted","source":"'"$NFS_SOURCE"'","mount_point":"'"$NFS_MOUNT_POINT"'"}'
}

do_umount() {
  if ! mountpoint -q "$NFS_MOUNT_POINT" 2>/dev/null; then
    echo '{"ok":true,"action":"not_mounted","mount_point":"'"$NFS_MOUNT_POINT"'"}'
    return
  fi
  umount "$NFS_MOUNT_POINT"
  echo '{"ok":true,"action":"unmounted","mount_point":"'"$NFS_MOUNT_POINT"'"}'
}

case "$DATAWATCH_HOOK" in
  pre_session_start)
    do_mount
    ;;
  post_session_complete)
    if [[ "$NFS_UMOUNT_ON_DONE" == "true" ]]; then
      do_umount
    else
      echo '{"ok":true,"action":"skipped_umount","reason":"NFS_UMOUNT_ON_DONE is false"}'
    fi
    ;;
  *)
    echo '{"ok":false,"error":"Unknown DATAWATCH_HOOK: '"$DATAWATCH_HOOK"'"}' >&2
    exit 1
    ;;
esac

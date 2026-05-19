# workspace-nfs-mount

Pre-condition skill that mounts an NFS share to a local path before a datawatch session starts.

## When to use this

- You run datawatch sessions in containers and share a workspace via NFS
- Multiple datawatch instances (or agents) need access to the same filesystem
- You want automatic mount/unmount lifecycle tied to session start/complete

datawatch already supports NFS shares in container sessions — this skill automates the mount step.

For full federated file management with access control, see **BL333 Federated File Service** (datawatch v8.3.0+).

## Setup

```yaml
# datawatch skill config
skills:
  - name: workspace-nfs-mount
    triggers: [pre_session_start]
    env:
      NFS_SERVER: "192.168.1.10"
      NFS_EXPORT: "/exports/shared-workspace"
      NFS_MOUNT_POINT: "/mnt/datawatch-workspace"
      NFS_OPTIONS: "rw,soft,intr,nfsvers=4"
```

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NFS_SERVER` | yes | — | NFS server hostname or IP |
| `NFS_EXPORT` | yes | — | Exported path on server |
| `NFS_MOUNT_POINT` | no | `/mnt/datawatch-workspace` | Local mount point |
| `NFS_OPTIONS` | no | `rw,soft,intr,nfsvers=4` | Mount options |
| `NFS_UMOUNT_ON_DONE` | no | `false` | Unmount after session completes |
| `NFS_CREATE_MOUNTPOINT` | no | `true` | Create mount point if it doesn't exist |

## Requirements

- `nfs-common` (Debian/Ubuntu) or `nfs-utils` (RHEL/Alpine) installed on the host
- `mount` must be available (may need to run datawatch with sufficient privileges or sudo config)

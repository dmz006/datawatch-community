# datawatch-community

Community-contributed **Skills** and **Plugins** for [datawatch](https://github.com/dmz006/datawatch).

Skills and Plugins are the intended customization layer for datawatch. Features that can live here should live here — they ship faster, are operator-maintained, and don't add daemon complexity. This registry exists so operators don't have to build these patterns in isolation.

## What's here

| Path | What goes here |
|---|---|
| [`skills/autonomous-patterns/`](skills/autonomous-patterns/) | Autonomous session runners, Automata compositions, scheduled-work patterns |
| [`skills/identity/`](skills/identity/) | Per-instance topology, multi-identity awareness, sandbox setup |
| [`skills/comms/`](skills/comms/) | Channel watchdogs, mailbox relays, notification routing |
| [`skills/coding/`](skills/coding/) | Language-specific review, RTK-aware workflows, code style guides |
| [`skills/security/`](skills/security/) | Guardrail packs, audit patterns, secret hygiene |
| [`skills/ops/`](skills/ops/) | Infrastructure patterns, deployment workflows |
| [`plugins/output-routing/`](plugins/output-routing/) | Post-session output routing, structured extractors, sibling output relay |
| [`plugins/guardrails/`](plugins/guardrails/) | Custom guardrail hooks, compliance checks |
| [`plugins/comms/`](plugins/comms/) | Inbox integrators, channel bridges, notification plugins |

## Quick start

```bash
# Add this registry (one-time)
datawatch skills registry add community https://github.com/dmz006/datawatch-community

# Browse what's available
datawatch skills registry connect community
datawatch skills registry browse community

# Sync a skill you want
datawatch skills registry sync community sibling-runner

# Use it in a session
datawatch sessions start --skills sibling-runner --task "..."
```

Or via MCP:

```
skills_registry_create  name=community  url=https://github.com/dmz006/datawatch-community
skills_registry_connect name=community
skills_registry_available name=community
skills_registry_sync    name=community  skills=sibling-runner
```

## Browsing without syncing

`datawatch skills registry connect community` does a `git clone --depth=1` into your local cache. You can browse the entire catalog, inspect SKILL.md files, and pick only what you want before committing disk space.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). The short version: add your Skill or Plugin directory under the right category folder and open a PR. Maintainer reviews for schema validity, no embedded credentials, and correct category. Merge = listed.

## Compatibility

Every entry declares a `datawatch_min_version` field. Skills require datawatch ≥ that version to guarantee the features they reference are available.

## License

Each entry carries its own `license` field. This repository defaults to MIT for entries that don't specify one. The repository itself is MIT licensed.

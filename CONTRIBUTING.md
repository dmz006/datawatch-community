# Contributing to datawatch-community

Thank you for contributing. This guide covers everything you need to submit a Skill or Plugin.

## Before you start

Check if what you need is already here or can be composed from existing entries. If a
skill already does 80% of what you want, opening an issue proposing an extension is
faster than a duplicate submission.

## Directory structure

Skills live under `skills/<category>/<skill-name>/`.
Plugins live under `plugins/<category>/<plugin-name>/`.

Category choices:

| Skills | Plugins |
|---|---|
| `autonomous-patterns` | `output-routing` |
| `identity` | `guardrails` |
| `comms` | `comms` |
| `coding` | |
| `security` | |
| `ops` | |

If your contribution clearly belongs in a new category, name it in your PR and it will be
created. Don't force-fit into an ill-fitting category.

## Skill format

A skill is a directory containing at minimum a `SKILL.md` with YAML frontmatter.

```
skills/<category>/<skill-name>/
├── SKILL.md          # required — frontmatter + skill body
└── <optional files>  # scripts, config examples, sub-docs
```

### SKILL.md frontmatter

```yaml
---
# --- PAI-compatible base fields ---
name: skill-name                     # must match the directory name
description: One sentence what this skill does.
version: "1.0.0"
tags:
  - autonomous
  - polity

# --- Community required fields ---
author: Your Name or handle          # your real name or GitHub handle — required
author_url: https://github.com/you  # link to your profile, org, or project — optional but encouraged
contributor_notes: "Why you built this, what problem it solves, any caveats."  # strongly encouraged
license: MIT                         # required — MIT, Apache-2.0, CC-BY-4.0, or other SPDX
category: autonomous-patterns        # must match the parent directory name
datawatch_min_version: "8.0.0"       # minimum datawatch version that supports this skill

# --- datawatch optional extensions ---
compatible_with: [datawatch>=8.0.0]
requires: []                         # other skills this one depends on
applies_to:
  agents: [claude-code, opencode]
  session_types: [autonomous, coding]
cost_hint: low                       # low / medium / high
---
```

### Skill body

Below the frontmatter write the skill content exactly as you want it injected into the
session. This is the text an AI agent will read at session-start via the `skill_load`
MCP tool or find in `<projectDir>/.datawatch/skills/<name>/SKILL.md`.

Write it as clear, actionable guidance for the AI — not as documentation for the human
operator. The human operator reads the frontmatter and this CONTRIBUTING.md. The AI
reads the body.

## Plugin format

A plugin is a directory containing a `manifest.yaml` and an executable entry script.

```
plugins/<category>/<plugin-name>/
├── manifest.yaml     # required — plugin manifest
├── run.sh            # entry script (must be executable, matches manifest.entry)
└── README.md         # encouraged — operator setup notes
```

### manifest.yaml

```yaml
name: plugin-name                    # must match the directory name
description: One sentence what this plugin does.
version: "1.0.0"
entry: run.sh                        # relative path to executable

# --- Community required fields ---
author: Your Name or handle
author_url: https://github.com/you   # optional but encouraged
contributor_notes: "Why you built this, what problem it solves, any caveats."
license: MIT
category: comms
datawatch_min_version: "8.0.0"

# --- Plugin fields ---
hooks:
  - pre_session_start                # one or more of:
  - post_session_output              #   pre_session_start / post_session_output
  - post_session_complete            #   post_session_complete / on_alert
  - on_alert
timeout_ms: 5000
mode: oneshot                        # oneshot or persistent
```

### run.sh conventions

- Reads a JSON envelope from stdin (hook payload)
- Writes a JSON response to stdout: `{"ok": true}` or `{"ok": false, "error": "reason"}`
- Must exit 0 on success, non-zero on hard failure
- Must not write credentials, tokens, or secrets to stdout/stderr
- Must complete within `timeout_ms`

## Pull request checklist

Before submitting:

- [ ] Directory name matches `name` in frontmatter/manifest exactly
- [ ] `datawatch_min_version` is set and accurate
- [ ] `license` field is set
- [ ] `author` is set (handle is fine — no real name required)
- [ ] `contributor_notes` is filled in — helps reviewers and future users understand the motivation
- [ ] No hardcoded secrets, tokens, API keys, or personal paths
- [ ] No `curl | bash` or other supply-chain-risky patterns in plugin scripts
- [ ] Skill body is written for the AI consumer, not the human reader
- [ ] Plugin `run.sh` is chmod +x in your local copy (GitHub will preserve it)
- [ ] PR title: `skill: <name> — one-line description` or `plugin: <name> — one-line description`

## Review criteria

Maintainer reviews for:

1. **Schema validity** — frontmatter parses, required fields present, `name` matches directory
2. **No credentials** — no embedded tokens, passwords, personal paths, or machine-specific config
3. **Correct category** — if the category is wrong the maintainer will suggest the right one
4. **No supply-chain risk** — plugin scripts must not fetch and execute remote code without operator consent

The bar is intentionally low. If it works and is safe, it gets merged.

## Updating an existing entry

Open a PR against the entry's directory. Bump the `version` field in the manifest.

## Compatibility notes

- Skills using Algorithm Mode require `datawatch >= 6.9.0`
- Skills using Council require `datawatch >= 6.11.0`
- Skills using Compute Node routing require `datawatch >= 8.0.0`
- Plugins using `on_alert` hook require `datawatch >= 6.3.0`

Set `datawatch_min_version` accordingly so operators know before they sync.

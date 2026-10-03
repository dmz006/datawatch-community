# Security Policy

This repository hosts community-submitted skills and plugins for
[datawatch](https://github.com/dmz006/datawatch). The contribution bar is
intentionally low ("if it works and is safe, it gets merged" — see
[CONTRIBUTING.md](CONTRIBUTING.md)), which makes this document's scope
narrower than a typical application's: it covers risks specific to
distributing third-party-authored code through this registry, not
vulnerabilities in datawatch itself.

## Reporting a malicious or vulnerable submission

If you find a skill or plugin in this repo that:

- exfiltrates credentials, tokens, or secrets,
- fetches and executes remote code without the operator's explicit consent
  (`curl | bash` and similar patterns),
- otherwise behaves differently from what its `description` /
  `contributor_notes` claims,

**prefer private disclosure** before filing a public issue, since a public
issue on an already-merged entry effectively discloses the exploit to every
operator who has `skills registry connect`'ed to this registry before a fix
ships.

- Email: `davidzendzian@gmail.com` — subject line
  `SECURITY: datawatch-community`.
- Include: the affected skill/plugin path, what it actually does vs. what it
  claims, and a minimal reproduction if you have one.

Expect an acknowledgement within 72 hours. A malicious entry will be removed
from `main` immediately on confirmation, before any further investigation —
operators who already pulled it are better served by a fast takedown than a
fully-written incident report.

## Reporting a registry-level flaw

If the flaw is in how this repo is *structured* rather than in a specific
entry — for example, the schema validation in
`scripts/validate_registry.py` missing a class of unsafe plugin, or a gap in
the review checklist itself — open a regular public issue; that kind of
report doesn't disclose an exploitable submission.

## Out of scope

- The datawatch server or clients themselves — report to
  [dmz006/datawatch](https://github.com/dmz006/datawatch) or
  [dmz006/datawatch-app](https://github.com/dmz006/datawatch-app) directly.
- Anything that requires an operator to have already manually approved and
  deliberately misused a plugin (e.g. intentionally granting it credentials
  its manifest doesn't request) — that's an operator-side decision, not a
  registry vulnerability.

## What this repo's CI does and doesn't check

`.github/workflows/validate.yml` validates schema only — required manifest
fields, name/category consistency, that a plugin's `entry` script exists and
is executable. It does **not** scan for malicious behavior, secrets, or
supply-chain risk; that stays a human review responsibility per
[CONTRIBUTING.md](CONTRIBUTING.md)'s review criteria. Don't treat a passing
CI check as a safety guarantee.

## Hall of fame

No reports yet. First reporter to find a valid issue gets credited here
unless they request anonymity.

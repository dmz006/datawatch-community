#!/usr/bin/env python3
"""Validate skills/*/*/SKILL.md and plugins/*/*/manifest.yaml against the
schema documented in CONTRIBUTING.md. Lightweight safety net, not full lint:
checks structure and required fields only, never content quality or
supply-chain risk (that stays a human review criterion per CONTRIBUTING.md).
"""
import os
import sys

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

SKILL_REQUIRED_FIELDS = [
    "name", "description", "version", "author", "license",
    "category", "datawatch_min_version",
]
PLUGIN_REQUIRED_FIELDS = [
    "name", "description", "version", "entry", "author", "license",
    "category", "datawatch_min_version", "hooks", "mode",
]
ALLOWED_HOOKS = {
    "pre_session_start", "post_session_output",
    "post_session_complete", "on_alert",
}
ALLOWED_MODES = {"oneshot", "persistent"}

errors = []


def fail(path, msg):
    errors.append(f"{path}: {msg}")


def parse_frontmatter(text, path):
    if not text.startswith("---\n"):
        fail(path, "missing YAML frontmatter (file must start with '---')")
        return None
    end = text.find("\n---", 4)
    if end == -1:
        fail(path, "frontmatter opened with '---' but never closed")
        return None
    raw = text[4:end]
    try:
        data = yaml.safe_load(raw)
    except yaml.YAMLError as e:
        fail(path, f"frontmatter is not valid YAML: {e}")
        return None
    if not isinstance(data, dict):
        fail(path, "frontmatter must be a YAML mapping")
        return None
    return data


def check_required_fields(data, required, path):
    for field in required:
        if field not in data:
            fail(path, f"missing required field '{field}'")
        elif data[field] in (None, "", []):
            fail(path, f"required field '{field}' is empty")


def validate_skills():
    skills_dir = os.path.join(ROOT, "skills")
    if not os.path.isdir(skills_dir):
        return
    for category in sorted(os.listdir(skills_dir)):
        cat_path = os.path.join(skills_dir, category)
        if not os.path.isdir(cat_path):
            continue
        for skill_name in sorted(os.listdir(cat_path)):
            skill_path = os.path.join(cat_path, skill_name)
            skill_md = os.path.join(skill_path, "SKILL.md")
            rel = os.path.relpath(skill_md, ROOT)
            if not os.path.isdir(skill_path):
                continue
            if not os.path.isfile(skill_md):
                fail(os.path.relpath(skill_path, ROOT), "missing SKILL.md")
                continue
            with open(skill_md, encoding="utf-8") as f:
                text = f.read()
            data = parse_frontmatter(text, rel)
            if data is None:
                continue
            check_required_fields(data, SKILL_REQUIRED_FIELDS, rel)
            if data.get("name") and data["name"] != skill_name:
                fail(rel, f"frontmatter name '{data['name']}' does not match directory name '{skill_name}'")
            if data.get("category") and data["category"] != category:
                fail(rel, f"frontmatter category '{data['category']}' does not match parent directory '{category}'")


def validate_plugins():
    plugins_dir = os.path.join(ROOT, "plugins")
    if not os.path.isdir(plugins_dir):
        return
    for category in sorted(os.listdir(plugins_dir)):
        cat_path = os.path.join(plugins_dir, category)
        if not os.path.isdir(cat_path):
            continue
        for plugin_name in sorted(os.listdir(cat_path)):
            plugin_path = os.path.join(cat_path, plugin_name)
            manifest = os.path.join(plugin_path, "manifest.yaml")
            rel = os.path.relpath(manifest, ROOT)
            if not os.path.isdir(plugin_path):
                continue
            if not os.path.isfile(manifest):
                fail(os.path.relpath(plugin_path, ROOT), "missing manifest.yaml")
                continue
            with open(manifest, encoding="utf-8") as f:
                try:
                    data = yaml.safe_load(f)
                except yaml.YAMLError as e:
                    fail(rel, f"manifest.yaml is not valid YAML: {e}")
                    continue
            if not isinstance(data, dict):
                fail(rel, "manifest.yaml must be a YAML mapping")
                continue
            check_required_fields(data, PLUGIN_REQUIRED_FIELDS, rel)
            if data.get("name") and data["name"] != plugin_name:
                fail(rel, f"manifest name '{data['name']}' does not match directory name '{plugin_name}'")
            if data.get("category") and data["category"] != category:
                fail(rel, f"manifest category '{data['category']}' does not match parent directory '{category}'")

            entry = data.get("entry")
            if entry:
                entry_path = os.path.join(plugin_path, entry)
                entry_rel = os.path.relpath(entry_path, ROOT)
                if not os.path.isfile(entry_path):
                    fail(rel, f"entry script '{entry}' does not exist")
                elif not os.access(entry_path, os.X_OK):
                    fail(entry_rel, "entry script is not executable (chmod +x)")

            hooks = data.get("hooks")
            if isinstance(hooks, list):
                for hook in hooks:
                    if hook not in ALLOWED_HOOKS:
                        fail(rel, f"hook '{hook}' is not one of {sorted(ALLOWED_HOOKS)}")
            elif hooks is not None:
                fail(rel, "'hooks' must be a list")

            mode = data.get("mode")
            if mode is not None and mode not in ALLOWED_MODES:
                fail(rel, f"mode '{mode}' is not one of {sorted(ALLOWED_MODES)}")


def main():
    validate_skills()
    validate_plugins()
    if errors:
        print(f"Registry validation FAILED ({len(errors)} issue(s)):\n")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)
    print("Registry validation passed.")


if __name__ == "__main__":
    main()

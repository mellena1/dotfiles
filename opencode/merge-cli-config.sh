#!/bin/sh
# Build ~/.config/opencode/cli.json from cli.base.json (+ cli.local.json if present).
#
# cli.json can't be stowed: opencode rewrites it via write-tmp-then-rename whenever a
# TUI preference changes, replacing a symlink with a regular file. It also has no
# layered variant -- opencode reads exactly <config>/cli.json.
#
# Seeding is pure shell and works everywhere. Merging a local layer needs a JSON
# parser, but cli.local.json is gitignored and only exists on machines that need
# machine-specific CLI settings, so the interpreter is never required elsewhere.
#
# opencode applies its own edits surgically (path-level diff onto the existing text),
# so it never drops keys we seeded. Re-running is safe.
set -eu

CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
BASE="$CONFIG_DIR/cli.base.json"
LOCAL="$CONFIG_DIR/cli.local.json"
TARGET="$CONFIG_DIR/cli.json"

[ -f "$BASE" ] || { echo "merge-cli-config: no $BASE; nothing to do" >&2; exit 0; }
mkdir -p "$CONFIG_DIR"

# Seed. A stow symlink left over from an older layout is replaced, not written through.
if [ ! -e "$TARGET" ] || [ -L "$TARGET" ]; then
	[ -L "$TARGET" ] && rm -f "$TARGET"
	cp "$BASE" "$TARGET"
	echo "seeded $TARGET from cli.base.json"
fi

[ -f "$LOCAL" ] || exit 0

for candidate in python3 python; do
	if command -v "$candidate" >/dev/null 2>&1; then
		PY="$candidate"
		break
	fi
done

if [ -z "${PY:-}" ]; then
	echo "merge-cli-config: cli.local.json present but no python found;" >&2
	echo "  $TARGET was seeded from cli.base.json only -- apply the local keys by hand." >&2
	exit 0
fi

"$PY" - "$TARGET" "$BASE" "$LOCAL" <<'PY'
import json, os, sys

target, *layers = sys.argv[1:]


def load(path):
    try:
        text = open(path).read().strip()
    except FileNotFoundError:
        return {}
    if not text:
        return {}
    try:
        return json.loads(text)
    except json.JSONDecodeError as exc:
        sys.exit(f"merge-cli-config: {path} is not valid JSON: {exc}")


def merge(base, overlay):
    """Deep-merge overlay onto base. Lists concatenate, dropping duplicates."""
    if not isinstance(base, dict) or not isinstance(overlay, dict):
        return overlay
    out = dict(base)
    for key, value in overlay.items():
        if key in out and isinstance(out[key], dict) and isinstance(value, dict):
            out[key] = merge(out[key], value)
        elif key in out and isinstance(out[key], list) and isinstance(value, list):
            combined = list(out[key])
            for item in value:
                if item not in combined:
                    combined.append(item)
            out[key] = combined
        else:
            out[key] = value
    return out


# Start from the current file so preferences opencode wrote itself survive.
result = load(target)
for path in layers:
    result = merge(result, load(path))

rendered = json.dumps(result, indent=2) + "\n"
if os.path.exists(target) and open(target).read() == rendered:
    print("cli.json already up to date")
    sys.exit(0)

tmp = target + ".tmp"
with open(tmp, "w") as fh:
    fh.write(rendered)
os.replace(tmp, target)
print(f"merged cli.local.json into {target}")
PY

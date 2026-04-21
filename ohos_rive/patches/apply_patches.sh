#!/usr/bin/env bash
# Apply local patches to git submodules. Idempotent: skips already-applied patches.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

apply_to() {
    local submodule_rel="$1"
    local patch_dir="$2"
    local submodule_abs="$REPO_ROOT/$submodule_rel"

    if [ ! -d "$submodule_abs/.git" ] && [ ! -f "$submodule_abs/.git" ]; then
        echo "[patches] skip: $submodule_rel is not a git checkout"
        return 0
    fi
    [ -d "$patch_dir" ] || return 0

    shopt -s nullglob
    local patches=("$patch_dir"/*.patch)
    shopt -u nullglob
    [ ${#patches[@]} -gt 0 ] || return 0

    for p in "${patches[@]}"; do
        if git -C "$submodule_abs" apply --reverse --check "$p" >/dev/null 2>&1; then
            echo "[patches] already applied: $(basename "$p")"
            continue
        fi
        if git -C "$submodule_abs" apply --check "$p" >/dev/null 2>&1; then
            git -C "$submodule_abs" apply "$p"
            echo "[patches] applied: $(basename "$p")"
        else
            echo "[patches] ERROR: cannot apply $(basename "$p") to $submodule_rel" >&2
            echo "[patches] hint: submodule content may have drifted; regenerate the patch" >&2
            exit 1
        fi
    done
}

apply_to "submodules/rive-runtime" "$SCRIPT_DIR/rive-runtime"

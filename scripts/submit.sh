#!/usr/bin/env bash
# 用法：scripts/submit.sh 005-brackets
# 交 problems/<題號>.c（或 .cpp）給本機的 ds-judge
set -euo pipefail

JUDGE="${DS_JUDGE:-$HOME/dev/projects/ds-judge}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
P="${1:?用法：$0 <題號>，例如 005-brackets}"

for ext in c cpp; do
    f="$ROOT/problems/$P.$ext"
    if [[ -f "$f" ]]; then
        cd "$JUDGE"
        exec uv run judge.py submit "$P" "$f"
    fi
done

echo "找不到 problems/$P.c 或 problems/$P.cpp" >&2
exit 1

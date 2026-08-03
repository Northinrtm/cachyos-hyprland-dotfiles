#!/usr/bin/env bash

set -euo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

failed=false

check() {
    local label="$1"
    local pattern="$2"

    if rg -n -i --hidden \
        --glob '!.git/**' \
        --glob '!privacy-check.sh' \
        "$pattern" .; then
        echo "Privacy check failed: $label" >&2
        failed=true
    fi
}

check "absolute Linux home path" '/home/[[:alnum:]_.-]+'
check "email address" '[[:alnum:]._%+-]+@[[:alnum:].-]+\.[A-Z]{2,}'
check "MAC address" '([0-9A-F]{2}:){5}[0-9A-F]{2}'
check "private key" 'BEGIN (OPENSSH|RSA|EC|DSA|PGP) PRIVATE KEY'
check "likely assigned secret" '(token|secret|password|passwd|api[_-]?key|private[_-]?key)[[:space:]]*[:=][[:space:]]*[^[:space:]]+'
check "credential embedded in URL" 'https?://[^/@[:space:]]+:[^/@[:space:]]+@'

if $failed; then
    exit 1
fi

echo "Privacy check passed."

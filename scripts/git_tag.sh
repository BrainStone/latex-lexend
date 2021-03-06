#! /bin/bash

# Load version helper stuff
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/version.sh"

# Create tag
git tag -a "v$SHORT_VERSION" -m "$(getChangelog)"

echo "Tagged as v$SHORT_VERSION"

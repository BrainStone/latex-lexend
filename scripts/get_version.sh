#! /bin/bash -x

# Load version helper stuff
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/version.sh"

# Print version number
echo "$VERSION"

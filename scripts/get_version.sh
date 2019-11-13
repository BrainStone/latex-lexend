#! /bin/bash

# Load version helper stuff
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/version.sh"

if [ "$1" == "version" ]; then
    # Print version number
    echo "$VERSION"
elif [ "$1" == "timestamp" ]; then
    # Print timestamp
    echo "$TIMESTAMP"
fi

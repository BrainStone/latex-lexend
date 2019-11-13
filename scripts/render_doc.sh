#! /bin/bash

# Load version helper stuff
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/version.sh"

# Save the base dir
BASE_DIR="$(cd "$SCRIPT_DIR"/.. >/dev/null 2>&1 && pwd)"

# Create a temporary work dir
TEMP_DIR="$(mktemp -d)"

# Prepare cleanup
function cleanup() {
    # Remove our temporary work dir
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Exit on any error
set -e

# Copy all files passed from the Makefile.
# This includes, the font files, the fontspec files, sty file and tex doc file.
# And we want to copy them flatly
cp "$@" "$TEMP_DIR"
cd "$TEMP_DIR"

# Actually render doc file (And set the "current timestamp" in the document to be the timestamp of the last commit)
FORCE_SOURCE_DATE=1 SOURCE_DATE_EPOCH=$TIMESTAMP latexmk -lualatex lexend.tex

# Copy the pdf
cp lexend.pdf "$BASE_DIR"/lexend/doc/
 
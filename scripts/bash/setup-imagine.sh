#!/usr/bin/env bash

set -e

# Parse command line arguments
JSON_MODE=false

for arg in "$@"; do
    case "$arg" in
        --json) 
            JSON_MODE=true 
            ;;
        --help|-h) 
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
            exit 0 
            ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get repository root
REPO_ROOT=$(get_repo_root)

# Define paths
ARTIFACTS_DIR="$REPO_ROOT/solution-artifacts"
OUTPUT_FILE="$REPO_ROOT/solution-design.md"

# Create artifacts directory if it doesn't exist
mkdir -p "$ARTIFACTS_DIR"

# Scan for artifact files
ARTIFACT_FILES=()
if [[ -d "$ARTIFACTS_DIR" ]]; then
    # Find all supported file types
    while IFS= read -r -d '' file; do
        ARTIFACT_FILES+=("$file")
    done < <(find "$ARTIFACTS_DIR" -maxdepth 1 -type f \( \
        -iname "*.pdf" -o \
        -iname "*.docx" -o \
        -iname "*.doc" -o \
        -iname "*.txt" -o \
        -iname "*.md" -o \
        -iname "*.png" -o \
        -iname "*.jpg" -o \
        -iname "*.jpeg" \
    \) -print0 | sort -z)
fi

# Determine output filename (check for existing versions)
if [[ -f "$OUTPUT_FILE" ]]; then
    VERSION=2
    while [[ -f "$REPO_ROOT/solution-design-v$VERSION.md" ]]; do
        VERSION=$((VERSION + 1))
    done
    OUTPUT_FILE="$REPO_ROOT/solution-design-v$VERSION.md"
fi

# Output results
if $JSON_MODE; then
    # Build JSON array for artifact files
    ARTIFACT_JSON="["
    FIRST=true
    for file in "${ARTIFACT_FILES[@]}"; do
        if $FIRST; then
            FIRST=false
        else
            ARTIFACT_JSON+=","
        fi
        # Escape quotes in filename
        ESCAPED_FILE=$(printf '%s' "$file" | sed 's/"/\\"/g')
        ARTIFACT_JSON+="\"$ESCAPED_FILE\""
    done
    ARTIFACT_JSON+="]"

    # Escape paths for JSON
    ARTIFACTS_DIR_ESC=$(printf '%s' "$ARTIFACTS_DIR" | sed 's/"/\\"/g')
    OUTPUT_FILE_ESC=$(printf '%s' "$OUTPUT_FILE" | sed 's/"/\\"/g')
    REPO_ROOT_ESC=$(printf '%s' "$REPO_ROOT" | sed 's/"/\\"/g')

    printf '{"REPO_ROOT":"%s","ARTIFACTS_DIR":"%s","ARTIFACT_FILES":%s,"OUTPUT_FILE":"%s","ARTIFACT_COUNT":%d}\n' \
        "$REPO_ROOT_ESC" "$ARTIFACTS_DIR_ESC" "$ARTIFACT_JSON" "$OUTPUT_FILE_ESC" "${#ARTIFACT_FILES[@]}"
else
    echo "REPO_ROOT: $REPO_ROOT"
    echo "ARTIFACTS_DIR: $ARTIFACTS_DIR"
    echo "ARTIFACT_FILES:"
    if [[ ${#ARTIFACT_FILES[@]} -eq 0 ]]; then
        echo "  (none found)"
    else
        for file in "${ARTIFACT_FILES[@]}"; do
            echo "  - $file"
        done
    fi
    echo "OUTPUT_FILE: $OUTPUT_FILE"
    echo "ARTIFACT_COUNT: ${#ARTIFACT_FILES[@]}"
fi

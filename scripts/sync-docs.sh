#!/bin/bash
set -euo pipefail

# Sync documentation from main repository
# Usage: ./sync-docs.sh <version> <ref> <sha>

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <version> <ref> <sha>"
    echo "Example: $0 dev refs/heads/main abc123..."
    exit 1
fi

VERSION="$1"
SOURCE_REF="$2"
SOURCE_SHA="$3"

echo "Syncing documentation for version: ${VERSION}"

# Create target directory
mkdir -p "${VERSION}"

# Clear existing content
if [ -d "${VERSION}" ]; then
    find "${VERSION}" -mindepth 1 -delete 2>/dev/null || true
fi

# For dev builds, also clear the changes directory at root
if [ "${VERSION}" = "dev" ] && [ -d "changes" ]; then
    find changes -mindepth 1 -delete 2>/dev/null || true
fi

# Copy documentation files
if [ -d "source-repo/docs" ]; then
    if [ "${VERSION}" = "dev" ]; then
        echo "Syncing dev version - including changes directory"

        # For dev, copy everything
        find source-repo/docs -type f -exec bash -c '
            file="$1"
            dest="${file/source-repo\/docs/'"${VERSION}"'}"
            mkdir -p "$(dirname "$dest")"
            cp "$file" "$dest"
        ' _ {} \;

        # Also sync changes directory to root level for dev
        if [ -d "source-repo/docs/changes" ]; then
            echo "Syncing changes directory to root"
            mkdir -p changes
            find source-repo/docs/changes -type f -exec bash -c '
                file="$1"
                dest="${file/source-repo\/docs\/changes/changes}"
                mkdir -p "$(dirname "$dest")"
                cp "$file" "$dest"
            ' _ {} \;
        fi
    else
        echo "Syncing stable version ${VERSION} - excluding changes directory"

        # For stable versions, exclude changes
        find source-repo/docs -type f \! -path "source-repo/docs/changes/*" -exec bash -c '
            file="$1"
            dest="${file/source-repo\/docs/'"${VERSION}"'}"
            mkdir -p "$(dirname "$dest")"
            cp "$file" "$dest"
        ' _ {} \;
    fi
else
    echo "Warning: source-repo/docs not found"
fi

# Create metadata file
cat > "${VERSION}/.meta.json" << EOF
{
  "source_commit": "${SOURCE_SHA}",
  "source_ref": "${SOURCE_REF}",
  "version": "${VERSION}",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo "Documentation sync complete for version ${VERSION}"

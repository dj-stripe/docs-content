# dj-stripe Documentation Content

This repository contains the documentation content for dj-stripe, synchronized from the main repository.

## Structure

-   `dev/` - Latest documentation from the main branch
-   `2.x/` - Documentation for stable version 2.x (e.g., `2.9/`, `2.8/`)
-   `versions.json` - Metadata about available versions
-   `LATEST` - File containing the latest stable version number

## How it works

1. When documentation changes are pushed to the main `dj-stripe` repository (main or stable/\* branches), a repository dispatch event is triggered
2. This repository receives the event and syncs the documentation content
3. The documentation is organized by version:
    - `main` branch → `dev/` directory
    - `stable/2.9` branch → `2.9/` directory
    - etc.
4. After syncing, a webhook triggers the website rebuild in `dj-stripe.github.io`

## Metadata

Each version directory contains a `.meta.json` file with sync information:

```json
{
	"source_commit": "abc123...",
	"source_ref": "refs/heads/main",
	"version": "dev",
	"updated_at": "2024-01-01T12:00:00Z"
}
```

## Assets

Assets (images, logos, etc.) are NOT synced from the main repository. They should be maintained directly in the `dj-stripe.github.io` website repository for better organization and performance.

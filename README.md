[![Images build and publish](https://github.com/Metadrop/docker-aljibe-tools/actions/workflows/docker-build-push.yml/badge.svg)](https://github.com/Metadrop/docker-aljibe-tools/actions/workflows/docker-build-push.yml)

# Aljibe Tools

This repository provides a Dockerfile with some tools used by [Aljibe ddev add-on](https://github.com/Metadrop/ddev-aljibe/).

## Available images

| Image | Package |
|-------|---------|
| `ghcr.io/metadrop/aljibe-tools` | [aljibe-tools](https://github.com/orgs/metadrop/packages/container/package/aljibe-tools) |
| `ghcr.io/metadrop/aljibe-tools/backstopjs` | [aljibe-tools/backstopjs](https://github.com/orgs/metadrop/packages/container/package/aljibe-tools%2Fbackstopjs) |
| `ghcr.io/metadrop/aljibe-tools/pa11y` | [aljibe-tools/pa11y](https://github.com/orgs/metadrop/packages/container/package/aljibe-tools%2Fpa11y) |
| `ghcr.io/metadrop/aljibe-tools/unlighthouse` | [aljibe-tools/unlighthouse](https://github.com/orgs/metadrop/packages/container/package/aljibe-tools%2Funlighthouse) |

## Tagging strategy

Tool images use a combined tag that encodes both the tool version and the base image version:

```
ghcr.io/metadrop/aljibe-tools/backstopjs:6.3.25-base1.0.0
                                          ^^^^^^  ^^^^^^^^
                                          tool    base image
                                          version version
```

This ensures that ddev addons always build their local image from the exact upstream image they expect. If a tag changes (because either the tool version or the base image was updated), ddev detects the new name and rebuilds.

**No `latest` tag is published.** All images are pinned to explicit versions.

### When are images built?

- **Tag push (`v*`)**: the base image is built and tagged with the semver version (e.g., `1.1.0`). All tool images are rebuilt against the new base and published with updated combined tags (e.g., `6.3.25-base1.1.0`).
- **Push to `main` with changes to `versions.*.json`**: only the affected tool images are rebuilt, using the latest base version tag.

### Releasing a new base image version

1. Modify `Dockerfile` as needed.
2. Push to `main`.
3. Create and push a semver tag: `git tag v1.1.0 && git push --tags` (or create a GitHub release). The CI builds everything automatically.

### Adding a new tool version

1. Add the new version to the relevant `versions.*.json` file.
2. Push to `main`. The CI builds only the affected tool images.

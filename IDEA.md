## Project description

A CI-driven pipeline that builds and distributes static FFmpeg binaries for eight platforms (Linux, macOS, Windows, FreeBSD × amd64/arm64). The project maintains a pre-baked Alpine build image (`ghcr.io/binmgr/ffmpeg:build`) containing all cross-compile toolchains, then runs FFmpeg builds inside that image. Published artifacts are standalone static binaries, per-platform tar.gz/zip archives, a Docker runtime image, and SHA-256 checksums — all tied to the latest stable FFmpeg release.

## Project variables

project_name: ffmpeg
project_org: binmgr
internal_name: ffmpeg
internal_org: binmgr
registry: ghcr.io
image_name: binmgr/ffmpeg
supported_platforms: linux-amd64, linux-arm64, darwin-amd64, darwin-arm64, windows-amd64, windows-arm64, freebsd-amd64, freebsd-arm64

## Business logic

**Must have:**
- Static FFmpeg binaries for all eight targets with no runtime shared-library dependencies
- Per-platform tar.gz archives (unix) and zip archives (windows) containing ffmpeg + ffprobe (+ ffplay where built)
- SHA-256 checksum file (`SHA256SUMS.txt`) covering every release asset
- Docker runtime image (`ghcr.io/binmgr/ffmpeg:latest`) for linux/amd64 and linux/arm64
- Builds trigger automatically on a monthly schedule and whenever the build environment image changes
- Manual trigger with optional version override
- All five CI providers (GitHub, Gitea, Forgejo, GitLab, Jenkins) must be kept in lockstep
- Security scanning on every push and PR (secret scan + image scan)

**Must NOT have:**
- Dynamically linked binaries — all codec and library dependencies must be compiled in statically
- Patched or modified FFmpeg source — build from official upstream tarballs only
- Platform-specific installer scripts — provide raw binaries and archives only

**Constraints:**
- Build environment image is built separately (`build-env-image` workflow) and referenced as a container in the binary build jobs
- windows-arm64 must run on a glibc host (ubuntu-latest) — llvm-mingw is a glibc binary that crashes under musl/Alpine
- Release only after all eight targets succeed (no partial releases)
- Binaries must be executable as-downloaded with no package manager required

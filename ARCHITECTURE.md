# FFmpeg Build Architecture

## Overview

This repository automatically builds static FFmpeg binaries for multiple platforms using a custom Alpine-based toolchain.

## Build Infrastructure

### Build Image
- **Repository**: [binmgr/ffmpeg](https://github.com/binmgr/ffmpeg)
- **Image**: `ghcr.io/binmgr/ffmpeg:build`
- **Base**: Alpine Linux (musl libc)
- **Purpose**: Prebuilt FFmpeg build environment for GitHub Actions
- **Architecture**: linux/amd64 (runs on x86_64 GitHub Actions runners)

### Supported Build Targets

| Platform | Architecture | Toolchain | Binary Type |
|----------|-------------|-----------|-------------|
| Linux | AMD64 | Native GCC (musl) | Truly static (no glibc) |
| Linux | ARM64 | musl.cc cross-compiler | Truly static (no glibc) |

## Binary Naming

All binaries follow the pattern: `ffmpeg-{platform}-{arch}`

- Suffixes (-gnu, -musl, -mingw, etc.) are automatically stripped
- Platform name: `linux`
- Architecture names: `amd64`, `arm64`

Examples:
- `ffmpeg-linux-amd64`
- `ffmpeg-linux-arm64`
- `ffprobe-linux-amd64`

## Build Process

### 1. Get Version
- Detects latest FFmpeg version from ffmpeg.org

### 2. Build Matrix
- Parallel builds for the Linux amd64 and arm64 targets
- Each build uses the pre-installed compilers from `ghcr.io/binmgr/ffmpeg:build`
- Configure flags are optimized for static linking

### 3. Release
- Collects the Linux binaries and ffprobe artifacts
- Generates SHA256 checksums for all files
- Creates GitHub release with version tag (e.g., `v8.0.1`)
- Includes build metadata in release notes

## Release Schedule

- **Quarterly**: 1st day of every third month (automated via cron)
- **Manual**: Via workflow_dispatch when needed
- **Push**: Triggered on pushes to main branch

## Local Testing

Use [act](https://github.com/nektos/act) to test workflows locally:

```bash
# Test version detection
act -j get-version

# Test a single architecture build
act -j build --matrix arch:amd64
```

See `ACT_USAGE.md` for detailed instructions.

## Release Contents

Every release includes:
- **Binaries**: `ffmpeg-linux-{arch}` and `ffprobe-linux-{arch}`
- **Checksums**: SHA256 hashes for verification
- **License**: GPLv2+ (referenced in release notes)

## Toolchain Details

The `ghcr.io/binmgr/ffmpeg:build` image includes:

**Pre-installed Libraries:**
- Compression: zlib, bzip2, xz, lz4, zstd
- Crypto: OpenSSL
- Images: libpng, libjpeg, giflib, libwebp, tiff
- Audio/Video: opus, vorbis, ogg, lame, theora, x264, libvpx, aom, fdk-aac
- Fonts: freetype
- Network/Crypto: curl, OpenSSL

**Linux Build Toolchains Ready:**
- Native amd64 toolchain and static libraries
- musl.cc ARM64 cross-compiler for Linux releases
- Consistent compiler setup across every GitHub Actions run

## Benefits of This Approach

✅ **Truly Portable**: Linux binaries use musl (no glibc dependency)
✅ **Fast**: Parallel builds, pre-installed toolchains
✅ **Reliable**: Consistent toolchains across GitHub Actions runs
✅ **Comprehensive**: Linux amd64/arm64 builds with bundled static dependencies
✅ **GPL Compliant**: GPL-licensed release artifacts with checksums
✅ **Reproducible**: Versioned build image in the same repository

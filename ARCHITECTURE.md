# FFmpeg Build Architecture

## Overview

This repository automatically builds static FFmpeg binaries for multiple platforms using a custom Alpine-based toolchain.

## Build Infrastructure

### Toolchain Image
- **Repository**: [binmgr/toolchain](https://github.com/binmgr/toolchain)
- **Image**: `ghcr.io/binmgr/toolchain:latest`
- **Base**: Alpine Linux (musl libc)
- **Size**: ~2-3 GB (comprehensive library coverage)
- **Architecture**: linux/amd64 (runs on x86_64 GitHub Actions runners)

### Supported Build Targets

| Platform | Architecture | Toolchain | Binary Type |
|----------|-------------|-----------|-------------|
| Linux | AMD64 | Native GCC (musl) | Truly static (no glibc) |
| Linux | ARM64 | Bootlin musl cross-compiler | Truly static (no glibc) |
| Windows | AMD64 | MinGW-w64 | Static |
| Windows | ARM64 | LLVM MinGW | Static |
| macOS | AMD64 | OSXCross | Partial static |
| macOS | ARM64 | OSXCross | Partial static |

## Binary Naming

All binaries follow the pattern: `ffmpeg-{platform}-{arch}`

- Suffixes (-gnu, -musl, -mingw, etc.) are automatically stripped
- Platform names: `linux`, `windows`, `darwin`
- Architecture names: `amd64`, `arm64`
- Windows extension: `.exe`

Examples:
- `ffmpeg-linux-amd64`
- `ffmpeg-windows-arm64.exe`
- `ffmpeg-darwin-amd64`

## Build Process

### 1. Get Version
- Detects latest FFmpeg version from ffmpeg.org
- Downloads source tarball (`ffmpeg-source.tar.xz`)
- Uploads as artifact for GPL compliance

### 2. Build Matrix
- Parallel builds for all 6 platforms
- Each build uses pre-installed cross-compilers from toolchain image
- Configure flags optimized for static linking
- ~7-10 minutes per platform

### 3. Release
- Collects all binaries and source
- Generates SHA256 checksums for all files
- Creates GitHub release with version tag (e.g., `v8.0.1`)
- Includes build metadata in release notes

## Release Schedule

- **Monthly**: 1st of each month (automated via cron)
- **Manual**: Via workflow_dispatch when needed
- **Push**: Triggered on pushes to main branch

## Local Testing

Use [act](https://github.com/nektos/act) to test workflows locally:

```bash
# Test version detection
act -j get-version

# Test a single platform build
act -j build --matrix os:linux --matrix arch:amd64
```

See `ACT_USAGE.md` for detailed instructions.

## GPL Compliance

Every release includes:
- **Source archive**: `ffmpeg-source.tar.xz` (exact source used)
- **Checksums**: SHA256 hashes for verification
- **License**: GPLv2+ (referenced in release notes)

## Toolchain Details

The `ghcr.io/binmgr/toolchain` image includes:

**60+ Pre-installed Libraries:**
- Compression: zlib, bzip2, xz, lz4, zstd
- Crypto: OpenSSL
- Images: libpng, libjpeg, giflib, libwebp, tiff
- Audio/Video: opus, vorbis, ogg, lame, theora, x264, x265, libvpx, aom, dav1d
- Fonts: freetype, fontconfig, fribidi, harfbuzz
- Network: curl, c-ares, nghttp2, libssh2
- Data: libxml2, expat, json-c, yaml, protobuf
- And more...

**All Cross-Compilers Ready:**
- No downloads during build time
- Faster builds (2-3 min savings)
- Reliable (no external dependency failures)
- Consistent across all builds

## Benefits of This Approach

✅ **Truly Portable**: Linux binaries use musl (no glibc dependency)
✅ **Fast**: Parallel builds, pre-installed toolchains
✅ **Reliable**: No external download failures during builds
✅ **Comprehensive**: 6 platforms, 60+ libraries
✅ **GPL Compliant**: Source included in every release
✅ **Reproducible**: Versioned toolchain image (YYMM tags)
✅ **Reusable**: Toolchain works for any binmgr project

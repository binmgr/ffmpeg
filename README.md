# FFmpeg Static Builds

[![Build Status](https://img.shields.io/badge/build-automated-brightgreen)]()
[![License](https://img.shields.io/badge/license-GPL--2.0-blue)](LICENSE.md)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-latest-orange)](https://ffmpeg.org)

> **Fully static, multi-platform FFmpeg binaries with all features enabled**

---

## Overview

This repository provides automated builds of FFmpeg as **fully static binaries** for multiple platforms and architectures. Binaries are built using **musl libc** for maximum portability and are stripped for minimal size.

```
┌─────────────────────────────────────────────────────────────────┐
│                    Supported Platforms                          │
├─────────────────┬─────────────────┬─────────────────────────────┤
│    Platform     │   Architectures │         Binary Name         │
├─────────────────┼─────────────────┼─────────────────────────────┤
│    Linux        │  amd64, arm64   │  ffmpeg-linux-{arch}        │
│    Windows      │  amd64, arm64   │  ffmpeg-windows-{arch}.exe  │
│    macOS        │  amd64, arm64   │  ffmpeg-darwin-{arch}       │
│    FreeBSD      │  amd64, arm64   │  ffmpeg-freebsd-{arch}      │
└─────────────────┴─────────────────┴─────────────────────────────┘
```

## Download

### Latest Release

Download the latest binaries from the [Releases](../../releases/latest) page.

| Platform | AMD64 | ARM64 |
|----------|-------|-------|
| **Linux** | [`ffmpeg-linux-amd64`](../../releases/latest/download/ffmpeg-linux-amd64) | [`ffmpeg-linux-arm64`](../../releases/latest/download/ffmpeg-linux-arm64) |
| **Windows** | [`ffmpeg-windows-amd64.exe`](../../releases/latest/download/ffmpeg-windows-amd64.exe) | [`ffmpeg-windows-arm64.exe`](../../releases/latest/download/ffmpeg-windows-arm64.exe) |
| **macOS** | [`ffmpeg-darwin-amd64`](../../releases/latest/download/ffmpeg-darwin-amd64) | [`ffmpeg-darwin-arm64`](../../releases/latest/download/ffmpeg-darwin-arm64) |
| **FreeBSD** | [`ffmpeg-freebsd-amd64`](../../releases/latest/download/ffmpeg-freebsd-amd64) | [`ffmpeg-freebsd-arm64`](../../releases/latest/download/ffmpeg-freebsd-arm64) |

### Checksums

Each release includes SHA256 checksums in `checksums.txt` for verification:

```bash
# Verify download
sha256sum -c checksums.txt
```

## Features

### Enabled Encoders/Decoders

| Category | Codecs |
|----------|--------|
| **Video** | H.264 (x264), H.265/HEVC (x265), VP8/VP9 (libvpx), AV1 (aom, dav1d, svt-av1), MPEG-4, ProRes, DNxHD, and more |
| **Audio** | AAC (fdk-aac), MP3 (lame), Opus, Vorbis, FLAC, AC3, DTS, and more |
| **Image** | PNG, JPEG, WebP, GIF, TIFF, BMP |
| **Subtitle** | SRT, ASS/SSA, WebVTT, PGS, DVB |

### Enabled Features

- Hardware acceleration support (where available)
- All demuxers and muxers
- All protocols (HTTP, HTTPS, RTMP, RTSP, HLS, etc.)
- All filters (video, audio, subtitle)
- Metadata handling
- Streaming support
- Network protocols with TLS/SSL

### Build Configuration

```bash
--enable-gpl
--enable-version3
--enable-nonfree
--enable-static
--disable-shared
--enable-libx264
--enable-libx265
--enable-libvpx
--enable-libopus
--enable-libvorbis
--enable-libmp3lame
--enable-libfdk-aac
--enable-libaom
--enable-libdav1d
--enable-libsvtav1
--enable-libass
--enable-libfreetype
--enable-libfontconfig
--enable-libvidstab
--enable-librubberband
--enable-libzimg
# ... and many more
```

## Build Schedule

| Trigger | Description |
|---------|-------------|
| **Push** | Builds on every push to main branch |
| **Monthly** | Scheduled build on the 1st of each month |
| **Manual** | Can be triggered manually via workflow dispatch |

## Version Scheme

Release versions follow FFmpeg's version numbering:

```
v{FFMPEG_VERSION}

Example: v7.1, v6.1.1
```

## Multi-Architecture Support

All builds include proper OCI annotations for multi-architecture support:

| Label | Description |
|-------|-------------|
| `org.opencontainers.image.title` | FFmpeg Static Build |
| `org.opencontainers.image.version` | FFmpeg version |
| `org.opencontainers.image.os` | Target operating system |
| `org.opencontainers.image.architecture` | Target architecture |
| `org.opencontainers.image.created` | Build timestamp |
| `org.opencontainers.image.source` | Repository URL |
| `org.opencontainers.image.revision` | Git commit SHA |

## CI/CD Platform Support

This repository includes workflows for multiple CI/CD platforms:

| Platform | Workflow File | Status |
|----------|---------------|--------|
| **GitHub Actions** | `.github/workflows/build.yml` | Full support |
| **GitLab CI** | `.gitlab-ci.yml` | Full support |
| **Gitea Actions** | `.gitea/workflows/build.yml` | Full support |
| **Nektos/act** | Compatible with GitHub Actions | Local testing |

### Running Locally with Nektos/act

```bash
# Install act (https://github.com/nektos/act)
# Then run:
act push
```

## Usage Examples

### Basic Conversion

```bash
# Convert video to H.264
./ffmpeg-linux-amd64 -i input.mp4 -c:v libx264 -crf 23 output.mp4

# Convert to H.265/HEVC
./ffmpeg-linux-amd64 -i input.mp4 -c:v libx265 -crf 28 output.mp4

# Convert to AV1
./ffmpeg-linux-amd64 -i input.mp4 -c:v libaom-av1 -crf 30 output.mp4
```

### Audio Extraction

```bash
# Extract audio as MP3
./ffmpeg-linux-amd64 -i input.mp4 -vn -c:a libmp3lame -q:a 2 output.mp3

# Extract audio as AAC
./ffmpeg-linux-amd64 -i input.mp4 -vn -c:a libfdk_aac -b:a 192k output.m4a

# Extract audio as Opus
./ffmpeg-linux-amd64 -i input.mp4 -vn -c:a libopus -b:a 128k output.opus
```

### Streaming

```bash
# Stream to RTMP
./ffmpeg-linux-amd64 -i input.mp4 -c:v libx264 -f flv rtmp://server/live/stream

# Create HLS stream
./ffmpeg-linux-amd64 -i input.mp4 -c:v libx264 -c:a aac -f hls -hls_time 10 playlist.m3u8
```

### Image Processing

```bash
# Extract frames
./ffmpeg-linux-amd64 -i input.mp4 -vf "fps=1" frame_%04d.png

# Create thumbnail
./ffmpeg-linux-amd64 -i input.mp4 -ss 00:00:05 -vframes 1 thumbnail.jpg

# Create GIF
./ffmpeg-linux-amd64 -i input.mp4 -vf "fps=10,scale=320:-1" output.gif
```

## Build Matrix

```
┌──────────┬─────────┬─────────┬─────────┬─────────┐
│          │  Linux  │ Windows │  macOS  │ FreeBSD │
├──────────┼─────────┼─────────┼─────────┼─────────┤
│  amd64   │    ✓    │    ✓    │    ✓    │    ✓    │
│  arm64   │    ✓    │    ✓    │    ✓    │    ✓    │
└──────────┴─────────┴─────────┴─────────┴─────────┘
```

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions workflow
├── .gitea/
│   └── workflows/
│       └── build.yml          # Gitea Actions workflow
├── .gitlab-ci.yml             # GitLab CI configuration
├── LICENSE.md                 # License information
├── README.md                  # This file
└── Makefile                   # Local build helpers
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

### Building Locally

```bash
# Clone the repository
git clone <repository-url>
cd ffmpeg

# Build for current platform (requires Docker)
make build-local

# Build all platforms
make build-all
```

## License

The binaries are licensed under **GPL v2 or later** due to included GPL components (x264, x265, etc.).

Build scripts in this repository are licensed under the **MIT License**.

See [LICENSE.md](LICENSE.md) for full details.

## Links

- [FFmpeg Official Website](https://ffmpeg.org)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)
- [FFmpeg Wiki](https://trac.ffmpeg.org/wiki)

---

<p align="center">
  <i>Built with automated CI/CD pipelines</i>
</p>

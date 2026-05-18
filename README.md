# FFmpeg Static Builds

[![Build Environment](https://github.com/binmgr/ffmpeg/actions/workflows/build-env-image.yml/badge.svg)](https://github.com/binmgr/ffmpeg/actions/workflows/build-env-image.yml)
[![Build Binaries](https://github.com/binmgr/ffmpeg/actions/workflows/build-binaries.yml/badge.svg)](https://github.com/binmgr/ffmpeg/actions/workflows/build-binaries.yml)
[![License](https://img.shields.io/badge/license-GPL--2.0-blue)](LICENSE.md)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-latest-orange)](https://ffmpeg.org)

Fully static, multi-platform FFmpeg binaries — no dependencies, runs anywhere. Pre-built for Linux, macOS, Windows, and FreeBSD on both amd64 and arm64. Binaries are stripped and statically linked against musl libc (Linux) or cross-compiled natively (macOS, Windows, FreeBSD).

---

## 📦 Install

Download the latest release from the [Releases](../../releases/latest) page, or use the one-liners below.

### Linux

| Arch | Archive (ffmpeg + ffprobe + ffplay) | Binary only |
|------|-------------------------------------|-------------|
| **amd64** | [`ffmpeg-linux-amd64.tar.gz`](../../releases/latest/download/ffmpeg-linux-amd64.tar.gz) | [`ffmpeg-linux-amd64`](../../releases/latest/download/ffmpeg-linux-amd64) |
| **arm64** | [`ffmpeg-linux-arm64.tar.gz`](../../releases/latest/download/ffmpeg-linux-arm64.tar.gz) | [`ffmpeg-linux-arm64`](../../releases/latest/download/ffmpeg-linux-arm64) |

```bash
# amd64 — extract and install
curl -LSsf https://github.com/binmgr/ffmpeg/releases/latest/download/ffmpeg-linux-amd64.tar.gz \
  | tar -xz -C /usr/local/bin

# arm64
curl -LSsf https://github.com/binmgr/ffmpeg/releases/latest/download/ffmpeg-linux-arm64.tar.gz \
  | tar -xz -C /usr/local/bin
```

> Linux archives include `ffmpeg` + `ffprobe` + `ffplay`. The amd64 build has full X11 + Wayland + ALSA support; arm64 has minimal SDL2 (dummy/offscreen only).

### macOS

| Arch | Archive (ffmpeg + ffprobe) | Binary only |
|------|----------------------------|-------------|
| **Intel (amd64)** | [`ffmpeg-darwin-amd64.tar.gz`](../../releases/latest/download/ffmpeg-darwin-amd64.tar.gz) | [`ffmpeg-darwin-amd64`](../../releases/latest/download/ffmpeg-darwin-amd64) |
| **Apple Silicon (arm64)** | [`ffmpeg-darwin-arm64.tar.gz`](../../releases/latest/download/ffmpeg-darwin-arm64.tar.gz) | [`ffmpeg-darwin-arm64`](../../releases/latest/download/ffmpeg-darwin-arm64) |

```bash
# Detect arch automatically
ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
curl -LSsf "https://github.com/binmgr/ffmpeg/releases/latest/download/ffmpeg-darwin-${ARCH}.tar.gz" \
  | tar -xz -C /usr/local/bin
# Remove macOS quarantine flag
xattr -d com.apple.quarantine /usr/local/bin/ffmpeg /usr/local/bin/ffprobe 2>/dev/null || true
```

### Windows

| Arch | Archive (ffmpeg + ffprobe) |
|------|----------------------------|
| **amd64** | [`ffmpeg-windows-amd64.zip`](../../releases/latest/download/ffmpeg-windows-amd64.zip) |
| **arm64** | [`ffmpeg-windows-arm64.zip`](../../releases/latest/download/ffmpeg-windows-arm64.zip) |

Download and extract the zip, then add the folder to `%PATH%`.

### FreeBSD

| Arch | Archive (ffmpeg + ffprobe) | Binary only |
|------|----------------------------|-------------|
| **amd64** | [`ffmpeg-freebsd-amd64.tar.gz`](../../releases/latest/download/ffmpeg-freebsd-amd64.tar.gz) | [`ffmpeg-freebsd-amd64`](../../releases/latest/download/ffmpeg-freebsd-amd64) |
| **arm64** | [`ffmpeg-freebsd-arm64.tar.gz`](../../releases/latest/download/ffmpeg-freebsd-arm64.tar.gz) | [`ffmpeg-freebsd-arm64`](../../releases/latest/download/ffmpeg-freebsd-arm64) |

```bash
ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
curl -LSsf "https://github.com/binmgr/ffmpeg/releases/latest/download/ffmpeg-freebsd-${ARCH}.tar.gz" \
  | tar -xz -C /usr/local/bin
```

### ✅ Verify checksums

```bash
curl -LSsf https://github.com/binmgr/ffmpeg/releases/latest/download/SHA256SUMS.txt -O
sha256sum -c SHA256SUMS.txt
```

---

## 🐳 Docker

```bash
docker run --rm ghcr.io/binmgr/ffmpeg:latest -version
```

Tags: `latest`, `{ffmpeg-version}` (e.g. `8.1.1`), `YYMM` (e.g. `2505`)

> The runtime image is built `FROM scratch` and contains only `ffmpeg` + `ffprobe` for `linux/amd64` and `linux/arm64`.

---

## Platforms

```
┌──────────┬─────────┬─────────┬─────────┬─────────┐
│          │  Linux  │  macOS  │ Windows │ FreeBSD │
├──────────┼─────────┼─────────┼─────────┼─────────┤
│  amd64   │    ✓    │    ✓    │    ✓    │    ✓    │
│  arm64   │    ✓    │    ✓    │    ✓    │    ✓    │
└──────────┴─────────┴─────────┴─────────┴─────────┘
```

All binaries are **fully statically linked** — no libc, no system libraries required at runtime.

---

## Included codecs & features

| Category | Libraries |
|----------|-----------|
| **Video encode** | H.264 (`libx264`), H.265/HEVC (`libx265`), VP8/VP9 (`libvpx`), AV1 (`libaom`, `libsvtav1`) |
| **Video decode** | All of the above + AV1 (`libdav1d`) and all built-in FFmpeg decoders |
| **Audio** | AAC (`libfdk-aac`), MP3 (`libmp3lame`), Opus (`libopus`), Vorbis (`libvorbis`) |
| **Subtitles** | ASS/SSA (`libass`), SRT, WebVTT, PGS |
| **Filters** | Stabilisation (`libvidstab`), time-stretching (`librubberband`), scaling (`libzimg`), fonts (`libfreetype`, `libfontconfig`) |
| **Network** | TLS/SSL (`openssl`), HTTP/S, RTMP, RTSP, HLS, DASH |
| **Display** | SDL2 — Linux amd64: X11 + Wayland (native) + ALSA; Linux arm64: minimal SDL2 |

> The full codec set above applies to Linux builds. macOS, Windows, and FreeBSD builds use a base feature set (`--enable-gpl --enable-version3 --enable-nonfree --enable-static`); no codec-specific flags are passed for those targets, so codec availability depends on what FFmpeg detects in the cross-sysroot.

### Linux build flags

```
--enable-gpl --enable-version3 --enable-nonfree
--enable-static --disable-shared
--enable-ffplay --enable-sdl2
--enable-libx264 --enable-libx265 --enable-libvpx
--enable-libopus --enable-libvorbis --enable-libmp3lame --enable-libfdk-aac
--enable-libaom --enable-libdav1d --enable-libsvtav1
--enable-libass --enable-libfreetype --enable-libfontconfig
--enable-libvidstab --enable-librubberband --enable-libzimg
--enable-openssl
```

---

## Usage examples

```bash
# Convert to H.264
ffmpeg -i input.mp4 -c:v libx264 -crf 23 output.mp4

# Convert to H.265
ffmpeg -i input.mp4 -c:v libx265 -crf 28 output.mp4

# Convert to AV1
ffmpeg -i input.mp4 -c:v libsvtav1 -crf 35 output.mp4

# Extract audio as MP3
ffmpeg -i input.mp4 -vn -c:a libmp3lame -q:a 2 audio.mp3

# Probe media info
ffprobe -v quiet -print_format json -show_format -show_streams input.mp4

# Play a file (Linux amd64 — requires X11 or Wayland)
ffplay input.mp4
```

---

## How it works

```
docker/Dockerfile.build  →  ghcr.io/binmgr/ffmpeg:build  (Alpine build env)
                                         │
                              build-binaries.yml
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                     │
              7-target matrix      windows-arm64         release job
              (in :build image)   (ubuntu-latest,      (creates GitHub
                                   llvm-mingw)          release + Docker
                                                        runtime image)
```

**Build environment:** All 7 non-Windows-ARM64 targets build inside `ghcr.io/binmgr/ffmpeg:build` — an Alpine-based Docker image with cross-compile toolchains for every target pre-installed. Windows-ARM64 uses `ubuntu-latest` because `llvm-mingw` is a glibc binary that crashes on Alpine/musl.

**Multi-provider CI:** The repository ships CI configs for three providers. Each builds all 8 targets independently:
- **GitHub Actions** (`.github/workflows/`) — primary; publishes GitHub Releases and `ghcr.io` Docker image
- **Gitea / Forgejo** (`.gitea/workflows/`) — compatible workflow syntax; triggers on push and monthly schedule
- **GitLab CI** (`.gitlab-ci.yml`) — publishes GitLab Releases via the GitLab API

**Build triggers:**
- `docker/Dockerfile.build` or `build-env-image.yml` changed → rebuild `:build` image → rebuild binaries
- Build environment (`:build` image) rebuilds **quarterly** (1st of every 3rd month)
- Binaries rebuild **monthly** (1st of every month)
- Manual dispatch (with optional version override)

---

## Repository structure

```
.
├── .github/
│   └── workflows/
│       ├── build-env-image.yml   # builds ghcr.io/binmgr/ffmpeg:build (quarterly)
│       └── build-binaries.yml    # builds all 8 targets + GitHub release (monthly)
├── .gitea/
│   └── workflows/
│       ├── build-env-image.yml   # Gitea/Forgejo: build environment image
│       └── build-binaries.yml    # Gitea/Forgejo: build all 8 targets
├── docker/
│   ├── Dockerfile                # Runtime image (FROM scratch, ffmpeg + ffprobe)
│   └── Dockerfile.build          # Alpine build environment + build-ffmpeg script
├── .gitlab-ci.yml                # GitLab CI: build all 8 targets + GitLab release
├── .actrc                        # act (local CI runner) configuration
├── ACT_USAGE.md                  # Guide for running CI locally with act
├── ARCHITECTURE.md               # Detailed build architecture notes
├── QUICKSTART.md                 # Quick-start guide
├── LICENSE.md
└── README.md
```

---

## 🛠️ Development

The build is entirely CI-driven. There is no local toolchain requirement — all compilation happens inside `ghcr.io/binmgr/ffmpeg:build`.

**Run a single target locally:**

```bash
docker pull ghcr.io/binmgr/ffmpeg:build
docker run --rm -v "$PWD/output:/output" ghcr.io/binmgr/ffmpeg:build \
  build-ffmpeg linux-amd64
```

**Run the full CI pipeline locally with `act`:**

```bash
# Requires: act (https://github.com/nektos/act)
act -j build
```

The `.actrc` at the repo root pre-configures the runner image. See the [act docs](https://github.com/nektos/act) for full usage.

---

## 📄 License

Binaries are licensed under **GPL v2 or later** due to included GPL components (x264, x265, etc.).
Build scripts in this repository are licensed under the **MIT License** — see [LICENSE.md](LICENSE.md).

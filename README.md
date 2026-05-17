# FFmpeg Static Builds

[![Build Environment](https://github.com/binmgr/ffmpeg/actions/workflows/build-env-image.yml/badge.svg)](https://github.com/binmgr/ffmpeg/actions/workflows/build-env-image.yml)
[![Build Binaries](https://github.com/binmgr/ffmpeg/actions/workflows/build-binaries.yml/badge.svg)](https://github.com/binmgr/ffmpeg/actions/workflows/build-binaries.yml)
[![License](https://img.shields.io/badge/license-GPL--2.0-blue)](LICENSE.md)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-latest-orange)](https://ffmpeg.org)

> **Fully static, multi-platform FFmpeg binaries — no dependencies, runs anywhere**

---

## Download

Grab the latest from the [Releases](../../releases/latest) page.

### 📦 Archives (recommended) — ffmpeg + ffprobe + ffplay

| Platform | AMD64 | ARM64 |
|----------|-------|-------|
| **Linux** | [`ffmpeg-linux-amd64.tar.gz`](../../releases/latest/download/ffmpeg-linux-amd64.tar.gz) | [`ffmpeg-linux-arm64.tar.gz`](../../releases/latest/download/ffmpeg-linux-arm64.tar.gz) |
| **macOS** | [`ffmpeg-darwin-amd64.tar.gz`](../../releases/latest/download/ffmpeg-darwin-amd64.tar.gz) | [`ffmpeg-darwin-arm64.tar.gz`](../../releases/latest/download/ffmpeg-darwin-arm64.tar.gz) |
| **FreeBSD** | [`ffmpeg-freebsd-amd64.tar.gz`](../../releases/latest/download/ffmpeg-freebsd-amd64.tar.gz) | [`ffmpeg-freebsd-arm64.tar.gz`](../../releases/latest/download/ffmpeg-freebsd-arm64.tar.gz) |
| **Windows** | [`ffmpeg-windows-amd64.zip`](../../releases/latest/download/ffmpeg-windows-amd64.zip) | [`ffmpeg-windows-arm64.zip`](../../releases/latest/download/ffmpeg-windows-arm64.zip) |

> **Archive contents:**
> - Linux: `ffmpeg` + `ffprobe` + `ffplay` (X11 + Wayland + ALSA on amd64)
> - macOS / FreeBSD / Windows: `ffmpeg` + `ffprobe`

### ⚡ Direct ffmpeg binary only

| Platform | AMD64 | ARM64 |
|----------|-------|-------|
| **Linux** | [`ffmpeg-linux-amd64`](../../releases/latest/download/ffmpeg-linux-amd64) | [`ffmpeg-linux-arm64`](../../releases/latest/download/ffmpeg-linux-arm64) |
| **macOS** | [`ffmpeg-darwin-amd64`](../../releases/latest/download/ffmpeg-darwin-amd64) | [`ffmpeg-darwin-arm64`](../../releases/latest/download/ffmpeg-darwin-arm64) |
| **FreeBSD** | [`ffmpeg-freebsd-amd64`](../../releases/latest/download/ffmpeg-freebsd-amd64) | [`ffmpeg-freebsd-arm64`](../../releases/latest/download/ffmpeg-freebsd-arm64) |
| **Windows** | [`ffmpeg-windows-amd64.exe`](../../releases/latest/download/ffmpeg-windows-amd64.exe) | [`ffmpeg-windows-arm64.exe`](../../releases/latest/download/ffmpeg-windows-arm64.exe) |

### 🐳 Docker image

```bash
docker run --rm ghcr.io/binmgr/ffmpeg:latest -version
```

Tags: `latest`, `{ffmpeg-version}` (e.g. `8.1.1`), `YYMM` (e.g. `2505`)

### ✅ Verify checksums

```bash
sha256sum -c SHA256SUMS.txt
```

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
# Make the binary executable (Linux/macOS/FreeBSD)
chmod +x ffmpeg ffprobe

# Convert to H.264
./ffmpeg -i input.mp4 -c:v libx264 -crf 23 output.mp4

# Convert to H.265
./ffmpeg -i input.mp4 -c:v libx265 -crf 28 output.mp4

# Convert to AV1
./ffmpeg -i input.mp4 -c:v libsvtav1 -crf 35 output.mp4

# Extract audio as MP3
./ffmpeg -i input.mp4 -vn -c:a libmp3lame -q:a 2 audio.mp3

# Probe media info
./ffprobe -v quiet -print_format json -show_format -show_streams input.mp4

# Play a file (Linux — requires X11 or Wayland)
./ffplay input.mp4
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

**Build triggers:**
- `docker/Dockerfile.build` changed → rebuild `:build` image → rebuild binaries
- Monthly on the 1st
- Manual dispatch (with optional version override)

---

## Repository structure

```
.
├── .github/
│   └── workflows/
│       ├── build-env-image.yml   # builds ghcr.io/binmgr/ffmpeg:build
│       └── build-binaries.yml    # builds all 8 targets + release
├── docker/
│   └── Dockerfile.build          # Alpine build environment + build-ffmpeg script
├── Dockerfile                    # Runtime image (FROM scratch, ffmpeg + ffprobe)
├── LICENSE.md
└── README.md
```

---

## License

Binaries are licensed under **GPL v2 or later** due to included GPL components (x264, x265, etc.).
Build scripts in this repository are licensed under the **MIT License** — see [LICENSE.md](LICENSE.md).

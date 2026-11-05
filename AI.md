# FFmpeg — Implementation Spec (HOW)

## Source of truth

Project-specific values live in `IDEA.md`. Placeholders like `{project_name}` resolve from `IDEA.md § Project variables`. Rule overrides live in `SPEC.md`.

---

## Directory layout

```
{project_name}/
├── docker/
│   ├── Dockerfile.build      # Alpine build environment + build-ffmpeg script
│   └── Dockerfile            # Runtime image: scratch + ffmpeg + ffprobe (linux amd64/arm64)
├── .github/
│   ├── CODEOWNERS
│   ├── ISSUE_TEMPLATE/
│   ├── pull_request_template.md
│   ├── SECURITY.md
│   └── workflows/
│       ├── build-env-image.yml   # Builds ghcr.io/{project_org}/{project_name}:build
│       ├── build-binaries.yml    # Builds 8 targets, archives, release, runtime image
│       └── security.yml          # secret-scan + workflow-policy + image-scan
├── .gitea/workflows/             # Gitea mirror (pull-or-build image, Gitea release API)
├── .forgejo/workflows/           # Forgejo mirror (same as Gitea)
├── .actrc                        # act config for local workflow validation
├── .gitlab-ci.yml                # GitLab mirror (docker-in-docker)
├── Jenkinsfile                   # Verification-only mirror
├── AI.md                         # This file
├── IDEA.md                       # Project plan (WHAT)
├── LICENSE.md
├── Makefile                      # build-env, build, validate, test, clean
├── README.md
├── SPEC.md                       # Project-specific rule overrides
└── renovate.json
```

All five CI providers (GitHub, Gitea, Forgejo, GitLab, Jenkins) are kept in lockstep: a change to targets, versions, or release steps is made in every one.

---

## Build image (`docker/Dockerfile.build`)

- Base `alpine:3.21`. Static dependency libraries are built once per architecture; every codec library version is an `ARG` at the top of the file and is changed deliberately.
- Cross toolchains: Bootlin aarch64 musl (linux-arm64), mingw-w64 (windows-amd64), osxcross + MacOSX SDK (darwin), clang + lld with FreeBSD sysroots (freebsd).
- `build-ffmpeg <os>-<arch> [version]` downloads the upstream tarball (latest when the version is omitted), configures, builds, and writes `ffmpeg-<target>`, `ffprobe-<target>`, optional `ffplay-<target>` (Linux), and `VERSION` to `/output`.
- `windows-arm64` is not built in this image: `llvm-mingw` is a glibc binary that crashes on Alpine, so every provider builds that target inline on an Ubuntu runner.

### Feature sets

- Linux: full codec set (x264, x265, libvpx, aom, dav1d, SVT-AV1, opus, vorbis, lame, fdk-aac, libass, freetype, fontconfig, vidstab, rubberband, zimg, openssl) plus ffplay/SDL2 (X11, Wayland, ALSA on amd64; minimal SDL2 on arm64).
- macOS, Windows, FreeBSD: base feature set (`--enable-gpl --enable-version3 --enable-nonfree --enable-static`).

---

## Versioning

- No version file in the repo. `get-version` scrapes the latest release from `https://ffmpeg.org/releases/`, or uses the `ffmpeg_version` / `FFMPEG_VERSION_OVERRIDE` input.
- Release tag: `v{version}`. Docker tags: `latest`, `{version}`, `YYMM`.

---

## Workflow triggers

| Workflow | Triggers |
|----------|----------|
| `build-env-image` | push touching `docker/Dockerfile.build`; quarterly cron; manual |
| `build-binaries` (GitHub) | successful `build-env-image` run; monthly cron; manual with optional version |
| `build-binaries` (Gitea/Forgejo) | push touching `docker/` or the workflow; monthly cron; manual |
| `security` | push, PR, weekly cron, manual |

---

## Release assets

- `ffmpeg-{os}-{arch}[.exe]` direct binaries for all eight targets.
- `ffmpeg-{os}-{arch}.tar.gz` (unix: ffmpeg, ffprobe, ffplay on Linux) and `ffmpeg-{os}-{arch}.zip` (windows: ffmpeg.exe, ffprobe.exe).
- `SHA256SUMS.txt` covering every asset.

## Runtime image

`docker/Dockerfile`: `FROM scratch` with `/usr/local/bin/ffmpeg` and `/usr/local/bin/ffprobe`, `ENTRYPOINT ["/usr/local/bin/ffmpeg"]`. Built with context `.` for `linux/amd64,linux/arm64` after the release job copies the Linux binaries into the repo root.

---

## Security

- Every `uses:` in every workflow is pinned to a 40-char SHA (enforced by `security.yml § workflow-policy`); `pull_request_target` is forbidden.
- `security.yml` runs truffleHog on pushes/PRs and Trivy on the build (informational) and runtime (fail on CRITICAL/HIGH) images.
- Only `GITHUB_TOKEN` (and `GITEA_TOKEN` on Gitea/Forgejo) is used; no other secrets.

---

## Local use

```
make build-env
make build TARGET=linux-amd64
make validate
```

# Project-specific rule overrides

This file wins over AI.md which wins over global CLAUDE.md.
Only rules that actively differ from the defaults are listed here.

---

## Exception 1 — Gitea/GitLab CI uses per-job toolchain setup

**Default rule:** CI binary builds run inside `ghcr.io/binmgr/ffmpeg:build` (pre-baked Alpine
image with all cross-compile toolchains pre-installed).

**Override:** The `.gitea/workflows/build-binaries.yml` and `.gitlab-ci.yml` pipelines install the
build toolchain (LLVM, osxcross, MinGW, musl cross-compilers) fresh in each job on `ubuntu-latest`
instead of using the pre-baked container image.

**Rationale:** Gitea/GitLab CI is often run on self-hosted runners that may not have access to
`ghcr.io`. Installing the toolchain inline keeps those pipelines runnable without registry access or
pre-pulled images — important for air-gapped or self-hosted deployments.

---

## Exception 2 — Dockerfile.build downloads source tarballs without SHA-256 verification

**Default rule:** All downloaded artifacts must be verified against a known-good checksum before
use.

**Override:** `docker/Dockerfile.build` downloads FFmpeg source tarballs and third-party library
sources (x264, x265, libvpx, etc.) over HTTPS without pinning or verifying SHA-256 digests.

**Rationale:** Maintaining a pinned digest table for every upstream library source tarball is a
significant ongoing maintenance burden. HTTPS transport provides integrity in transit; the build
environment is rebuilt from scratch on each run. Upstream supply-chain compromise would be detected
by the release checksum (`SHA256SUMS.txt`) diverging from prior builds.

**Accepted risk:** A targeted MITM or CDN-level compromise of an upstream source tarball would not
be caught before the binary is built. This is accepted as a maintenance trade-off.

---

## Exception 3 — Build and release are combined in `build-binaries.yml`

**Default rule:** Separate `build.yml` and `release.yml` workflows.

**Override:** Build and release are a single workflow. The binary build IS the release — there is no
intermediate integration step where artifacts are tested before publishing.

**Rationale:** FFmpeg builds are fully deterministic given the same source version. A separate
release gate would add no new signal.

---

## Exception 4 — No AI.md language template

**Default rule:** Projects copy the Go or Rust `AI.md` template at setup.

**Override:** This is a CI/distribution project — no Go, Rust, Node, or Python source code is
maintained in this repository. No language template applies. `AI.md` is omitted.

---

## Exception 5 — GitLab CI Docker image digest pinning deferred

**Default rule:** GitLab CI job images must be pinned by digest (`image: alpine@sha256:{digest}`).

**Override:** `.gitlab-ci.yml` job images are currently pinned by tag only (e.g. `alpine:3`).
Digest pinning requires a live Docker daemon to resolve digests and is deferred until a Renovate
GitLab integration or a CI helper script is added.

**Action required:** Resolve when Renovate GitLab support is wired up or when a `pin-digests.sh`
helper is added to the Makefile.

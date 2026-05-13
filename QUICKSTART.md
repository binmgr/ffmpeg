# Quick Start Guide

## Current Status

✅ **Build Image Built**: `ghcr.io/binmgr/ffmpeg:build`
🎯 **Ready**: FFmpeg workflow configured for Linux amd64 and arm64

## Testing the Build

```bash
# Trigger a test build
gh workflow run build.yml

# Watch the build
gh run list --limit 1
gh run watch <run-id>
```

## Expected Results

The build will produce 4 static Linux binaries:

```
ffmpeg-linux-amd64           (truly static, musl)
ffmpeg-linux-arm64           (truly static, musl)
ffprobe-linux-amd64          (truly static, musl)
ffprobe-linux-arm64          (truly static, musl)
checksums.txt                (SHA256 for all files)
```

## Build Time Estimate

- **get-version**: ~10 seconds
- **build matrix**: ~7-10 minutes per architecture (parallel)
- **release**: ~1-2 minutes

## If Builds Fail

Check logs:
```bash
gh run view <run-id> --log-failed
```

Common issues:
- **ARM64 failures**: cross-compiler or static-linking issues
- **Image drift**: rerun `build-image.yml` before rerunning `build.yml` after changing `docker/Dockerfile.build`

## Local Testing with Act

```bash
# Quick test (version detection)
act -j get-version

# Test one architecture build
act -j build --matrix arch:amd64
```

See `ACT_USAGE.md` for details.

## Repositories

- **FFmpeg**: https://github.com/binmgr/ffmpeg (this repo)
- **Build image**: `ghcr.io/binmgr/ffmpeg:build`

## Architecture

See `ARCHITECTURE.md` for complete technical details.

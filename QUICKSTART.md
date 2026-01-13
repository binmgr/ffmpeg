# Quick Start Guide

## Current Status

✅ **Toolchain Image Built**: `ghcr.io/binmgr/toolchain:latest`
⏳ **Waiting**: Package needs to be made public
🎯 **Ready**: FFmpeg workflow configured for 6 platforms

## Making the Toolchain Public

1. Visit: https://github.com/orgs/binmgr/packages/container/package/toolchain/settings
2. Scroll to "Danger Zone"
3. Click "Change visibility" → Select "Public"
4. Confirm

## Testing the Build

Once the toolchain is public:

```bash
# Trigger a test build
gh workflow run build.yml

# Watch the build
gh run list --limit 1
gh run watch <run-id>
```

## Expected Results

The build will produce 6 static binaries + source:

```
ffmpeg-linux-amd64           (truly static, musl)
ffmpeg-linux-arm64           (truly static, musl)
ffmpeg-windows-amd64.exe     (static, LLVM MinGW)
ffmpeg-windows-arm64.exe     (static, LLVM MinGW)
ffmpeg-darwin-amd64          (OSXCross)
ffmpeg-darwin-arm64          (OSXCross)
ffmpeg-source.tar.xz         (GPL compliance)
checksums.txt                (SHA256 for all files)
```

## Build Time Estimate

- **get-version**: ~10 seconds
- **build matrix**: ~7-10 minutes per platform (parallel)
- **release**: ~1-2 minutes

**Total: ~10-12 minutes** for all 6 platforms in parallel

## If Builds Fail

Check logs:
```bash
gh run view <run-id> --log-failed
```

Common issues:
- **OSXCross failures**: macOS builds may fail (can be disabled)
- **ARM64 failures**: Cross-compiler issues (can be disabled)
- **Minimum working**: Linux AMD64 + Windows AMD64 should always work

## Local Testing with Act

```bash
# Quick test (version detection)
act -j get-version

# Test one platform build
act -j build --matrix os:linux --matrix arch:amd64
```

See `ACT_USAGE.md` for details.

## Repositories

- **FFmpeg**: https://github.com/binmgr/ffmpeg (this repo)
- **Toolchain**: https://github.com/binmgr/toolchain (build environment)

## Architecture

See `ARCHITECTURE.md` for complete technical details.

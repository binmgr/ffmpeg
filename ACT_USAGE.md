# Using Act for Local Workflow Testing

[Act](https://github.com/nektos/act) allows you to test GitHub Actions workflows locally using Docker, saving GitHub Actions minutes.

## Quick Start

### List available workflows and jobs
```bash
act -l
```

### Test a specific job (dry-run to see what would happen)
```bash
# Test the get-version job (fast, good for testing)
act -j get-version -n

# Actually run it
act -j get-version
```

### Test a specific build matrix entry
```bash
# Test Linux amd64 build
act -j build --matrix os:linux --matrix arch:amd64
```

### Run the entire workflow (WARNING: takes a long time)
```bash
# This will build all platforms - takes 30+ minutes
act push
```

## Important Notes

### What Act is Good For
- **Quick validation**: Test workflow syntax and structure
- **Fast jobs**: Test version detection, metadata generation, etc.
- **Debugging**: See detailed logs without consuming GitHub Actions minutes

### What Act is NOT Good For
- **Full builds**: FFmpeg compilation still takes 5-10 minutes per platform locally
- **Matrix testing**: Testing all 4 platforms still takes significant time
- **Resource limits**: Your local machine may have memory/CPU constraints

## Recommendations

1. **Use act for quick validation**:
   ```bash
   # Test that the workflow parses correctly
   act -l

   # Test the version detection (fast)
   act -j get-version
   ```

2. **Test one build locally** before pushing:
   ```bash
   # Test Linux amd64 (fastest, native build)
   act -j build --matrix os:linux --matrix arch:amd64
   ```

3. **Use GitHub Actions for full matrix builds**:
   - They have better parallelization
   - They don't consume your local resources
   - They're already optimized for CI/CD

## Troubleshooting

### Docker permission issues
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

### Out of disk space
```bash
# Clean up act Docker images
docker system prune -a
```

### Workflow not found
```bash
# Make sure you're in the repo root
cd /home/jason/Projects/github/binmgr/ffmpeg
act -l
```

## Cost Comparison

- **GitHub Actions**: 2,000 free minutes/month for free tier
- **Act (local)**: Free but uses local CPU/disk/time
- **Current workflow**: ~10-15 minutes total (parallel builds)

For this repo, you can run ~130-200 full workflow runs per month on the free tier, which is typically more than enough for most projects.

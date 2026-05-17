# =============================================================================
# FFmpeg Runtime Image
# =============================================================================
FROM scratch

ARG TARGETARCH

COPY ffmpeg-linux-${TARGETARCH} /usr/local/bin/ffmpeg
COPY ffprobe-linux-${TARGETARCH} /usr/local/bin/ffprobe

ENTRYPOINT ["/usr/local/bin/ffmpeg"]
CMD ["-version"]

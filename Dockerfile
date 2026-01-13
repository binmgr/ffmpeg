# Custom FFmpeg build environment based on Alpine Linux
# Contains all cross-compilation toolchains for multi-platform static builds
FROM alpine:latest

LABEL org.opencontainers.image.source="https://github.com/binmgr/ffmpeg"
LABEL org.opencontainers.image.description="Alpine-based build environment for static FFmpeg binaries"
LABEL org.opencontainers.image.licenses="MIT"

# Install base build tools and dependencies
RUN apk add --no-cache \
    build-base \
    cmake \
    pkgconf \
    nasm \
    yasm \
    git \
    curl \
    wget \
    bash \
    autoconf \
    automake \
    libtool \
    texinfo \
    zlib-dev \
    zlib-static \
    openssl-dev \
    openssl-libs-static \
    linux-headers \
    xz \
    tar \
    gzip \
    github-cli \
    coreutils \
    grep

# Install Windows cross-compilers
RUN apk add --no-cache \
    mingw-w64-gcc \
    clang \
    lld

# Download and install musl cross-compiler for Linux ARM64
WORKDIR /opt
RUN wget https://musl.cc/aarch64-linux-musl-cross.tgz && \
    tar xzf aarch64-linux-musl-cross.tgz && \
    rm aarch64-linux-musl-cross.tgz

# Download and install LLVM MinGW for Windows ARM64
RUN wget https://github.com/mstorsjo/llvm-mingw/releases/download/20241217/llvm-mingw-20241217-ucrt-ubuntu-20.04-x86_64.tar.xz && \
    tar xJf llvm-mingw-20241217-ucrt-ubuntu-20.04-x86_64.tar.xz && \
    rm llvm-mingw-20241217-ucrt-ubuntu-20.04-x86_64.tar.xz

# Add cross-compilers to PATH
ENV PATH="/opt/aarch64-linux-musl-cross/bin:/opt/llvm-mingw-20241217-ucrt-ubuntu-20.04-x86_64/bin:${PATH}"

# Set working directory
WORKDIR /workspace

# Verify toolchains are available
RUN echo "=== Verifying toolchains ===" && \
    gcc --version && \
    aarch64-linux-musl-gcc --version && \
    x86_64-w64-mingw32-gcc --version && \
    aarch64-w64-mingw32-gcc --version && \
    echo "=== All toolchains installed successfully ==="

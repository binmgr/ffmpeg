// Jenkins declarative pipeline for FFmpeg static binary builder.
// Mirrors the gates enforced by GitHub Actions, Gitea/Forgejo, and GitLab CI.
pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 4, unit: 'HOURS')
    }

    environment {
        REGISTRY = 'ghcr.io'
        IMAGE_NAME = 'binmgr/ffmpeg'
    }

    stages {
        stage('Get FFmpeg version') {
            steps {
                script {
                    if (env.FFMPEG_VERSION_OVERRIDE?.trim()) {
                        env.FFMPEG_VERSION = env.FFMPEG_VERSION_OVERRIDE
                    } else {
                        env.FFMPEG_VERSION = sh(
                            returnStdout: true,
                            script: """curl -q -LSsf https://ffmpeg.org/releases/ | grep -oP 'ffmpeg-\\K[0-9]+\\.[0-9]+(\\.[0-9]+)?' | sort -V | tail -1"""
                        ).trim()
                    }
                    echo "Building FFmpeg ${env.FFMPEG_VERSION}"
                }
            }
        }

        stage('Security') {
            parallel {
                stage('Secret scan') {
                    agent {
                        docker {
                            image 'trufflesecurity/trufflehog:latest'
                            args '--entrypoint=""'
                        }
                    }
                    steps {
                        sh 'trufflehog git file://. --since-commit HEAD~1 --fail --only-verified'
                    }
                }
            }
        }

        stage('Build binaries') {
            matrix {
                axes {
                    axis {
                        name 'TARGET'
                        values 'linux-amd64', 'linux-arm64', 'windows-amd64', 'darwin-amd64', 'darwin-arm64', 'freebsd-amd64', 'freebsd-arm64'
                    }
                }
                stages {
                    stage('Build') {
                        agent {
                            docker {
                                image "${env.REGISTRY}/${env.IMAGE_NAME}:build"
                                reuseNode true
                            }
                        }
                        steps {
                            sh "build-ffmpeg ${TARGET} ${FFMPEG_VERSION} && mkdir -p out/${TARGET} && cp -r /output/. out/${TARGET}/"
                            archiveArtifacts artifacts: 'out/**', allowEmptyArchive: false
                        }
                    }
                }
            }
        }

        stage('Build windows-arm64') {
            agent {
                docker {
                    image 'ubuntu:22.04'
                    args '-u root'
                }
            }
            environment {
                LLVM_MINGW_VERSION = '20260505'
            }
            steps {
                sh '''
                    apt-get update -qq
                    apt-get install -y --no-install-recommends wget xz-utils nasm yasm pkg-config make ca-certificates
                    wget -q "https://github.com/mstorsjo/llvm-mingw/releases/download/${LLVM_MINGW_VERSION}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-x86_64.tar.xz"
                    tar xJf "llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-x86_64.tar.xz" -C /opt
                    export PATH="/opt/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-x86_64/bin:${PATH}"
                    wget -q "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz"
                    tar xJf "ffmpeg-${FFMPEG_VERSION}.tar.xz"
                    cd "ffmpeg-${FFMPEG_VERSION}"
                    ./configure --prefix=/tmp/ffmpeg-install \\
                        --enable-gpl --enable-version3 --enable-nonfree \\
                        --enable-static --disable-shared --disable-debug --disable-doc --disable-ffplay \\
                        --enable-cross-compile --cross-prefix=aarch64-w64-mingw32- --arch=aarch64 --target-os=mingw32 \\
                        --cc=aarch64-w64-mingw32-clang --cxx=aarch64-w64-mingw32-clang++ \\
                        --pkg-config=pkg-config --pkg-config-flags=--static \\
                        --extra-cflags=-O2 --extra-ldflags=-static
                    make -j"$(nproc)"
                    mkdir -p "${WORKSPACE}/out/windows-arm64"
                    cp ffmpeg.exe "${WORKSPACE}/out/windows-arm64/ffmpeg-windows-arm64.exe"
                    cp ffprobe.exe "${WORKSPACE}/out/windows-arm64/ffprobe-windows-arm64.exe"
                '''
                archiveArtifacts artifacts: 'out/**', allowEmptyArchive: false
            }
        }

        stage('Release') {
            when { buildingTag() }
            steps {
                echo 'Release publishing is performed by the hosted provider (GitHub/GitLab/Gitea/Forgejo) — Jenkins build is verification-only.'
            }
        }
    }
}

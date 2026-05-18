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
                        sh 'trufflehog git file://. --since-commit HEAD~1 --fail'
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
                            sh "build-ffmpeg ${TARGET} ${FFMPEG_VERSION}"
                            archiveArtifacts artifacts: '/output/**', allowEmptyArchive: false
                        }
                    }
                }
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

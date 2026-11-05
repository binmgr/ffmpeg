.PHONY: help build build-env validate test clean

REGISTRY  ?= ghcr.io
IMAGE_ORG ?= binmgr
IMAGE     ?= $(REGISTRY)/$(IMAGE_ORG)/ffmpeg
VERSION   ?=

# Default target
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*## "}; {printf "  %-20s %s\n", $$1, $$2}'

build: ## Build FFmpeg for one target: make build TARGET=linux-amd64 [VERSION=8.1.1]
ifndef TARGET
	$(error TARGET is required — e.g. make build TARGET=linux-amd64)
endif
	@mkdir -p output
	docker run --rm \
	  --name ffmpeg-build-$$(tr -dc 'a-z0-9' </dev/urandom | head -c8) \
	  -v "$(PWD)/output:/output" \
	  $(IMAGE):build \
	  build-ffmpeg $(TARGET) $(VERSION)

build-env: ## Build the build environment image (Dockerfile.build)
	docker build \
	  --file docker/Dockerfile.build \
	  --tag $(IMAGE):build \
	  .

validate: ## Validate all workflow files with act --list
	@for f in .github/workflows/*.yml .gitea/workflows/*.yml .forgejo/workflows/*.yml; do \
	  [ -f "$$f" ] || continue; \
	  echo "==> $$f"; \
	  act --list -W "$$f" || exit 1; \
	done
	@echo "All workflows valid."

test: validate ## Alias for validate (workflow lint; binary builds run in CI)

clean: ## Remove local build artifacts
	@rm -rf output/ artifacts/ staging/ release/

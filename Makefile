.PHONY: help build build-env validate clean

REGISTRY  ?= ghcr.io
IMAGE_ORG ?= binmgr
IMAGE     ?= $(REGISTRY)/$(IMAGE_ORG)/ffmpeg

# Default target
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*## "}; {printf "  %-20s %s\n", $$1, $$2}'

build: ## Build FFmpeg for one target: make build TARGET=linux-amd64
ifndef TARGET
	$(error TARGET is required — e.g. make build TARGET=linux-amd64)
endif
	docker run --rm -it \
	  --name ffmpeg-build-$$(tr -dc 'a-z0-9' </dev/urandom | head -c8) \
	  $(IMAGE):build \
	  build-ffmpeg $(TARGET)

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

clean: ## Remove local build artifacts
	@rm -rf output/ artifacts/ staging/ release/

# Default tag for the docker images
TAG ?= latest

# Registry and repository configuration
export IMAGE_REGISTRY ?= ghcr.io
export IMAGE_REPO     ?= jonwiggins/optio
export IMAGE_NAME     ?= $(IMAGE_REGISTRY)/$(IMAGE_REPO)

# List of all images to build and push
IMAGES = \
	$(IMAGE_NAME)-api:$(TAG) \
	$(IMAGE_NAME)-web:$(TAG) \
	$(IMAGE_NAME)-optio:$(TAG) \
	$(IMAGE_NAME)-agent-base:$(TAG) \
	$(IMAGE_NAME)-agent-node:$(TAG) \
	$(IMAGE_NAME)-agent-python:$(TAG) \
	$(IMAGE_NAME)-agent-go:$(TAG) \
	$(IMAGE_NAME)-agent-rust:$(TAG) \
	$(IMAGE_NAME)-agent-ruby:$(TAG) \
	$(IMAGE_NAME)-agent-dart:$(TAG) \
	$(IMAGE_NAME)-agent-dind:$(TAG) \
	$(IMAGE_NAME)-agent-full:$(TAG) \
	$(IMAGE_NAME)-agent:$(TAG)

.PHONY: all help docker.build docker.push \
	build-api build-web build-optio \
	build-agent-base build-agent-node build-agent-python build-agent-go \
	build-agent-rust build-agent-ruby build-agent-dart build-agent-dind \
	build-agent-full build-agent-default

all: help

help:
	@echo "Optio Docker Build System"
	@echo "========================="
	@echo "Available targets:"
	@echo "  docker.build         - Build and tag all Docker images locally"
	@echo "  docker.push          - Push all built Docker images to the registry"
	@echo ""
	@echo "Environment variables (can be overridden):"
	@echo "  IMAGE_REGISTRY       - Docker registry (default: ghcr.io)"
	@echo "  IMAGE_REPO           - Repository path (default: jonwiggins/optio)"
	@echo "  IMAGE_NAME           - Fully-qualified image name base (default: ghcr.io/jonwiggins/optio)"
	@echo "  TAG                  - Tag to apply to all images (default: latest)"
	@echo ""
	@echo "Example usage:"
	@echo "  TAG=v1.0.0 make docker.build"
	@echo "  IMAGE_REPO=myorg/optio TAG=v1.0.0 make docker.push"

# Main build target
docker.build: build-api build-web build-optio \
	build-agent-base build-agent-node build-agent-python build-agent-go \
	build-agent-rust build-agent-ruby build-agent-dart build-agent-dind \
	build-agent-full build-agent-default
	@echo "========================================="
	@echo "Successfully built and tagged all images!"
	@echo "========================================="

# Core service images
build-api:
	docker build -t $(IMAGE_NAME)-api:$(TAG) -f Dockerfile.api .

build-web:
	docker build -t $(IMAGE_NAME)-web:$(TAG) -f Dockerfile.web .

build-optio:
	docker build -t $(IMAGE_NAME)-optio:$(TAG) -f Dockerfile.optio .

# Agent images
build-agent-base:
	docker build -t $(IMAGE_NAME)-agent-base:$(TAG) -f images/base.Dockerfile .

build-agent-node: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-node:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/node.Dockerfile .

build-agent-python: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-python:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/python.Dockerfile .

build-agent-go: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-go:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/go.Dockerfile .

build-agent-rust: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-rust:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/rust.Dockerfile .

build-agent-ruby: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-ruby:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/ruby.Dockerfile .

build-agent-dart: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-dart:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/dart.Dockerfile .

build-agent-dind: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-dind:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/dind.Dockerfile .

build-agent-full: build-agent-base
	docker build -t $(IMAGE_NAME)-agent-full:$(TAG) --build-arg BASE_IMAGE=$(IMAGE_NAME)-agent-base:$(TAG) -f images/full.Dockerfile .

# Tag agent-base as the default agent
build-agent-default: build-agent-base
	docker tag $(IMAGE_NAME)-agent-base:$(TAG) $(IMAGE_NAME)-agent:$(TAG)

# Main push target
docker.push:
	@for img in $(IMAGES); do \
		echo "Pushing $$img..."; \
		docker push $$img; \
	done

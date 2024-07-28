SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

PROJECT_VERSION := $(shell yq -r '.version' project.yaml)
NODE_VERSION := $(shell yq -r '.nodeVersion' project.yaml)
IMAGE_NAME := $(shell yq -r '.name' project.yaml)
IMAGE_VERSION := $(NODE_VERSION)-$(PROJECT_VERSION)

ifneq (,$(wildcard ./.env))
	include ./.env
endif

.PHONY: help

help:
	@echo "JABA" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Misc
check-project-env-vars: # check env vars mentioned in project.env.dist to be filled in project.env
	@bash ./.devops/local/scripts/check-project-env-vars.sh

# Docker
cleanup:
	@bash .devops/docker/scripts/docker-soft-cleanup.bash

logs:  ## docker logs
	@docker compose logs --follow

log:  ## docker log for svc=<docker service name>
	@docker compose logs --follow ${svc}

# make up type=static
up: check-project-env-vars ## docker compose up for jaba <type>
	@IMAGE_TYPE=$(type) docker compose up --build --remove-orphans -d
	@IMAGE_TYPE=$(type) docker compose logs --follow

# make down type=static
down: check-project-env-vars ## docker compose down for jaba <type>
	@IMAGE_TYPE=$(type) docker compose down jaba

# make restart type=static
restart: check-project-env-vars  ## restart image <type>
	@docker compose down
	@IMAGE_TYPE=$(type) docker compose up --build --remove-orphans -d
	@IMAGE_TYPE=$(type) docker compose logs --follow

exec-bash: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

# used for multi-platform builds
create-docker-container-builder:
	@docker buildx create --use --name docker-container --driver docker-container
	@docker buildx inspect docker-container --bootstrap

use-docker-container-builder:
	@docker buildx create --use --name docker-container --driver docker-container
	@docker buildx inspect docker-container --bootstrap
	@docker buildx use docker-container

docker-build-n-push-all: ## build all images
	@make docker-build-n-push type=static
	@make docker-build-n-push type=build
	@make docker-build-n-push type=node

# make build type=build|node|static
# for multiplatform builds, it should be pushed immediately after build
docker-build-n-push: ## build <type> image
	docker buildx build --builder docker-container --platform linux/amd64,linux/arm64 --push -f ./src/Dockerfile.$(type) --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg IMAGE_NAME=$(IMAGE_NAME)-$(type) -t $(IMAGE_NAME)-$(type):$(IMAGE_VERSION) -t $(IMAGE_NAME)-$(type):latest .

docker-build-dev: ## build <type> image
	docker buildx build --platform linux/arm64 --load -f ./src/Dockerfile.$(type) --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg IMAGE_NAME=$(IMAGE_NAME)-$(type) -t $(IMAGE_NAME)-$(type):$(IMAGE_VERSION) -t $(IMAGE_NAME)-$(type):latest .

# make tag-latest type=build|node|static
docker-tag-latest: ## tag <type> image as latest
	@docker tag $(IMAGE_NAME)-$(type):$(IMAGE_VERSION) $(IMAGE_NAME)-$(type):latest

docker-tag-latest-all: ## tag all images as latest
	@make tag-latest type=static
	@make tag-latest type=build
	@make tag-latest type=node

docker-push: ## push latest image to docker hub of <type>
	@docker push docker.io/$(IMAGE_NAME)-$(type):$(IMAGE_VERSION)
	@docker push docker.io/$(IMAGE_NAME)-$(type):latest

docker-push-all: ## push all images
	@make push type=static
	@make push type=build
	@make push type=node

test-nginx: ## test nginx
	nginx -t -c $(PWD)/src/nginx-config/nginx.conf	
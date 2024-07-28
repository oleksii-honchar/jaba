SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

include project.env
export $(shell sed 's/=.*//' project.env)

include ./.configs/envs/deployment.env
export $(shell sed 's/=.*//' ./.configs/envs/deployment.env)

export LATEST_VERSION=$(shell cat ./latest-version.txt)

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

build-n-push-all: check-project-env-vars ## build all images
	@make build-n-push type=static
	@make build-n-push type=build
	@make build-n-push type=node

# make build type=build|node|static
# for multiplatform builds, it should be pushed immediately after build
build-n-push: ## build <type> image
	docker buildx build --builder docker-container --platform linux/amd64,linux/arm64 --push -f ./src/Dockerfile.$(type) --build-arg LATEST_VERSION=$(LATEST_VERSION) --build-arg IMAGE_NAME=$(BASE_IMAGE_NAME)-$(type) -t $(BASE_IMAGE_NAME)-$(type):$(LATEST_VERSION) -t $(BASE_IMAGE_NAME)-$(type):latest .

build-dev: ## build <type> image
	docker buildx build --platform linux/arm64 --load -f ./src/Dockerfile.$(type) --build-arg LATEST_VERSION=$(LATEST_VERSION) --build-arg IMAGE_NAME=$(BASE_IMAGE_NAME)-$(type) -t $(BASE_IMAGE_NAME)-$(type):$(LATEST_VERSION) -t $(BASE_IMAGE_NAME)-$(type):latest .

# make tag-latest type=build|node|static
tag-latest: ## tag <type> image as latest
	@docker tag $(BASE_IMAGE_NAME)-$(type):$(LATEST_VERSION) $(BASE_IMAGE_NAME)-$(type):latest

tag-latest-all: ## tag all images as latest
	@make tag-latest type=static
	@make tag-latest type=build
	@make tag-latest type=node

push: ## push latest image to docker hub of <type>
	@docker push docker.io/$(BASE_IMAGE_NAME)-$(type):$(LATEST_VERSION)
	@docker push docker.io/$(BASE_IMAGE_NAME)-$(type):latest

push-all: ## push all images
	@make push type=static
	@make push type=build
	@make push type=node

test-nginx: ## test nginx
	nginx -t -c $(PWD)/src/nginx-config/nginx.conf	
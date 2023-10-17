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

include ./.devops/envs/deployment.env
export $(shell sed 's/=.*//' ./.devops/envs/deployment.env)

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

up: check-project-env-vars ## docker compose up
	@docker compose up --build --remove-orphans -d 

down: check-project-env-vars ## docker compose down
	@docker compose down

.ONESHELL:
restart: check-project-env-vars  ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

exec-bash: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh


build-all: check-project-env-vars ## build all images
	@make build type=static
	@make build type=build
	@make build type=node

# make build type=build|node|static
build: ## build <type> image
	@docker build --load -f ./src/Dockerfile.$(type) -t $(BASE_IMAGE_NAME)-$(type):$(LATEST_VERSION) .

# make tag-latest type=build|node|static
tag-latest: ## tag <type> image as latest
	@docker tag $(IMAGE_NAME)-$(type):$(LATEST_VERSION) $(IMAGE_NAME)-$(type):latest

push: ## push latest image to docker hub
	@docker push docker.io/$(IMAGE_NAME):$(LATEST_VERSION)
	@docker push docker.io/$(IMAGE_NAME):latest
#!/bin/bash
source ./configs/envs/deployment.env

docker login -u="$DOCKER_REGISTRY_USER" -p="$DOCKER_REGISTRY_PWD" $DOCKER_REGISTRY_HOST

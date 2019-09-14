#!/usr/bin/env bash
source ./configs/envs/deployment.env
source ./devops/docker/scripts/login-to-registry.sh

docker-compose -f ./devops/docker/docker-compose/production.loc.yml down
docker-compose -f ./devops/docker/docker-compose/production.loc.yml up

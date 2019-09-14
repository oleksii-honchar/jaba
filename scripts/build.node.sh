#!/usr/bin/env bash

set -euo pipefail

source ./configs/envs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh

if [[ -n "${IS_CI_RUNNER-}" ]] ; then
    # build by gitlab-runner
    docker build -f "./devops/docker/Dockerfile.node" \
        --build-arg IS_CI_RUNNER \
        --force-rm=true \
        -t="$IMAGE_NAME_NODE:$VERSION" .

else
    # local build
    docker build -f "./devops/docker/Dockerfile.node" \
        --force-rm=true \
        -t="$IMAGE_NAME_NODE:$VERSION" \
        -t="$IMAGE_NAME_NODE:latest" .
fi


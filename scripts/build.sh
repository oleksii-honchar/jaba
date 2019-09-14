#!/usr/bin/env bash

set -euo pipefail

source ./configs/envs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh

if [[ -n "${IS_CI_RUNNER-}" ]] ; then
    # build by gitlab-runner
    docker build -f "./devops/docker/Dockerfile.build" \
        --build-arg IS_CI_RUNNER \
        --force-rm=true \
        -t="$IMAGE_NAME_BUILD:$VERSION" .

    docker build -f "./devops/docker/Dockerfile.node" \
        --build-arg IS_CI_RUNNER \
        --force-rm=true \
        -t="$IMAGE_NAME_NODE:$VERSION" .

    docker build -f "./devops/docker/Dockerfile.static" \
        --build-arg IS_CI_RUNNER \
        --force-rm=true \
        -t="$IMAGE_NAME_STATIC:$VERSION" .

else
    # local build
    docker build -f "./devops/docker/Dockerfile.build" \
        --force-rm=true \
        -t="$IMAGE_NAME_BUILD:$VERSION" \
        -t="$IMAGE_NAME_BUILD:latest" .

    docker build -f "./devops/docker/Dockerfile.node" \
        --force-rm=true \
        -t="$IMAGE_NAME_NODE:$VERSION" \
        -t="$IMAGE_NAME_NODE:latest" .

    docker build -f "./devops/docker/Dockerfile.static" \
        --force-rm=true \
        -t="$IMAGE_NAME_STATIC:$VERSION" \
        -t="$IMAGE_NAME_STATIC:latest" .
fi


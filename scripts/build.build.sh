#!/usr/bin/env bash

set -euo pipefail

source ./configs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh

if [[ -n "${IS_CI_RUNNER-}" ]] ; then
    # build by gitlab-runner
    docker build -f "./devops/docker/Dockerfile.build" \
        --build-arg IS_CI_RUNNER \
        --force-rm=true \
        -t="$IMAGE_NAME_BUILD:$VERSION" .

else
    # local build
    docker build -f "./devops/docker/Dockerfile.build" \
        --force-rm=true \
        -t="$IMAGE_NAME_BUILD:$VERSION" \
        -t="$IMAGE_NAME_BUILD:latest" .
fi


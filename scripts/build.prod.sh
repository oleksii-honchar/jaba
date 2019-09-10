#!/usr/bin/env bash

set -euo pipefail

source ./configs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh

if [[ -n "${IS_CI_RUNNER-}" ]] ; then
    # build by gitlab-runner
    docker build -f "./devops/docker/Dockerfile.prod" \
        --build-arg IS_CI_RUNNER \
        --force-rm=true \
        -t="$IMAGE_NAME_PROD:$VERSION" .

else
    # local build
    docker build -f "./devops/docker/Dockerfile.prod" \
        --force-rm=true \
        -t="$IMAGE_NAME_PROD:$VERSION" \
        -t="$IMAGE_NAME_PROD:latest" .
fi


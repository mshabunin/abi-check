#!/bin/bash

set -e
set -x

IMG=abi-check
DFILE=Dockerfile

docker build \
    -t $IMG \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    -f $DFILE \
    .

mkdir -p results

docker run \
    --interactive --tty --rm \
    --volume $(readlink -f scripts):/scripts \
    --volume $(readlink -f results):/results \
    --env http_proxy="$http_proxy" \
    --env https_proxy="$https_proxy" \
    $IMG \
    /scripts/build-abi.sh && /scripts/cmp-abi.sh

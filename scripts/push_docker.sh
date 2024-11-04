#!/bin/sh

set -eu

export VERSION=${VERSION:-0.0.0}
export GOFLAGS="'-ldflags=-w -s \"-X=github.com/nctu6/unieai/version.Version=$VERSION\" \"-X=github.com/nctu6/unieai/server.mode=release\"'"

docker build \
    --push \
    --platform=linux/arm64,linux/amd64 \
    --build-arg=VERSION \
    --build-arg=GOFLAGS \
    -f Dockerfile \
    -t unieai/unieai -t unieai/unieai:$VERSION \
    .

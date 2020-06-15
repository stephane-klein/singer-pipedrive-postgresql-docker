#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

export DOCKER_BUILDKIT=1

docker build . -t stephaneklein/singer-pipedrive-postgresql:latest

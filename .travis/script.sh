#!/bin/bash

set -ue

DOCKER_REPO="${1}" ; shift
DOCKER_TAG="${1}" ; shift

docker=(
	docker run
	-v ${PWD}:/repo:ro
	"${DOCKER_REPO}:${DOCKER_TAG}"
	repoman-pretty-scan --travis-ci -- --xmlparse --ignore-arches --without-mask
)

"${docker[@]}"

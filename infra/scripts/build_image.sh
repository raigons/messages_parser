#!/usr/bin/env bash

build_image="messages_parser"

docker build -f ./infra/docker/Dockerfile -t $build_image .

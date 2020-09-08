#!/usr/bin/env bash

source ./infra/scripts/build_image.sh

image_name="messages_parser"
container_name="messages_parser"

docker run --name=$container_name -it -d $image_name sleep infinity

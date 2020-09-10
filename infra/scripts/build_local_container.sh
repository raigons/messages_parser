#!/usr/bin/env bash

source ./infra/scripts/build_image.sh

image_name="messages_parser"
container_name="messages_parser"

if [ "$(docker ps -aq -f status=exited -f name=$container_name)" ]; then
    # cleanup
    echo "\n::removing existing container before rebuilding...::\n"
    docker rm $container_name
fi

if [ "$(docker ps -aq -f status=running)" ]; then
    echo "\n::killing and removing existing container before rebuilding...::\n"
    docker kill $container_name && docker rm $container_name
fi

docker run --name=$container_name -it -d $image_name sleep infinity

#!/usr/bin/env bash

source ./infra/scripts/build_image.sh

docker run -it messages_parser sh

#!/usr/bin/env bash

source ./infra/scripts/build_image.sh

docker run -it messages_parser -name iex_messsage_parser iex -S mix

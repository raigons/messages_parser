#!/usr/bin/env zsh

container_name="messages_parser"

report () {
  while getopts ":f:" opt; do
    case $opt in
      f) filename="$OPTARG"
      ;;
      *) continue;
    esac
  done

  if [ -z "$filename" ]
    then
      echo "No argument supplied"
      return 0
  fi

  uploadFileToDocker $filename
  docker exec -it $container_name mix report.messages_by_user $(basename $filename)
}

uploadFileToDocker () {
  echo "calculating..."

  local filename=$1
  local file_basename="$(basename $filename)"
  local workdir="$(docker inspect --format='{{.Config.WorkingDir}}' $container_name)"
  local containerFilename="$workdir/$file_basename"

  docker cp $filename $container_name:$containerFilename
}


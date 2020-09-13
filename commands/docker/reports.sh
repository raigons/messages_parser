#!/usr/bin/env zsh

container_name="messages_parser"

report () {
  while :
  do
    case "$1" in
      -f | --file)
        filename=$2
        shift 2
        ;;
      -r | --report)
        if [ "$2" != "messages_by_user" ] && [ "$2" != "messages_per_day" ] && [ "$2" != "messages_per_hour" ]; then
          echo ":: Report ($2) not available ::"
          return 0
        else
          report_name="$2"
        fi
        shift 2
        ;;
      -h | --help)
        echo "\n you must inform one of the following available reports:
          -r messages_by_user
          -r messages_per_day
          -r messages_per_hour"
        break
        ;;
      -*)
        echo "Error: Unknown option: $1" >&2
        break
	      ;;
      *)  # No more options
	      break
	      ;;
    esac
  done

  if [ -z "$filename" ] || [ -z "$report_name" ]
  then
      echo "\nMissing arguments: both -f and -r are necessary"
      return 0
  else
      uploadFileToDocker $filename
      docker exec -it $container_name mix report.$report_name $(basename $filename)
  fi
}

uploadFileToDocker () {
  echo "calculating..."

  local filename=$1
  local file_basename="$(basename $filename)"
  local workdir="$(docker inspect --format='{{.Config.WorkingDir}}' $container_name)"
  local containerFilename="$workdir/$file_basename"

  docker cp $filename $container_name:$containerFilename
}


#!/usr/bin/env zsh

dkr-cleanup() {
  local containers=($(docker ps -q -f 'status=exited'))
  if [[ -n "$containers" ]]; then
    echo "dkr-cleanup:: removing exited containers:"
    docker rm $containers
  else
    echo "dkr-cleanup:: zero exited containers"
  fi

  local images=($(docker images -qf 'dangling=true'))
  if [[ -n "$images" ]]; then
    echo "dkr-cleanup:: removing dangling images:"
    docker rmi $images
  else
    echo "dkr-cleanup:: zero dangling images"
  fi

  local volumes=($(docker volume ls -qf 'dangling=true'))
  if [[ -n "$volumes" ]]; then
    echo "dkr-cleanup:: removing dangling volumes:"
    docker volume rm $volumes
  else
    echo "dkr-cleanup:: zero dangling volumes"
  fi
  return 0
}


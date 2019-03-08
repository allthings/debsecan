#!/bin/sh

#
# Uses debsecan to list CVEs for installed packages in a Debian Docker image.
# Returns with exit status 1 if any CVEs are found, else with exit status 0.
#
# Usage: ./debsecan.sh docker_image [debsecan_args...]
#
# Examples:
# ./debsecan.sh debian:jessie --format detail
# ./debsecan.sh debian:jessie --suite jessie --only-fixed
#

# Exit immediately if a command exits with a non-zero status:
set -e

# Removes the temporary docker container:
cleanup() {
  if [ -n "$DEBSECAN_TARGET" ]; then
    docker rm -vf "$DEBSECAN_TARGET" > /dev/null
  fi
}

if [ $# -eq 0 ] || [ "$1" = -h ] || [ "$1" = --help ]; then
  echo 'Usage: ./debsecan.sh docker_image [debsecan_args...]' >&2
	exit 1
fi

# Pull the allthings/debsecan image if it's not available locally:
if [ "$(docker images -q allthings/debsecan:latest 2> /dev/null)" = '' ]; then
  docker pull allthings/debsecan:latest > /dev/null
fi

if [ "$2" = -h ] || [ "$2" = --help ]; then
  docker run --rm allthings/debsecan --help
	exit $?
fi

# Pull the target image if it's not available locally:
if [ "$(docker images -q "$1" 2> /dev/null)" = '' ]; then
  docker pull "$1" > /dev/null
fi

# Create a temporary docker container to expose the dpkg directory:
DEBSECAN_TARGET=$(docker run -d --entrypoint true -v /var/lib/dpkg "$1")

# Run the cleanup function on SIGINT or SIGTERM:
trap 'cleanup' INT TERM

# Remove the docker_image from the arguments list:
shift

# Run debsecan and return exit status 1 if any CVEs are found:
if docker run --rm --volumes-from="$DEBSECAN_TARGET" allthings/debsecan "$@" |
  grep . -; then
  cleanup
  exit 1
fi

cleanup

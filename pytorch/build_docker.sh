#!/bin/bash
set -eu

if [ $# -eq 0 ]; then
  MAX_JOBS=2
else
  MAX_JOBS=$1
fi
echo MAX_JOBS=${MAX_JOBS}
docker build -t pytorch-build . --build-arg MAX_JOBS=${MAX_JOBS}
id=$(docker run -it --rm -d pytorch-build bash)
pytorch=$(docker exec -it ${id} find /pytorch/dist -type f | sed -e "s/[\r\n]\+//g")
vision=$(docker exec -it ${id} find /pytorch/torchvision/dist -type f | sed -e "s/[\r\n]\+//g")
docker cp ${id}:${pytorch} .
docker cp ${id}:${vision} .
docker stop ${id}

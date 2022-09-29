#!/bin/bash
set -eu

if [ $# -eq 0 ]; then
  MAX_JOBS=2
else
  MAX_JOBS=$1
fi
echo MAX_JOBS=${MAX_JOBS}
docker build -t opencv-build . --build-arg MAX_JOBS=${MAX_JOBS}
id=$(docker run -it --rm -d opencv-build bash)
debs=$(docker exec -it  ${id} find /tmp/build_opencv/opencv/build/ -maxdepth 1 -name "*.deb" | sed -e "s/[\r\n]\+//g")
for deb in $debs; do
  docker cp ${id}:$deb .
done
docker stop ${id}

#!/bin/bash
set -e

if [ ! -f /etc/nv_tegra_release ]; then
    echo "Error: $0 should be run on the Jetson platform."
    exit 1
fi
if [[ $(cat /etc/nv_tegra_release) =~ ^.*REVISION:[^\S]([0-9]*\.[0-9]).*$ ]]; then
    case ${BASH_REMATCH[1]} in
        [56].*) sudo docker build -t pytorch-build . $1 ;;
        * ) echo "Error: unsupported jetpack ${BASH_REMATCH[1]}"
            exit 1 ;;
    esac
fi

id=$(docker run -it --rm -d pytorch-build bash)
wheel=$(docker exec -it ${id} ls /pytorch/dist | sed -e "s/[\r\n]\+//g")
docker cp ${id}:/pytorch/dist/${wheel} .
docker stop ${id}

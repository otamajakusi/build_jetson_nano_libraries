#!/bin/bash
set -e

if [ ! -f /etc/nv_tegra_release ]; then
    echo "Error: $0 should be run on the Jetson platform."
    exit 1
fi
if [[ $(cat /etc/nv_tegra_release) =~ ^.*REVISION:[^\S]([0-9]*\.[0-9]).*$ ]]; then
    case ${BASH_REMATCH[1]} in
        5.*) sudo docker build -t pytorch-build . ;;
        * ) echo "Error: unsupported jetpack ${BASH_REMATCH[1]}"
            exit 1 ;;
    esac
fi

id=$(docker create pytorch-build)
wheel=$(docker exec -it c757bc9c4c15 ls /pytorch/dist)
docker cp ${id}:/pytorch/dist/${wheel} .
docker rm ${id}

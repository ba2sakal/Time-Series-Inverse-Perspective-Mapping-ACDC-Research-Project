#!/bin/bash

set -e

docker exec \
    --interactive \
    --tty \
    ika-acdc-research-projects-$USER \
    bash --init-file /home/jovyan/acdc/docker/.attach-init.sh

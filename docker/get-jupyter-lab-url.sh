#!/bin/bash

set -e

CONTAINER_NAME=ika-acdc-research-projects-$USER
HOST=$(hostname -A | awk '{print $NF}')
PORT=$(docker port ika-acdc-research-projects-$USER 8888 | head -n 1 | cut -d ":" -f 2)
TOKEN=$(docker logs $CONTAINER_NAME | grep -oP 'token=\K[^&]+' | tail -n 1 | awk '{print $1}')
echo "http://$HOST.ika.rwth-aachen.de:$PORT/lab?token=$TOKEN"

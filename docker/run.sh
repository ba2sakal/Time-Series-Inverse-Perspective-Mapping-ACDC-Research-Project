#!/bin/bash

DIR="$(cd -P "$(dirname "$0")" && pwd)"
MOUNT_DIR="$(dirname "$DIR")"

# The user inside the docker environment is `jovyan` with uid 1000.
# This setting is predefined in registry.git.rwth-aachen.de/jupyter/profiles/rwth-courses:latest.
# To ensure compatibility with RWTH Jupyter Hub, we will temporarily give this uid write permissions to this directory.
setfacl -R -m u:1000:rwx $MOUNT_DIR 2> /dev/null

# set up GUI forwarding
XSOCK=/tmp/.X11-unix
XAUTH=$(mktemp /tmp/.docker.xauth.XXXXXXXXX)
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge - 2>/dev/null
chmod 777 $XAUTH
DISPLAY="host.docker.internal:"$(cut -d ':' -f2 <<<$DISPLAY)

docker run \
    --name="ika-acdc-research-projects-$USER" \
    --rm \
    --interactive \
    --tty \
    --publish 8888 \
    --publish 9090 \
    --env DISPLAY \
    --env XAUTHORITY=$XAUTH \
    --env QT_X11_NO_MITSHM=1 \
    --volume $XAUTH:$XAUTH \
    --volume $XSOCK:$XSOCK \
    --volume $MOUNT_DIR:/home/jovyan/acdc \
    --add-host host.docker.internal:host-gateway \
    $(if command -v nvidia-smi > /dev/null; then echo -n "--gpus all"; fi) \
    rwthika/acdc-research-projects:latest

# Remove write permission of uid 1000.
setfacl -R -x u:1000 $MOUNT_DIR 2> /dev/null

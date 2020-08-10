#!/bin/bash

# Example of docker usage for RLLIB + SUMO Utlis
#
# Author: Lara CODECA
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.

set -e
set -u

IMAGE_NAME="tf-gpu-sumo-$(date +%Y-%m-%d)"
IMAGE_FOLDER="docker-image-mac"
GPU=true
GPU_OPT="--gpus all"
BUILD=false
CACHE=false
RUN=false
SCREEN=false
EXEC=false
CONTAINER=""
DEVEL_DIR=""
LEARN_DIR=""
COMMAND=""
EXP=""
DETACH=false

function print_help {
    echo "Parameters:"
    echo "  IMAGE name \"$IMAGE_NAME\" [-n, --image-name]"
    echo "  IMAGE folder \"$IMAGE_FOLDER\" [-f, --image-folder]"
    echo "  GPU enabled ($GPU) [--no-gpu]"
    echo "  BUILD: $BUILD [-b, --build], with CACHE: $CACHE [-c, --cache]"
    echo "  RUN: $RUN [-r, --run], with SCREEN: $SCREEN [-s, --screen]"
    echo "  EXEC: $EXEC [-e, --exec], CONTAINER: \"$CONTAINER\" (use docker ps for the id)"
    echo "  COMMAND: \"$COMMAND\" [--cmd]"
    echo "  EXP: \"$EXP\" [--exp]"
    echo "  DETACH: ($DETACH) [--detach]"
    echo "  DEVELOPMENT dir \"$DEVEL_DIR\" [-d, --devel]"
    echo "  LEARNING dir \"$LEARN_DIR\" [-l, --learn]"
}

for arg in "$@"
do
    case $arg in ## -l=*|--lib=*) DIR="${i#*=}" is the way to retrieve the parameter
        -n=*|--image-name=*)
        IMAGE_NAME="${arg#*=}"
        ;;
        -f=*|--image-folder=*)
        IMAGE_FOLDER="${arg#*=}"
        ;;
        --no-gpu)
        GPU=false
        GPU_OPT=""
        ;;
        --detach)
        DETACH=true
        ;;
        -b|--build)
        BUILD=true
        ;;
        -c|--cache) # it does nothing without BUILD=true
        CACHE=true
        ;;
        -r|--run)
        RUN=true
        ;;
        -s|--screen) # it does nothing without RUN=true
        SCREEN=true
        ;;
        -e=*|--exec=*) # it works only with RUN=false
        EXEC=true
        CONTAINER="${arg#*=}"
        ;;
        --cmd=*)
        COMMAND="${arg#*=}"
        ;;
        --exp=*)
        EXP="${arg#*=}"
        ;;
        -d=*|--devel=*)
        DEVEL_DIR="${arg#*=}"
        ;;
        -l=*|--learn=*)
        LEARN_DIR="${arg#*=}"
        ;;
        *)
        # unknown option
        echo "Unknown option \"$arg\""
        print_help
        exit
        ;;
    esac
done

print_help

# Tensorflow original image
# docker run -u $(id -u):$(id -g) --gpus all -it --rm tensorflow/tensorflow:latest-gpu-py3 bash

## Building the docker image
if [[ "$BUILD" = true ]]; then
    if [[ "$CACHE" = true ]]; then
        echo "Building the docker container using the cache, if present."
        docker build \
            --build-arg USER_ID=$(id -u ${USER}) \
            --build-arg GROUP_ID=$(id -g ${USER}) \
            -t "$IMAGE_NAME" "$IMAGE_FOLDER"
    else
        echo "Building the docker container ignoring the cache, even if present."
        docker build \
            --build-arg USER_ID=$(id -u ${USER}) \
            --build-arg GROUP_ID=$(id -g ${USER}) \
            --no-cache -t "$IMAGE_NAME" "$IMAGE_FOLDER"
    fi
fi

if [[ "$RUN" = true ]]; then
    # My docker build
    MOUNT_DEVEL=""
    if [[ $DEVEL_DIR ]]; then
        MOUNT_DEVEL="--mount src=$DEVEL_DIR,target=/home/alice/devel,type=bind"
    fi
    MOUNT_LEARN=""
    if [[ $LEARN_DIR ]]; then
        MOUNT_LEARN="--mount src=$LEARN_DIR,target=/home/alice/learning,type=bind"
    fi
    CONT_NAME=""
    if [[ $EXP ]]; then
        CONT_NAME="--name $EXP"
    fi
    if [[ "$DETACH" = true ]]; then
        DETACH="-d"
    else
        DETACH=""
    fi
    CURR_UID=$(id -u)
    CURR_GID=$(id -g)
    RUN_OPT="-u $CURR_UID:$CURR_GID --net=host --env DISPLAY=$DISPLAY \
            --volume /tmp/.X11-unix:/tmp/.X11-unix \
            --privileged $MOUNT_DEVEL $MOUNT_LEARN \
            --shm-size 256m $GPU_OPT $CONT_NAME \
            -it $DETACH --rm $IMAGE_NAME:latest"
    echo "docker run $RUN_OPT $COMMAND"

    ## Running docker
    if [[ "$SCREEN" = true ]]; then
        echo "Running the docker in a screen session."
        screen -d -m \
            docker run $RUN_OPT $COMMAND
    else
        docker run $RUN_OPT $COMMAND
    fi
else
    if [[ "$EXEC" = true ]]; then
        echo "Attaching to a running docker (see container id using 'docker ps')."
        docker exec -it "$CONTAINER" /bin/bash
    fi
fi

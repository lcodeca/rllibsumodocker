#!/bin/bash

# Example of docker tester of SUMO Utlis RLLIB integration
#
# Author: Lara CODECA
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.

# echo "Parameters:"
# echo "  IMAGE name \"$IMAGE_NAME\" [-n, --image-name]"
# echo "  IMAGE folder \"$IMAGE_FOLDER\" [-f, --image-folder]"
# echo "  GPU enabled ($GPU) [--no-gpu]"
# echo "  OPTIRUN disabled ($OPTIRUN) [--with-optirun]"
# echo "  BUILD: $BUILD [-b, --build], with CACHE: $CACHE [-c, --cache]"
# echo "  RUN: $RUN [-r, --run], with SCREEN: $SCREEN [-s, --screen]"
# echo "  EXEC: $EXEC [-e, --exec], CONTAINER: \"$CONTAINER\" (use docker ps for the id)"
# echo "  COMMAND: \"$COMMAND\" [--cmd]"
# echo "  EXP: \"$EXP\" [--exp]"
# echo "  DETACH: ($DETACH) [--detach]"
# echo "  DEVELOPMENT dir \"$DEVEL_DIR\" [-d, --devel]"
# echo "  LEARNING dir \"$LEARN_DIR\" [-l, --learn]"
# echo "  SHM_SIZE \"$SHM_SIZE\" [--shm-size]"

bash docker-cmd-linux.sh -n="rllib-devel" -f="docker-devel-image-linux" \
    --with-optirun -b -c -r

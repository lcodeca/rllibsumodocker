# RLLIB SUMO Docker environment for Linux

## docker-cmd-linux.sh usage

``` bash
Default parameters:
  IMAGE name "tf-gpu-sumo-{today}"      [-n, --image-name]
  IMAGE folder "docker-image-linux"     [-f, --image-folder]
  GPU enabled (true)                    [--no-gpu]
  OPTIRUN disabled (false)              [--with-optirun]
  BUILD: false                          [-b, --build]
        with CACHE: false               [-c, --cache]
  RUN: false                            [-r, --run]
        with SCREEN: false              [-s, --screen]
  EXEC: false                           [-e, --exec]
        CONTAINER: "" (use docker ps for the id)
  COMMAND: ""                           [--cmd]
  EXP: ""                               [--exp]
  DETACH: (true)                        [--detach]
  DEVELOPMENT dir ""                    [-d, --devel]
  LEARNING dir ""                       [-l, --learn]
```

Example of use:

- Build the image (with GPU enabled) and launch the example learning in the terminal:
    `bash docker-cmd-linux.sh --build --cache --run`
- Build the image with a specific name and launch the example learning in the terminal:
    `bash docker-cmd-linux.sh --image-name=rllibsumoutils-docker --build --cache --run`
- Run the already built image in a screen:
    `bash docker-cmd-linux.sh --image-name=rllibsumoutils-docker --run --screen`
- Attach to an already running docker container (using docker ps to know the id):
    `bash docker-cmd-linux.sh --exec=9ed3cec06e`
- The default docker entry point in the image runs the tests. It can be changed by using:
    `bash docker-cmd-linux.sh --run --cmd="/bin/bash"`

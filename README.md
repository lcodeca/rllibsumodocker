# RLLIB SUMO Docker environment

Docker environment for [RLLIB+SUMO Utils](https://github.com/lcodeca/rllibsumoutils) python library.

Contact: Lara CODECA [lara.codeca@gmail.com]

This program and the accompanying materials are made available under the terms of
the Eclipse Public License 2.0 which is available at <http://www.eclipse.org/legal/epl-2.0>.

## Intent

The intent of this git is to provide a Docker environment for [RLLIB+SUMO Utils](https://github.com/lcodeca/rllibsumoutils).
It is based on the [Tensorflow Docker tutorial](https://www.tensorflow.org/install/docker), and presents the same the system requrements.

## docker-cms.sh usage

``` bash
Default parameters:
  IMAGE name "tf-gpu-sumo-{today}"      [-n, --image-name]
  IMAGE folder "docker-image"           [-f, --image-folder]
  GPU enabled (true)                    [--no-gpu]
  OPTIRUN disabled (false)              [--with-optirun]
  BUILD: false                          [-b, --build]
         with CACHE: false              [-c, --cache]
  RUN: false                            [-r, --run]
         with SCREEN: false             [-s, --screen]
  EXEC: false                           [-e, --exec]
         CONTAINER: "" (use docker ps for the id)
  COMMAND: ""                           [--cmd]
  DEVELOPMENT dir ""                    [-d, --devel]
  LEARNING dir ""                       [-l, --learn]
```

Example of use:

- Build the image (with GPU enabled) and launch the example learning in the terminal:
    `bash docker-cmd.sh --build --cache --run`
- Build the image with a specific name and launch the example learning in the terminal:
    `bash docker-cmd.sh --image-name=rllibsumoutils-docker --build --cache --run`
- Run the already built image in a screen:
    `bash docker-cmd.sh --image-name=rllibsumoutils-docker --run --screen`
- Attach to an already running docker container (using docker ps to know the id):
    `bash docker-cmd.sh --exec=9ed3cec06e`
- The default docker entry point in the image runs the tests. It can be changed by using:
    `bash docker-cmd.sh --run --cmd="/bin/bash"`

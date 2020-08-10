# RLLIB SUMO Docker environment for MacOS

## Step 1: Build your docker image

Basic command to use:

`bash docker-cmd-mac.sh --build`

- The default tag name of this image is `tf-gpu-sumo-{today_date}`. You can also add option such as `--image-name={new_name}` to specify your own name;
- The default path of the dockerfile to be used is `docker-image-mac`. You can adapt to your setting by using option `--image-folder`;
- The default image building process does not use cache. You can enable it by adding the option `--cache`.

## Step 2: Run a container of the built image

`sudo bash docker-cmd-mac.sh --image-name={your_image_name} --run --no-gpu`

> :warning: **Using SUDO for docker is not a good practice**: Due to a problem of user privilege between host and container, `sudo` has to be used here to make it work. We will address this security issue soon.

This will run `/home/alice/learning/training.sh` inside the docker container, which will then run `/home/alice/libraries/rllibsumoutils/example/ppotrain.py`.

To facilitate your development, you can add options to synchronize the code on your local system with the docker container. The mappings are as follows:

| Option      | Path (container) | Path (host)
| ----------- | ----------- | ----------- |
| [-d, --devel] | `/home/alice/devl/` | [your_path] |
| [-l, --learn] | `/home/alice/learning/` | [your_path]        |




## docker-cmd-mac.sh usage

``` bash
Default parameters:
  IMAGE name "tf-gpu-sumo-{today}"      [-n, --image-name]
  IMAGE folder "docker-image-mac"     [-f, --image-folder]
  GPU enabled (true)                    [--no-gpu]
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
    `bash docker-cmd-mac.sh --build --cache --run`
- Build the image with a specific name and launch the example learning in the terminal:
    `bash docker-cmd-mac.sh --image-name=rllibsumoutils-docker --build --cache --run`
- Run the already built image in a screen:
    `bash docker-cmd-mac.sh --image-name=rllibsumoutils-docker --run --screen`
- Attach to an already running docker container (using docker ps to know the id):
    `bash docker-cmd-mac.sh --exec=9ed3cec06e`
- The default docker entry point in the image runs the tests. It can be changed by using:
    `bash docker-cmd-mac.sh --run --cmd="/bin/bash"`

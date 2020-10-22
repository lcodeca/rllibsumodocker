FROM tensorflow/tensorflow:latest-gpu-py3

LABEL Author="Lara CODECA (lara.codeca@gmail.com)"
LABEL Description="Dockerised devel environment with SUMO and ray-rllib-gpu environment."

ARG USER_ID
ARG GROUP_ID

# Working user
RUN groupadd --gid ${GROUP_ID} alice && \
    useradd -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} alice && \
    echo "alice:alice" | chpasswd && adduser alice sudo

# Directory structure
USER alice
RUN mkdir -p /home/alice/devel  && \
    mkdir -p /home/alice/learning && \
    mkdir -p /home/alice/libraries

# Update System.
USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && apt-get autoremove -y

# Install Python 3.6 dependencies for SUMO and scripts
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    python3.6-dev \
    python3-tk \
    python3-virtualenv \
    python3-pip && apt-get autoremove -y
RUN python3.6 -m pip install --upgrade pip

# Misc packages
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gdb \
    git \
    htop \
    ipython3 \
    libtool \
    nano \
    psmisc \
    rsync \
    screen \
    tmux \
    tree \
    vim \
    x11-apps && apt-get autoremove -y
RUN python3.6 -m pip install \
    aiohttp \
    deepdiff \
    dill \
    folium \
    gputil \
    grpcio \
    matplotlib \
    numpy \
    numpyencoder \
    psutil \
    pyproj \
    setproctitle \
    shapely \
    tqdm

# Download and install SUMO Version v1_7_0
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    cmake \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libfox-1.6-0 \
    libfox-1.6-dev \
    libgdal-dev \
    libopenmpi-dev \
    librsvg2-bin \
    libswscale-dev \
    libxerces-c-dev \
    swig \
    zlib1g-dev && apt-get autoremove -y
USER alice
WORKDIR /home/alice
RUN git clone --depth 1 --branch v1_7_0 https://github.com/eclipse/sumo.git sumo && \
    mkdir -p /home/alice/sumo/build/cmake-build-release
WORKDIR /home/alice/sumo/build/cmake-build-release
USER alice
RUN cmake -D CHECK_OPTIONAL_LIBS=true -D CMAKE_BUILD_TYPE:STRING=Release /home/alice/sumo && \
    make -j$(nproc)
# RUN mkdir -p /home/alice/sumo/build/cmake-build-debug
# WORKDIR /home/alice/sumo/build/cmake-build-debug
# RUN cmake -D CHECK_OPTIONAL_LIBS=true -D CMAKE_BUILD_TYPE:STRING=Debug /home/alice/sumo  && \
#     make -j$(nproc)
RUN echo "# SUMO" >> /home/alice/.bashrc && \
    echo "export SUMO_HOME=\"/home/alice/sumo\"" >> /home/alice/.bashrc && \
    echo "export PATH=\"\$SUMO_HOME/bin:\$PATH\"" >> /home/alice/.bashrc

# Download and install RAY
# See:
#   https://docs.ray.io/en/latest/development.html#building-ray-python-only
#   https://docs.ray.io/en/latest/development.html#building-ray-full
USER root
RUN python3.6 -m pip install \
    dataclasses \
    dm-tree \
    gym \
    lz4 \
    opencv-python \
    pandas \
    pytest \
    ray \
    ray[debug] \
    ray[rllib] \
    ray[tune] \
    tabulate
RUN python3.6 -m pip install -U https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-1.1.0.dev0-cp36-cp36m-manylinux1_x86_64.whl
USER alice
WORKDIR /home/alice/libraries
RUN git clone --depth 1 --branch sumo-gym-env https://github.com/lcodeca/ray.git ray
WORKDIR /home/alice/libraries/ray
USER root
RUN python3.6 python/ray/setup-dev.py --yes

# RLLIB+SUMO Utils requirements
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    libspatialindex-dev \
    python-rtree && apt-get autoremove -y
RUN python3.6 -m pip install lxml rtree

# Learning Environment
USER alice
WORKDIR /home/alice/learning
COPY --chown=alice tf-gpu-test.py /home/alice/learning/tf-gpu-test.py
COPY --chown=alice training.sh /home/alice/learning/training.sh

USER alice
WORKDIR /home/alice/learning
CMD ["./training.sh"]

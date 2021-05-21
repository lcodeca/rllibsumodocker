FROM tensorflow/tensorflow:latest-gpu-py3

LABEL Author="Lara CODECA (lara.codeca@gmail.com)"
LABEL Description="Dockerised SUMO-devel with tensorflow-gpu environment."

ARG USER_ID
ARG GROUP_ID

# Install system dependencies.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    cmake \
    gdb \
    git \
    htop \
    ipython3 \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libfox-1.6-0 \
    libfox-1.6-dev \
    libgdal-dev \
    libopenmpi-dev \
    librsvg2-bin \
    libspatialindex-dev \
    libswscale-dev \
    libtool \
    libxerces-c-dev \
    nano \
    psmisc \
    python3.6-dev \
    python3-tk \
    python3-virtualenv \
    rsync \
    screen \
    sudo \
    swig \
    tmux \
    tree \
    vim \
    x11-apps \
    zlib1g-dev && apt-get autoremove -y

# Install Python 3 dependencies for SUMO and scripts
RUN pip install --upgrade pip && python -m pip install \
    aiohttp \
    deepdiff \
    dill \
    folium \
    gputil \
    grpcio \
    lxml \
    lz4 \
    matplotlib \
    numpy \
    numpyencoder \
    opencv-python \
    pandas \
    psutil \
    pyproj \
    rtree \
    setproctitle \
    shapely \
    tqdm

# Install Python 3 dependencies for MARL
RUN python -m pip install gym && \
    python -m pip install ray==1.3.0 && \
    python -m pip install ray[debug]==1.3.0 && \
    python -m pip install ray[rllib]==1.3.0 && \
    python -m pip install ray[tune]==1.3.0

# Working user
RUN groupadd --gid ${GROUP_ID} alice && \
    useradd -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} alice && \
    echo "alice:alice" | chpasswd && adduser alice sudo
USER alice

# Download and install SUMO Version v1_9_2
WORKDIR /home/alice
RUN git clone --depth 1 --branch 1_9_2 https://github.com/eclipse/sumo.git sumo && \
    mkdir -p /home/alice/sumo/build/cmake-build-release
WORKDIR /home/alice/sumo/build/cmake-build-release
RUN cmake -D CHECK_OPTIONAL_LIBS=true -D CMAKE_BUILD_TYPE:STRING=Release /home/alice/sumo && \
    make -j$(nproc)
# RUN mkdir -p /home/alice/sumo/build/cmake-build-debug
# WORKDIR /home/alice/sumo/build/cmake-build-debug
# RUN cmake -D CHECK_OPTIONAL_LIBS=true -D CMAKE_BUILD_TYPE:STRING=Debug /home/alice/sumo  && \
#     make -j$(nproc)
RUN echo "# SUMO" >> /home/alice/.bashrc && \
    echo "export SUMO_HOME=\"/home/alice/sumo\"" >> /home/alice/.bashrc && \
    echo "export PATH=\"\$SUMO_HOME/bin:\$PATH\"" >> /home/alice/.bashrc

# Directory structure
RUN mkdir -p /home/alice/devel  && \
    mkdir -p /home/alice/learning && \
    mkdir -p /home/alice/libraries

# Download & install RLLIB+SUMO Utils
WORKDIR /home/alice/libraries
RUN git clone --depth 1 https://github.com/lcodeca/rllibsumoutils.git rllibsumoutils
WORKDIR /home/alice/libraries/rllibsumoutils
USER root
RUN python -m pip install -e .

# Learning Environment
USER alice
WORKDIR /home/alice/learning
COPY --chown=alice tf-gpu-test.py /home/alice/learning/tf-gpu-test.py
COPY --chown=alice training.sh /home/alice/learning/training.sh

USER alice
WORKDIR /home/alice/learning
CMD ["./training.sh"]

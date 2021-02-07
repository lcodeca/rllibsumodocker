FROM tensorflow/tensorflow:latest-gpu-py3

LABEL Author="Lara CODECA (lara.codeca@gmail.com)"
LABEL Description="Dockerised SUMO-devel with tensorflow-gpu environment, RLLIBSUMOUtils and PyPML."

ARG USER_ID
ARG GROUP_ID

# Install system dependencies.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    cmake \
    gdb \
    git \
    htop \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libfox-1.6-0 \
    libfox-1.6-dev \
    libgdal-dev \
    libopenmpi-dev \
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
    zlib1g-dev

# Install Python 3 dependencies for SUMO and scripts
RUN pip install --upgrade pip
RUN python -m pip install \
    aiohttp \
    dill \
    folium \
    gputil \
    grpcio \
    lxml \
    lz4 \
    matplotlib \
    numpy \
    opencv-python \
    pandas \
    psutil \
    pyproj \
    rtree \
    setproctitle \
    shapely \
    tqdm 

# Install Python 3 dependencies for MARL
RUN python -m pip install gym 
RUN python -m pip install ray
RUN python -m pip install ray[debug]
RUN python -m pip install ray[rllib]
RUN python -m pip install ray[tune]

# Working user
#RUN groupadd --gid ${GROUP_ID} alice && \
#    useradd -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} alice && \
#    echo "alice:alice" | chpasswd && adduser alice sudo
#USER alice

# Working user
RUN groupadd --gid 197121 alice && \
    useradd -m -s /bin/bash -u 197108 -g 197121 alice && \
    echo "alice:alice" | chpasswd && adduser alice sudo
USER alice

# Download and install SUMO
WORKDIR /home/alice
RUN git clone --depth 1 https://github.com/eclipse/sumo.git sumo
RUN mkdir -p /home/alice/sumo/build/cmake-build-release
WORKDIR /home/alice/sumo/build/cmake-build-release
RUN cmake -D CHECK_OPTIONAL_LIBS=true -D CMAKE_BUILD_TYPE:STRING=Release /home/alice/sumo
RUN make -j$(nproc)
RUN mkdir -p /home/alice/sumo/build/cmake-build-debug
WORKDIR /home/alice/sumo/build/cmake-build-debug
RUN cmake -D CHECK_OPTIONAL_LIBS=true -D CMAKE_BUILD_TYPE:STRING=Debug /home/alice/sumo
RUN make -j$(nproc)

# Directory structure
USER alice
RUN mkdir -p /home/alice/devel
RUN mkdir -p /home/alice/learning
RUN mkdir -p /home/alice/libraries
RUN mkdir -p /home/alice/testing

# Download & install RLLIB+SUMO Utils
USER alice
WORKDIR /home/alice/libraries
RUN git clone --depth 1 https://github.com/lcodeca/rllibsumoutils.git rllibsumoutils
WORKDIR /home/alice/libraries/rllibsumoutils
USER root
RUN python -m pip install -e .

CMD ["export SUMO_HOME=/home/alice/sumo"]
# Download & install PyPML Utils
USER alice
WORKDIR /home/alice/libraries
RUN git clone --depth 1 https://github.com/lcodeca/PyPML pypml
WORKDIR /home/alice/libraries/pypml
USER root
RUN python -m pip install -e .

# Testing Environment
USER alice
WORKDIR /home/alice/testing
COPY --chown=alice tf-gpu-test.py /home/alice/testing/tf-gpu-test.py

USER alice
WORKDIR /home/alice/learning
CMD ["./training.sh"]

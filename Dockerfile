# Base image
ARG BASE_IMAGE=nvidia/cuda:12.2.0-runtime-ubuntu22.04
FROM ${BASE_IMAGE} as dev-base

# Working directory
WORKDIR /workspace

# Set necessary environment variables
ENV DEBIAN_FRONTEND=noninteractive\
    SHELL=/bin/bash\
    PATH="/root/.local/bin:$PATH"

RUN echo $(uname -a)

# Update, upgrade, and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends\
    git\
    wget\
    curl\
    libgl1\
    build-essential \ 
    software-properties-common\
    openssh-server \ 
    vim \
    linux-headers-$(uname -r) 

# Set Python and pip
RUN ln -s /usr/bin/python3.10 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    rm -f get-pip.py

# Install Python packages
RUN pip install --no-cache-dir -U jupyterlab ipywidgets jupyter-archive jupyter_contrib_nbextensions && \
    jupyter nbextension enable --py widgetsnbextension 

# install other import packages
RUN apt-get install g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y

# Add start script
COPY start.sh /workspace
RUN chmod +x /workspace/start.sh

# Set default command
CMD [ "/workspace/start.sh" ]
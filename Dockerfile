FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo gosu ssh \
    build-essential cmake clang \
    tmux byobu git curl wget vim tree htop zip unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG ROOT_PASSWORD="password"
RUN echo "root:$ROOT_PASSWORD" | chpasswd

WORKDIR /opt
RUN wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
RUN sh /opt/Miniconda3-py39_4.9.2-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -f Miniconda3-py39_4.9.2-Linux-x86_64.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
ENV PATH /opt/miniconda3/bin:$PATH

RUN conda create -n py37asp python==3.7
RUN conda init bash

SHELL ["conda", "run", "-n", "py37asp", "/bin/bash", "-c"]

RUN conda install numpy scipy pandas scikit-learn matplotlib jupyter



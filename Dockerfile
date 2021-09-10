FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo gosu ssh \
    build-essential cmake clang \
    tmux byobu git curl wget vim tree htop zip unzip \
    libopenblas-base libopenblas-dev liblapack-dev libatlas-base-dev\
    libfftw3-dev libfftw3-doc \
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

RUN conda update -n base -c defaults conda
RUN conda create -n py37asp python==3.7
RUN conda init bash

SHELL ["conda", "run", "-n", "py37asp", "/bin/bash", "-c"]

RUN conda install -y -c conda-forge jupyterlab
RUN conda install -y -c conda-forge tqdm
RUN conda install -y -c conda-forge hydra-core

RUN conda install -y -c conda-forge cmake
RUN conda install -y -c conda-forge make
RUN conda install -y -c conda-forge fftw
RUN conda install -y -c conda-forge cython
RUN conda install -y -c conda-forge six

RUN conda install -y -c conda-forge nomkl
RUN conda install -y -c conda-forge numpy
RUN conda install -y -c conda-forge scipy
RUN conda install -y -c conda-forge openblas
RUN conda install -y -c conda-forge lapack

RUN conda install -y -c conda-forge opt_einsum
RUN conda install -y -c conda-forge scikit-learn
RUN conda install -y -c conda-forge pandas
RUN conda install -y -c conda-forge matplotlib
RUN conda install -y -c conda-forge seaborn

RUN conda install -y -c conda-forge pysoundfile
RUN conda install -y -c conda-forge librosa
RUN conda install -y -c conda-forge cmaes
RUN conda install -y -c conda-forge optuna

RUN pip install pyroomacoustics
RUN pip install cookiecutter
RUN pip install ltfatpy
RUN pip install museval

# User Setting
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

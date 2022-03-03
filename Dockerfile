FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo gosu ssh \
    build-essential ca-certificates cmake clang \
    tmux byobu git curl wget vim tree htop zip unzip \
    libopenblas-base libopenblas-dev liblapack-dev libatlas-base-dev\
    libfftw3-dev libfftw3-doc \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6 \
    git \
    git-lfs \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:git-core/ppa -y && \
    apt update && \
    apt install -y --no-install-recommends git-all && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
RUN conda create -n py39asp python==3.9
RUN conda init bash

SHELL ["conda", "run", "-n", "py39asp", "/bin/bash", "-c"]

RUN conda install -y -c conda-forge jupyterlab=3.2.6

RUN conda install -y -c conda-forge cython=0.29.26
RUN conda install -y -c conda-forge numpy=1.22.0
RUN conda install -y -c conda-forge scipy=1.7.3
RUN conda install -y -c conda-forge opt_einsum=3.3.0
RUN conda install -y -c conda-forge scikit-learn=1.0.2
RUN conda install -y -c conda-forge pandas=1.3.5
RUN conda install -y -c conda-forge matplotlib=3.5.1
RUN conda install -y -c conda-forge tqdm=4.62.3

RUN conda install -y -c conda-forge seaborn=0.11.1
RUN conda install -y -c conda-forge pysoundfile=0.10.3.post1
RUN conda install -y -c conda-forge librosa=0.8.1
RUN conda install -y -c conda-forge hydra-core=1.0.6
RUN conda install -y -c conda-forge optuna=2.9.1
RUN conda install -y -c conda-forge pylint=2.7.2

RUN pip install --no-cache-dir pyroomacoustics==0.4.3
RUN pip install --no-cache-dir cookiecutter==1.7.3
RUN pip install --no-cache-dir museval==0.4.0
RUN pip install --no-cache-dir nara-wpe==0.0.7
RUN pip install --no-cache-dir pesq
RUN pip install --no-cache-dir pystoi

# User Setting
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

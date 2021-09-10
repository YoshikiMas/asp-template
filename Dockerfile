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

RUN conda install -y -c conda-forge jupyterlab=3.0.16

RUN conda install -y -c intel cython=0.29.23
RUN conda install -y -c intel numpy=1.20.3
RUN conda install -y -c intel scipy=1.6.2
RUN conda install -y -c intel opt_einsum=3.3.0
RUN conda install -y -c intel scikit-learn=0.24.2
RUN conda install -y -c intel pandas=1.2.0
RUN conda install -y -c intel matplotlib=3.1.2
RUN conda install -y -c intel tqdm=4.60.0

RUN conda install -y -c conda-forge seaborn=0.11.1
RUN conda install -y -c conda-forge pysoundfile=0.10.3.post1
RUN conda install -y -c conda-forge librosa=0.8.1
RUN conda install -y -c conda-forge hydra-core=1.0.6
RUN conda install -y -c conda-forge optuna=2.9.1

RUN pip install pyroomacoustics==0.4.3
RUN pip install cookiecutter==1.7.3

# User Setting
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

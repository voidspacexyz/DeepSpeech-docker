FROM ubuntu:16.04

ENV GIT_LFS_VER=2.1.1

WORKDIR /tmp

## Install the basic things
RUN apt-get update \
   && apt-get install -y --no-install-recommends \
      curl \
      git \
      python-pip \
      python-dev \
      python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose \
   && apt-get install -y \
      build-essential \
      libssl-dev \
      libffi-dev \
      wget \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

## Install git-lfs
RUN curl -L https://github.com/git-lfs/git-lfs/releases/download/v$GIT_LFS_VER/git-lfs-linux-amd64-$GIT_LFS_VER.tar.gz \
   | tar xvzf - \
   && git-lfs-$GIT_LFS_VER/install.sh \
   && rm -rf git-lfs-$GIT_LFS_VER

## Install all the python packages
RUN pip install --upgrade pip \
   && pip install --upgrade \
      setuptools \
   && pip install --upgrade \
      tensorflow \
      pyxdg \
      python_speech_features \
      sox \
      pandas

WORKDIR /work
RUN git clone https://github.com/mozilla/DeepSpeech \
   && cd DeepSpeech \
   && pip install -r requirements.txt
RUN wget https://index.taskcluster.net/v1/task/project.deepspeech.deepspeech.native_client.master.cpu/artifacts/public/native_client.tar.xz -P /tmp \
        && cd /tmp \
        && tar -xJvf native_client.tar.xz \
        && cp libctc_decoder_with_kenlm.so /work/DeepSpeech/native_client

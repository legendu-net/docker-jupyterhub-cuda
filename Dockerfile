# NAME: dclong/jupyterhub-cuda
FROM dclong/jupyterhub
# GIT: https://github.com/dclong/docker-jupyterhub.git

ARG repo=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64
ARG repo_ml=https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64
#@Qustion: Do we really need gnupg2 here?
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg2 \
    && apt-key adv --fetch-keys $repo/3bf863cc.pub \
    && apt-key adv --fetch-keys $repo/7fa2af80.pub \
    && echo "deb $repo /" > /etc/apt/sources.list.d/cuda.list \
    && echo "deb $repo_ml /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && /scripts/sys/purge_cache.sh

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cuda-cudart-11-1=11.1.74-1 \
        cuda-compat-11-1 \
    && /scripts/sys/purge_cache.sh

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.1 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450"

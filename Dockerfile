# NAME: dclong/jupyterhub-cuda
FROM dclong/jupyterhub
# GIT: https://github.com/dclong/docker-jupyterhub.git

ARG repo=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64
ARG repo_ml=https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg2 \
    && curl -fsSL $repo/7fa2af80.pub | apt-key add - \
    && echo "deb $repo /" > /etc/apt/sources.list.d/cuda.list \
    && echo "deb $repo_ml /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && rm -rf /var/lib/apt/lists/*

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cuda-cudart-11-1 \
        cuda-compat-10-1 \
    && ln -s cuda-10.1 /usr/local/cuda \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"

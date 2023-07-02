# jupyter base image
FROM jupyter/scipy-notebook:lab-3.6.3 as cpu-only

# install python libraries
RUN mamba install --yes \
    'cookiecutter=2.1.1' \
    'ipynbname=2021.3.2' \
    'pipreqsnb=0.2.4' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# install separate pip libraries
RUN pip install tensorflow==2.12.*

# additional GPU-enabled steps
FROM cpu-only as gpu-enabled

# install CUDA tools
RUN mamba install -c conda-forge cudatoolkit=11.8.0 && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# install separate pip libraries
RUN pip install nvidia-cudnn-cu11==8.6.0.163

# setting up CUDA library link
RUN export CUDNN_PATH=$(dirname \
    $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)")) && \
    ln -s ${CUDNN_PATH} ${CONDA_DIR}/lib/cudnn.ln

# setting dynamic link lib paths
ENV LD_LIBRARY_PATH=${CONDA_DIR}/lib/:${CONDA_DIR}/lib/cudnn.ln/lib

# host NVIDIA driver minimum version metadata
LABEL nvidia.driver.minimum_version="450.80.02"
# jupyter base image
FROM jupyter/tensorflow-notebook:lab-3.6.3

# install python libraries
RUN mamba install --yes \
    'cenpy=1.0.1' \
    'contextily=1.3.0' \
    'cookiecutter=2.1.1' \
    'graphviz=7.1.0' \
    'ipynbname=2021.3.2' \
    'nashpy=0.0.35' \
    'osmnx=1.3.0' \
    'pipreqsnb=0.2.4' \
    'python-graphviz=0.20.1' \
    'scikit-surprise=1.1.3' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

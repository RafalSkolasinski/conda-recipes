FROM centos:7
MAINTAINER Rafal Skolasinski <r.j.skolasinski@gmail.com>

USER root
RUN yum install -y bzip2 wget
RUN yum groupinstall -y "Development Tools"

RUN wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
RUN echo "4692f716c82deb9fa6b59d78f9f6e85c" Anaconda3-4.2.0-Linux-x86_64.sh | md5sum -c
#
RUN /bin/bash Anaconda3-4.2.0-Linux-x86_64.sh -b
RUN rm Anaconda3-4.2.0-Linux-x86_64.sh

RUN echo 'export PATH="/root/anaconda3/bin:$PATH"' > /root/.bashrc
ENV PATH /root/anaconda3/bin:$PATH
RUN conda install -y conda-build
RUN conda update -y conda-build


RUN mkdir /recipes
WORKDIR /recipes/


# Building discretizer
ADD discretizer /recipes/discretizer
RUN conda build discretizer --python 2.7
RUN conda build discretizer --python 3.4
RUN conda build discretizer --python 3.5


# Building ipymd
ADD ipymd /recipes/ipymd
RUN conda build ipymd --python 2.7
RUN conda build ipymd --python 3.5


# Entrypoint
CMD ["/bin/bash"]

#!/bin/bash
FROM jarvice/ubuntu-ibm-mldl-ppc64le

#add Jupyter
RUN pip install ipython==5.0 notebook==5.0 pyyaml
#RUN pip install notebook pyyaml

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
#add startupscripts
RUN apt-get install -y supervisor

#WORKDIR /root
#ADD startjupyter.sh /root/
#ADD conf.d/* /etc/supervisor/conf.d/
#ADD rc.local /etc/rc.local

RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    vim \
    jed \
    emacs \
    build-essential \
    python-dev \
    unzip \
    libsm6 \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    libxrender1 \
    inkscape \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
        apt-get install -y --no-install-recommends libav-tools && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN pip install numpy scipy
RUN pip install scikit-learn
RUN pip install pillow
RUN pip install h5py
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
RUN pip install keras

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential cmake pkg-config
#RUN apt-get -y install libjpeg62-turbo-dev libtiff5-dev libjasper-dev libpng12-dev
RUN apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get -y install libxvidcore-dev libx264-dev
RUN apt-get -y install libgtk-3-dev
RUN apt-get -y install libatlas-base-dev gfortran
#RUN apt-get -y install python2.7-dev python3.5-dev
RUN apt-get -y install python-opencv

RUN apt-get -y install lsof
RUN apt-get -y install locate
RUN updatedb

ARG CACHE_DATE=2017-09-26

#add wbc example 
# Add Dustins DSX Example
WORKDIR /root/data
RUN wget http://www.mpi-sws.org/~cristian/data/cornell_movie_dialogs_corpus.zip
WORKDIR /root
RUN git clone https://github.com/dustinvanstee/mldl-101.git && \
    git clone https://github.com/llSourcell/tensorflow_chatbot.git
ADD startjupyter.sh /root
ADD cpuonly.sh /root
ADD setup_powerai_env.sh /root
#RUN git clone https://github.com/dhruvp/wbc-classification.git
#EXPOSE 5555
#RUN /bin/bash -c "mkdir -p /data/mldl-101/; cd /data/mldl-101/" 

#add NIMBIX application
COPY AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate
ENTRYPOINT ["/bin/bash"]
#CMD ["/usr/bin/supervisord", "-n","-c" ,"/etc/supervisor/supervisord.conf"]
#CMD ["ls"]

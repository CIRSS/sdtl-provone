FROM ubuntu:20.04

ENV REPRO_NAME  sdtl-provone
ENV REPRO_MNT   /mnt/${REPRO_NAME}
ENV REPRO_USER  repro
ENV REPRO_UID   1000
ENV REPRO_GID   1000

RUN echo '***** Update packages *****'                                      \
    && apt-get -y update

RUN echo '***** Set timezone noninteractively install JDK8 *****'
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"               \
    apt -y install tzdata openjdk-8-jdk

RUN echo '***** Install packages required for creating this image *****'    \
    && apt -y install apt-utils wget curl makepasswd gcc make git           \
                                                                            \
    && echo '***** Install command-line utility packages *****'             \
    && apt -y install sudo man less file tree jq graphviz libxml2-utils

RUN echo '***** Install python3 and required pip packages *****'            \
    && apt -y install python3 python3-pip                                   \
    && pip3 install -U pip                                                  \
    && pip3 install pandas

RUN echo '***** Add the REPRO user and group *****'                         \
    && groupadd ${REPRO_USER} --gid ${REPRO_GID}                            \
    && useradd ${REPRO_USER} --uid ${REPRO_UID} --gid ${REPRO_GID}          \
        --shell /bin/bash                                                   \
        --create-home                                                       \
        -p `echo repro | makepasswd --crypt-md5 --clearfrom - | cut -b8-`   \
    && echo "${REPRO_USER} ALL=(ALL) NOPASSWD: ALL"                         \
            > /etc/sudoers.d/${REPRO_USER}                                  \
    && chmod 0440 /etc/sudoers.d/repro

ENV HOME /home/${REPRO_USER}
ENV BASHRC ${HOME}/.bashrc
USER ${REPRO_USER}
WORKDIR $HOME

# install scripts for building and configuring the REPRO
ENV REPRO_SCRIPTS_DIR ${HOME}/scripts
COPY --chown=repro:repro .repro/scripts ${REPRO_SCRIPTS_DIR}
RUN chmod a+rx ${REPRO_SCRIPTS_DIR}/*.sh

# install dependency bundles
ENV BUNDLES_DIR ${HOME}/bundles
ENV BUNDLES_URL_TEMPLATE 'https://github.com/cirss/${name}/releases/download/v${version}/${name}-${version}-linux-x86-64-static'
RUN scripts/install-bundle.sh geist 0.2.6
RUN scripts/install-bundle.sh blaze 0.2.6

ENV REPMOD_URL_TEMPLATE 'https://raw.githubusercontent.com/tmcphillips/${name}/${version}/exports/'
RUN scripts/install-repmod.sh blazegraph master

RUN echo "export PATH=${REPRO_MNT}/binaries:`cat ~/.bundle_path`$PATH" >> ${BASHRC}
RUN echo "export IN_RUNNING_REPRO=${REPRO_NAME}" >> ${BASHRC}
RUN echo "cd ${REPRO_MNT}" >> ${BASHRC}
RUN echo "start_blazegraph.sh" >> ${BASHRC}

CMD  /bin/bash -il

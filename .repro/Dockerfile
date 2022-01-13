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
ENV USER_BIN ${HOME}/bin
ENV BASHRC ${HOME}/.bashrc
USER  ${REPRO_USER}
WORKDIR $HOME

RUN echo '***** Make the user bin directory *****'                          \
    && mkdir ${USER_BIN}

ENV GEIST_VERSION 0.2.6
ENV GEIST_RELEASES https://github.com/cirss/geist/releases
ENV GEIST_DOWNLOADS ${GEIST_RELEASES}/download/v${GEIST_VERSION}
ENV GEIST_DOWNLOAD ${GEIST_DOWNLOADS}/geist-${GEIST_VERSION}-linux-x86-64-static
ENV GEIST_BINARY ${USER_BIN}/geist

RUN echo '***** Install Geist in user bin directory *****'                  \
    && wget -O ${GEIST_BINARY} ${GEIST_DOWNLOAD}                           \
    && chmod u+x ${GEIST_BINARY}

ENV BLAZE_VERSION 0.2.6
ENV BLAZE_RELEASES https://github.com/cirss/blaze/releases
ENV BLAZE_DOWNLOADS ${BLAZE_RELEASES}/download/v${BLAZE_VERSION}
ENV BLAZE_DOWNLOAD ${BLAZE_DOWNLOADS}/blaze-${BLAZE_VERSION}-linux-x86-64-static
ENV BLAZE_BINARY ${USER_BIN}/blaze

RUN echo '***** Install Blaze in user bin directory *****'                  \
    && wget -O ${BLAZE_BINARY} ${BLAZE_DOWNLOAD}                            \
    && chmod u+x ${BLAZE_BINARY}

ENV BLAZEGRAPH_VER RELEASE_2_1_5
ENV BLAZEGRAPH_RELEASES https://github.com/blazegraph/database/releases
ENV BLAZEGRAPH_DOWNLOAD_DIR ${BLAZEGRAPH_RELEASES}/download/BLAZEGRAPH_${BLAZEGRAPH_VER}
ENV BLAZEGRAPH_DOWNLOAD_JAR ${BLAZEGRAPH_DOWNLOAD_DIR}/blazegraph.jar
ENV BLAZEGRAPH_JAR $HOME/blazegraph-${BLAZEGRAPH_VER}.jar

RUN echo '***** Download Blazegraph jar *****'                              \
    && wget -O ${BLAZEGRAPH_JAR} ${BLAZEGRAPH_DOWNLOAD_JAR}

ENV BLAZEGRAPH_DOT_DIR ${REPRO_MNT}/.blazegraph
ENV BLAZEGRAPH_PROPERTY_FILE=${BLAZEGRAPH_DOT_DIR}/.properties
ENV BLAZEGRAPH_OPTIONS "-server -Xmx4g -Dbigdata.propertyFile=${BLAZEGRAPH_PROPERTY_FILE}"
ENV BLAZEGRAPH_CMD "java ${BLAZEGRAPH_OPTIONS} -jar ${BLAZEGRAPH_JAR}"
ENV BLAZEGRAPH_LOG ${BLAZEGRAPH_DOT_DIR}/blazegraph_`date +%s`.log

RUN echo '***** Start Blazegraph at login *****'                            \
    && echo "source .bashrc" >> .bash_profile                               \
    && echo "cd ${BLAZEGRAPH_DOT_DIR} && ${BLAZEGRAPH_CMD} 2>&1 > ${BLAZEGRAPH_LOG} &" >> .bash_profile

RUN echo "export PATH=${REPRO_MNT}/binaries:${HOME}/bin:$PATH" >> ${BASHRC}
RUN echo "export IN_RUNNING_REPRO=${REPRO_NAME}" >> ${BASHRC}
RUN echo "cd ${REPRO_MNT}" >> ${BASHRC}

CMD  /bin/bash -il

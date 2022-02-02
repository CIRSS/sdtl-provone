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
ENV BUNDLES ${HOME}/bundles
ENV BUNDLE_PATH $BUNDLES
ENV BASHRC ${HOME}/.bashrc
USER ${REPRO_USER}
WORKDIR $HOME

ENV GEIST_VERSION 0.2.6
ENV GEIST_URL https://github.com/cirss/geist/releases/download/v${GEIST_VERSION}/geist-${GEIST_VERSION}-linux-x86-64-static
ENV GEIST_BUNDLE ${BUNDLES}/geist-${GEIST_VERSION}
ENV GEIST_BINARY ${GEIST_BUNDLE}/geist
ENV BUNDLE_PATH ${BUNDLE_PATH}:$GEIST_BUNDLE

RUN echo '***** Install Geist bundle *****'                  \
    && mkdir -p ${GEIST_BUNDLE}                                             \
    && wget -O ${GEIST_BINARY} ${GEIST_URL}                           \
    && chmod u+x ${GEIST_BINARY}

ENV BLAZE_VERSION 0.2.6
ENV BLAZE_URL https://github.com/cirss/blaze/releases/download/v${BLAZE_VERSION}/blaze-${BLAZE_VERSION}-linux-x86-64-static
ENV BLAZE_BUNDLE ${BUNDLES}/blaze-${BLAZE_VERSION}
ENV BLAZE_BINARY ${BLAZE_BUNDLE}/blaze
ENV BUNDLE_PATH ${BUNDLE_PATH}:$BLAZE_BUNDLE

RUN echo '***** Install Blaze bundle *****'                             \
    && mkdir -p ${BLAZE_BUNDLE}                                         \
    && wget -O ${BLAZE_BINARY} ${BLAZE_URL}                             \
    && chmod u+x ${BLAZE_BINARY}

ENV BLAZEGRAPH_VERSION RELEASE_2_1_5
ENV BLAZEGRAPH_JAR_URL https://github.com/blazegraph/database/releases/download/BLAZEGRAPH_${BLAZEGRAPH_VERSION}/blazegraph.jar
ENV BLAZEGRAPH_BUNDLE ${BUNDLES}/blazegraph-${BLAZEGRAPH_VERSION}
ENV BLAZEGRAPH_JAR ${BLAZEGRAPH_BUNDLE}/blazegraph.jar

RUN echo '***** Download Blazegraph jar *****'                              \
    && mkdir -p ${BLAZEGRAPH_BUNDLE}                                         \
    && wget -O ${BLAZEGRAPH_JAR} ${BLAZEGRAPH_JAR_URL}

ENV BLAZEGRAPH_DOT_DIR ${REPRO_MNT}/.blazegraph
ENV BLAZEGRAPH_PROPERTY_FILE=${BLAZEGRAPH_DOT_DIR}/.properties
ENV BLAZEGRAPH_OPTIONS "-server -Xmx4g -Dbigdata.propertyFile=${BLAZEGRAPH_PROPERTY_FILE}"
ENV BLAZEGRAPH_CMD "java ${BLAZEGRAPH_OPTIONS} -jar ${BLAZEGRAPH_JAR}"
ENV BLAZEGRAPH_LOG ${BLAZEGRAPH_DOT_DIR}/blazegraph_`date +%s`.log

RUN echo '***** Start Blazegraph at login *****'                            \
    && echo "source .bashrc" >> .bash_profile                               \
    && echo "cd ${BLAZEGRAPH_DOT_DIR} && ${BLAZEGRAPH_CMD} 2>&1 > ${BLAZEGRAPH_LOG} &" >> .bash_profile

RUN echo "export PATH=${REPRO_MNT}/binaries:${BUNDLE_PATH}:$PATH" >> ${BASHRC}
RUN echo "export IN_RUNNING_REPRO=${REPRO_NAME}" >> ${BASHRC}
RUN echo "cd ${REPRO_MNT}" >> ${BASHRC}

CMD  /bin/bash -il

FROM docker.io/cirss/repro-template

COPY .repro .repro

USER repro

# install required repro modules
RUN repro.require blaze 0.2.6 ${CIRSS_RELEASE}
RUN repro.require geist 0.2.6 ${CIRSS_RELEASE}
RUN repro.require blazegraph-service 0.2.6  ${CIRSS_RELEASE}
RUN repro.require sdtl-provone exported ${CIRSS_RELEASE} --demo

RUN repro.atstart start-blazegraph

CMD  /bin/bash -il

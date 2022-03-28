FROM docker.io/cirss/repro-template

COPY exports /repro/exports

USER repro

# install required repro modules
RUN repro.require blaze 0.2.6 ${CIRSS_RELEASE}
RUN repro.require geist 0.2.6 ${CIRSS_RELEASE}
RUN repro.require blazegraph-service master ${CIRSS_BRANCH}
RUN repro.require sdtl-provone exports --demo

RUN repro.atstart blazegraph-service.start

CMD  /bin/bash -il

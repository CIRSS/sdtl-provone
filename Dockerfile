FROM docker.io/cirss/blazegraph-service

COPY .repro .repro

USER repro

# URLs for packages delivered as CIRSS GitHub releases
ENV CIRSS_RELEASES 'https://github.com/cirss/${1}/releases/download/v${2}/'

# install required repro modules
RUN repro.require blaze 0.2.6 ${CIRSS_RELEASES}
RUN repro.require geist 0.2.6 ${CIRSS_RELEASES}
RUN repro.require blazegraph-service 0.2.6  ${CIRSS_RELEASES}
RUN repro.require sdtl-provone exported ${CIRSS_RELEASES} --demo

RUN repro.atstart start-blazegraph

CMD  /bin/bash -il

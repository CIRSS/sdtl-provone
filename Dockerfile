FROM cirss/repro-parent:latest

COPY exports /repro/exports

ADD ${REPRO_DIST}/setup /repro/dist/
RUN bash /repro/dist/setup

USER repro

# install required repro modules
RUN repro.require sdtl-provone exports --demos
RUN repro.require geist 0.2.6 ${CIRSS_RELEASE}
RUN repro.require blazegraph-service master ${CIRSS}
RUN repro.require blaze 0.2.6 ${CIRSS_RELEASE}

CMD  /bin/bash -il

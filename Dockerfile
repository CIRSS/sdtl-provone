FROM cirss/repro-parent:latest

COPY exports /repro/exports

ADD ${REPRO_DIST}/boot-setup /repro/dist/
RUN bash /repro/dist/boot-setup

USER repro

# install required repro modules
RUN repro.require sdtl-provone exports --demos
RUN repro.require sdth-runtime master ${CIRSS}
RUN repro.require geist 0.2.7 ${CIRSS_RELEASE}
RUN repro.require blazegraph-service master ${CIRSS}
RUN repro.require blaze 0.2.7 ${CIRSS_RELEASE}

CMD  /bin/bash -il

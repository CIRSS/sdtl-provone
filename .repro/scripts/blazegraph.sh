#!/bin/bash

export BLAZEGRAPH_DOT_DIR=${REPRO_MNT}/.blazegraph
export BLAZEGRAPH_PROPERTY_FILE=${BLAZEGRAPH_DOT_DIR}/.properties
export BLAZEGRAPH_OPTIONS="-server -Xmx4g -Dbigdata.propertyFile=${BLAZEGRAPH_PROPERTY_FILE}"
export BLAZEGRAPH_CMD="java ${BLAZEGRAPH_OPTIONS} -jar `cat ~/.blazegraph_jar`"
export BLAZEGRAPH_LOG=${BLAZEGRAPH_DOT_DIR}/blazegraph_`date +%s`.log

cd ${BLAZEGRAPH_DOT_DIR}

${BLAZEGRAPH_CMD} 2>&1 > ${BLAZEGRAPH_LOG} &


#!/bin/bash

# get the directory containing this script
bundle_dir=`dirname $0`

# get the path to the Blazegraph jar file
jar=${bundle_dir}/blazegraph.jar

# work in a directory under the REPRO mount poiint
cd ${REPRO_MNT}/.blazegraph

options="-server -Xmx4g -Dbigdata.propertyFile=.properties"
log=blazegraph_`date +%s`.log

java ${options} -jar ${jar} 2>&1 > ${log} &


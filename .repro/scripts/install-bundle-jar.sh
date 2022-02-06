#!/usr/bin/env bash

# save command line arguments
name=$1
version=$2
url=`eval echo ${BUNDLES_URL_TEMPLATE}`

bundle_dir=${BUNDLES_DIR}/${name}-${version}
bundle_jar=${bundle_dir}/${name}.jar

mkdir -p ${bundle_dir}
wget -O ${bundle_jar} ${url}

echo -n "${bundle_dir}:" >> ~/.bundle_path
echo -n "${bundle_jar}" >> ~/.${name}_jar

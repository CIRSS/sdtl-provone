#!/usr/bin/env bash

# save command line arguments
name=$1
version=$2
url=`eval echo ${BUNDLES_URL_TEMPLATE}`

bundle_dir=${BUNDLES_DIR}/${name}-${version}
binary=${bundle_dir}/${name}

echo '***** Installing ${name} bundle *****'
mkdir -p ${bundle_dir}
wget -O ${binary} ${url}
chmod u+x ${binary}
echo -n "${bundle_dir}:" >> ~/.bundle_path

#!/usr/bin/env bash

# save command line arguments
name=$1
version=$2
url=`eval echo ${REPMOD_URL_TEMPLATE}`

repmod_dir=${BUNDLES_DIR}/${name}-${version}
mkdir -p ${repmod_dir}
cd ${repmod_dir}

wget -O repmod.txt ${url}/repmod.txt

mapfile entries  < repmod.txt

for entry in ${entries[@]}
do
    echo "Downloading $entry"
    wget -O $entry ${url}/${entry}
    chmod u+x ${entry}
done

echo -n "${repmod_dir}:" >> ~/.bundle_path

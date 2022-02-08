#!/usr/bin/env bash

# save command line arguments
name=$1
version=$2
url=`eval echo ${REPMOD_URL_TEMPLATE}`

repmod_dir=${BUNDLES_DIR}/${name}-${version}
mkdir -p ${repmod_dir}
cd ${repmod_dir}

wget --quiet -O repmod.txt ${url}/repmod.txt

readarray entries  < repmod.txt

for entry in "${entries[@]}"
do
    read -ra elements <<< $entry
    if [ ${#elements[@]} -gt 1 ]
    then
        entryname=${elements[0]}
        filename=${elements[1]}
    else
        entryname=${elements[0]}
        filename=${elements[0]}
    fi

    echo "Downloading $filename as $entryname"
    wget -nv -O $entryname ${url}/${filename}
    chmod u+x ${entryname}

done

echo -n "${repmod_dir}:" >> ~/.bundle_path

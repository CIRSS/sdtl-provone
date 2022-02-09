#!/usr/bin/env bash

module_name=$1
module_version=$2
module_url=`eval echo ${MODULES_URL_TEMPLATE}`
module_dir=${MODULES_DIR}/${module_name}-${module_version}

mkdir -p ${module_dir}
cd ${module_dir}

wget --quiet -O module.txt ${module_url}/module.txt

readarray entries  < module.txt

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
    wget -nv -O $entryname ${module_url}/${filename}

    mimetype=`file --mime ${entryname}`
    if echo ${mimetype} | grep -q "application/x-executable"; then
        chmod u+x ${entryname}
    elif echo ${mimetype} | grep -q "text/x-shellscript"; then
        chmod u+x ${entryname}
    fi

done

echo -n "${module_dir}:" >> ~/.bundle_path

# repro@f91ff61920a2:~/bundles/geist-0.2.6$ file --mime geist
# geist: application/x-executable; charset=binary

#!/usr/bin/env bash

module_name=$1
module_version=$2
module_url=`eval echo ${MODULES_URL_TEMPLATE}`
module_dir=${MODULES_DIR}/${module_name}-${module_version}

mkdir -p ${module_dir}
cd ${module_dir}

wget --quiet -O module.txt ${module_url}/module.txt

readarray lines < module.txt

for full_line in "${lines[@]}"
do
    # trim comments starting with a `#` character on the line
    trimmed_line=${full_line%%#*}

    # split the trimmed line using whitespace as token delimiter
    read -ra tokens <<< ${trimmed_line}

    # interpret the line based on the number its tokens
    case ${#tokens[@]} in

    1)  artifact_name=${tokens[0]}
        artifact_path=${artifact_name}
    ;;

    2)  artifact_name=${tokens[0]}
        artifact_path=${tokens[1]}
    ;;

    *) continue
    ;;

    esac

    if [[ ${artifact_path} == http?:* ]] ; then
        artifact_url=${artifact_path}
    else
        artifact_url=${module_url}/${artifact_path}
    fi

    echo "Downloading ${artifact_url} to ${artifact_name}"
    wget -nv -O $artifact_name ${artifact_url}

    mimetype=`file --mime ${artifact_name}`
    if echo ${mimetype} | grep -q "application/x-executable"; then
        chmod u+x ${artifact_name}
    elif echo ${mimetype} | grep -q "text/x-shellscript"; then
        chmod u+x ${artifact_name}
    fi

done

echo -n "${module_dir}:" >> ~/.bundle_path


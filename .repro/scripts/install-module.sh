#!/usr/bin/env bash

module_name=$1
package_version=$2
module_dir=${MODULES_DIR}/${module_name}-${package_version}

mkdir -p ${module_dir}
cd ${module_dir}

if [[ $package_version == local ]] ; then
    cp ${PACKAGE_SNAPSHOT}/module.txt .
else
    package_url=`eval echo ${PACKAGE_URL_TEMPLATE}`
    wget --quiet ${package_url}/module.txt
fi

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
        wget -nv -O ${artifact_name} ${artifact_path}
    elif [[ $package_version == local ]] ; then
        cp ${PACKAGE_SNAPSHOT}/${artifact_path} ${artifact_name}
    else
        wget -nv -O ${artifact_name} ${package_url}/${artifact_path}
    fi

    mimetype=`file --mime ${artifact_name}`
    if echo ${mimetype} | grep -q "application/x-executable"; then
        chmod u+x ${artifact_name}
    elif echo ${mimetype} | grep -q "text/x-shellscript"; then
        chmod u+x ${artifact_name}
    fi

    if [[ ${artifact_name} == configure.sh ]] ; then
        echo "Running  ${artifact_name}"
        source ${artifact_name}
    fi

done

echo -n "${module_dir}:" >> ~/.bundle_path


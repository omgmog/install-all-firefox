#!/bin/bash

main () {
    local remote_dir="https://raw.githubusercontent.com/omgmog/install-all-firefox/master/"
    local temp_dir="/tmp/"
    local output_dir="${temp_dir}firefoxes/"
    local script_name="install-all-firefox.sh"
    local remote_script="${remote_dir}${script_name}"
    local local_script="${temp_dir}${script_name}"
    local script_output="${output_dir}${script_name}"
    local existing_script_md5=""
    local remote_script_md5=""

    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo "This script is designed to be used on OS X only."
        echo "Exiting..."
        exit 1
    fi

    mkdir -p "${output_dir}"

    if [[ -e "${script_output}" ]]; then
        existing_script_md5="$(md5 -q "${script_output}")"
    fi

    if curl -L "${remote_script}" -o "${local_script}"; then
        remote_script_md5="$(md5 -q "${local_script}")"
    fi

    if [[ "${existing_script_md5}" != "${remote_script_md5}" ]]; then
        mv "${local_script}" "${script_output}"
        chmod +x "${script_output}"
    fi

    if [[ "$@" == "" ]]; then
        sh "${script_output}" "status"
    else
        sh "${script_output}" "$@"
    fi
}

main "$@"

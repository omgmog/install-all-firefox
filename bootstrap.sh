#!/bin/bash

readonly PROGNAME=$(basename $0)

main () {
    local remote_dir="https://raw.github.com/omgmog/install-all-firefox/master/"
    local script_name="firefoxes.sh"
    local temp_dir="/tmp/"
    local remote_script="${remote_dir}${script_name}"
    local local_script="${temp_dir}${script_name}"
    local choice_made=0
    local current_dir="${PWD}/"

    echo -e "You should be using ${script_name} not ${PROGNAME}."
    echo -e "I'll download the new script for you now."

    if curl -L "${remote_script}" -o "${local_script}"; then

        echo -e "Successfully downloaded ${script_name} to ${local_script}"

        chmod +x "${local_script}"

        echo -e "Do you want to copy ${local_script} to your current directory?"
        read user_choice
        while [[ "${choice_made}" < 1 ]]; do

            case "$(echo ${user_choice} | tr '[:upper:]' '[:lower:]')" in
                "y" | "yes")
                    choice_made=1
                    echo -e "Copying ${script_name} to ${current_dir}"
                    cp "${local_script}" "${current_dir}${script_name}"
                ;;
                "n" | "no")
                    choice_made=1
                    echo -e "Okay, I'll leave it in ${local_script}"
                ;;
                *)
                    echo -e "Please enter 'y' or 'n'."
                    read user_choice
                ;;
            esac
        done
    fi
}

main

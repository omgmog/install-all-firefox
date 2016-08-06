#!/bin/bash
default_versions_current="48"
default_versions_past="2 3 3.5 3.6 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47"

versions_usage_point_one="3.6 12 16 17 22 23 25"
versions_usage_point_two="21 24 26"
versions_usage_point_three=""
versions_usage_point_four_up="27 28 29"

default_versions="${default_versions_past} ${default_versions_current}"
tmp_directory="/tmp/firefoxes/"
bits_host="https://raw.githubusercontent.com/omgmog/install-all-firefox/master/bits/"
bits_directory="${tmp_directory}bits/"
dmg_host="http://ftp.mozilla.org/pub/mozilla.org/firefox/"

locale_default="en-US"

# Don't edit below this line (unless you're adding new version cases in get_associated_information)

versions="${1:-$default_versions}"
release_directory=""
dmg_file=""
sum_file=""
sum_file_type=""
sum_of_dmg=""
sum_expected=""
binary=""
short_name=""
nice_name=""
vol_name_default="Firefox"
release_name_default="Firefox"
release_type=""
binary_folder="/Contents/MacOS/"
uses_v2_signing=false

specified_locale=$2

if [[ "${3}" == "no_prompt" ]]; then
    no_prompt=true
else
    no_prompt=false
fi

if [[ "${4}" == "" ]]; then
    install_directory="/Applications/Firefoxes/"
else
    install_directory=$4
    install_directory_length=${#install_directory}-1
    if [ "${install_directory:install_directory_length}" != "/" ]; then
        install_directory="${install_directory}/"
    fi
fi

ask(){
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
        echo
        read -p "$1 [$prompt] " REPLY
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

get_associated_information(){
    # Reset everything
    vol_name=$vol_name_default
    release_name=$release_name_default

    case $1 in
        2 | 2.0 | 2.0.0.20)
            release_directory="2.0.0.20"
            dmg_file="Firefox 2.0.0.20.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx2"
            nice_name="Firefox 2.0"

            firebug_version="1.3.1"
            firebug_root="http://getfirebug.com/releases/firebug/1.3/"
            firebug_file="firebug-1.3.1.xpi"
        ;;
        3 | 3.0 | 3.0.19)
            release_directory="3.0.19-real-real"
            dmg_file="Firefox 3.0.19.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx3"
            nice_name="Firefox 3.0"

            firebug_version="1.3.4b2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        3.5 | 3.5.19)
            release_directory="3.5.19"
            dmg_file="Firefox 3.5.19.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx3-5"
            nice_name="Firefox 3.5"

            firebug_version="1.5.4"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        3.6 | 3.6.28)
            release_directory="3.6.28"
            dmg_file="Firefox 3.6.28.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx3-6"
            nice_name="Firefox 3.6"

            firebug_version="1.7.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        4 | 4.0 | 4.0.1)
            release_directory="4.0.1"
            dmg_file="Firefox 4.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx4"
            nice_name="Firefox 4.0"

            firebug_version="1.8.0b7"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        5 | 5.0 | 5.0.1)
            release_directory="5.0.1"
            dmg_file="Firefox 5.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx5"
            nice_name="Firefox 5.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        6 | 6.0 | 6.0.2)
            release_directory="6.0.2"
            dmg_file="Firefox 6.0.2.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx6"
            nice_name="Firefox 6.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        7 | 7.0 | 7.0.1)
            release_directory="7.0.1"
            dmg_file="Firefox 7.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx7"
            nice_name="Firefox 7.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        8 | 8.0 | 8.0.1)
            release_directory="8.0.1"
            dmg_file="Firefox 8.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx8"
            nice_name="Firefox 8.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        9 | 9.0 | 9.0.1)
            release_directory="9.0.1"
            dmg_file="Firefox 9.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx9"
            nice_name="Firefox 9.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        10 | 10.0 | 10.0.2)
            release_directory="10.0.2"
            dmg_file="Firefox 10.0.2.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx10"
            nice_name="Firefox 10.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        11 | 11.0)
            release_directory="11.0"
            dmg_file="Firefox 11.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx11"
            nice_name="Firefox 11.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        12 | 12.0)
            release_directory="12.0"
            dmg_file="Firefox 12.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx12"
            nice_name="Firefox 12.0"

            firebug_version="1.9.2"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        13 | 13.0 | 13.0.1)
            release_directory="13.0.1"
            dmg_file="Firefox 13.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx13"
            nice_name="Firefox 13.0"

            firebug_version="1.10.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        14 | 14.0 | 14.0.1)
            release_directory="14.0.1"
            dmg_file="Firefox 14.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx14"
            nice_name="Firefox 14.0"

            firebug_version="1.10.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        15 | 15.0 | 15.0.1)
            release_directory="15.0.1"
            dmg_file="Firefox 15.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx15"
            nice_name="Firefox 15.0"

            firebug_version="1.10.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        16 | 16.0 | 16.0.1)
            release_directory="16.0.1"
            dmg_file="Firefox 16.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx16"
            nice_name="Firefox 16.0"

            firebug_version="1.10.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        17 | 17.0 | 17.0.1)
            release_directory="17.0.1"
            dmg_file="Firefox 17.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx17"
            nice_name="Firefox 17.0"

            firebug_version="1.11.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        18 | 18.0 | 18.0.2)
            release_directory="18.0.2"
            dmg_file="Firefox 18.0.2.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx18"
            nice_name="Firefox 18.0"

            firebug_version="1.11.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        19 | 19.0 | 19.0.2)
            release_directory="19.0.2"
            dmg_file="Firefox 19.0.2.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx19"
            nice_name="Firefox 19.0"

            firebug_version="1.11.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        20 | 20.0)
            release_directory="20.0"
            dmg_file="Firefox 20.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx20"
            nice_name="Firefox 20.0"

            firebug_version="1.11.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        21 | 21.0)
            release_directory="21.0"
            dmg_file="Firefox 21.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx21"
            nice_name="Firefox 21.0"

            firebug_version="1.11.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        22 | 22.0)
            release_directory="22.0"
            dmg_file="Firefox 22.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx22"
            nice_name="Firefox 22.0"

            firebug_version="1.11.3"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        23 | 23.0 | 23.0.1)
            release_directory="23.0.1"
            dmg_file="Firefox 23.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx23"
            nice_name="Firefox 23.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        24 | 24.0)
            release_directory="24.0"
            dmg_file="Firefox 24.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx24"
            nice_name="Firefox 24.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        25 | 25.0 | 25.0.1)
            release_directory="25.0.1"
            dmg_file="Firefox 25.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx25"
            nice_name="Firefox 25.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        26 | 26.0)
            release_directory="26.0"
            dmg_file="Firefox 26.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx26"
            nice_name="Firefox 26.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        27 | 27.0 | 27.0.1)
            release_directory="27.0.1"
            dmg_file="Firefox 27.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx27"
            nice_name="Firefox 27.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        28 | 28.0)
            release_directory="28.0"
            dmg_file="Firefox 28.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx28"
            nice_name="Firefox 28.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        29 | 29.0 | 29.0.1)
            release_directory="29.0.1"
            dmg_file="Firefox 29.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx29"
            nice_name="Firefox 29.0"

            firebug_version="1.12.0"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        30 | 30.0)
            release_directory="30.0"
            dmg_file="Firefox 30.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx30"
            nice_name="Firefox 30.0"

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        31 | 31.0)
            release_directory="31.0"
            dmg_file="Firefox 31.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx31"
            nice_name="Firefox 31.0"

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        32 | 32.0)
            release_directory="32.0"
            dmg_file="Firefox 32.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx32"
            nice_name="Firefox 32.0"

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        33 | 33.0 | 33.1 | 33.1.1)
            release_directory="33.1.1"
            dmg_file="Firefox 33.1.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx33"
            nice_name="Firefox 33.0"

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        34 | 34.0)
            release_directory="34.0"
            dmg_file="Firefox 34.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx34"
            nice_name="Firefox 34.0"

            uses_v2_signing=true

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        35 | 35.0 | 35.0.1)
            release_directory="35.0.1"
            dmg_file="Firefox 35.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx35"
            nice_name="Firefox 35.0"

            uses_v2_signing=true

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        36 | 36.0)
            release_directory="36.0"
            dmg_file="Firefox 36.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx36"
            nice_name="Firefox 36.0"

            uses_v2_signing=true

            firebug_version="2.0.6"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        37 | 37.0)
            release_directory="37.0"
            dmg_file="Firefox 37.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx37"
            nice_name="Firefox 37.0"

            uses_v2_signing=true

            firebug_version="2.0.8"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        38 | 38.0)
            release_directory="38.0"
            dmg_file="Firefox 38.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx38"
            nice_name="Firefox 38.0"

            uses_v2_signing=true

            firebug_version="2.0.9"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        39 | 39.0)
            release_directory="39.0.3"
            dmg_file="Firefox 39.0.3.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx39"
            nice_name="Firefox 39.0"

            uses_v2_signing=true

            firebug_version="2.0.11"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        40 | 40.0)
            release_directory="40.0.3"
            dmg_file="Firefox 40.0.3.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx40"
            nice_name="Firefox 40.0"

            uses_v2_signing=true

            firebug_version="2.0.12"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        41 | 41.0)
            release_directory="41.0"
            dmg_file="Firefox 41.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx41"
            nice_name="Firefox 41.0"

            uses_v2_signing=true

            firebug_version="2.0.12"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        42 | 42.0)
            release_directory="42.0"
            dmg_file="Firefox 42.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx42"
            nice_name="Firefox 42.0"

            uses_v2_signing=true

            firebug_version="2.0.13"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        43 | 43.0)
            release_directory="43.0"
            dmg_file="Firefox 43.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx43"
            nice_name="Firefox 43.0"

            uses_v2_signing=true

            firebug_version="2.0.13"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        44 | 44.0)
            release_directory="44.0"
            dmg_file="Firefox 44.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx44"
            nice_name="Firefox 44.0"

            uses_v2_signing=true

            firebug_version="2.0.13"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        45 | 45.0)
            release_directory="45.0"
            dmg_file="Firefox 45.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx45"
            nice_name="Firefox 45.0"

            uses_v2_signing=true

            firebug_version="2.0.14"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        46 | 46.0)
            release_directory="46.0"
            dmg_file="Firefox 46.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx46"
            nice_name="Firefox 46.0"

            uses_v2_signing=true

            firebug_version="2.0.16"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        47 | 47.0)
            release_directory="47.0"
            dmg_file="Firefox 47.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx47"
            nice_name="Firefox 47.0"

            uses_v2_signing=true

            firebug_version="2.0.17"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        48 | 48.0)
            release_directory="48.0"
            dmg_file="Firefox 48.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx48"
            nice_name="Firefox 48.0"

            uses_v2_signing=true

            firebug_version="2.0.17"
            firebug_version_short=$(echo "${firebug_version}" | sed 's/\.[0-9a-zA-Z]*$//')
            firebug_root="http://getfirebug.com/releases/firebug/${firebug_version_short}/"
            firebug_file="firebug-${firebug_version}.xpi"
        ;;
        *)
            error "    Invalid version specified!\n\n    Please choose one of:\n    all current $default_versions\n\n"
            error "    To see which versions you have installed, type:\n    ./firefoxes.sh status"
            exit 1
        ;;
  esac
}
setup_dirs(){
    if [[ ! -d "$tmp_directory" ]]; then
        mkdir -p "$tmp_directory"
    fi
    if [[ ! -d "$bits_directory" ]]; then
        mkdir -p "$bits_directory"
    fi
    if [[ ! -d "$install_directory" ]]; then
        mkdir -p "$install_directory"
    fi
}
get_bits(){
    log "Downloading bits"
    current_dir=$(pwd)
    cd "$bits_directory"
    if [[ ! -f "setfileicon" ]]; then
        curl -C - -L --progress-bar "${bits_host}setfileicon" -o "setfileicon"
        chmod +x setfileicon
    fi
    if [[ ! -f "${short_name}.png" ]]; then
        new_icon="true"
        icon_file="${current_dir}/bits/${short_name}.png"
        if [[ -f $icon_file ]]; then
            cp -r $icon_file "${short_name}.png"
        else
            curl -C - -L --progress-bar "${bits_host}${short_name}.png" -o "${short_name}.png"
        fi
    fi
    if [[ ! -f "${short_name}.icns" || $new_icon == "true" ]]; then
        sips -s format icns "${short_name}.png" --out "${short_name}.icns" &> /dev/null
    fi
    if [[ ! -f "${install_directory}{$nice_name}.app/Icon" ]]; then
        if [[ ! -f "fxfirefox-folder.png" ]]; then
            curl -C - -L --progress-bar "${bits_host}fxfirefox-folder.png" -o "fxfirefox-folder.png"
        fi
        if [[ ! -f "fxfirefox-folder.icns" ]]; then
            sips -s format icns "fxfirefox-folder.png" --out "fxfirefox-folder.icns" &> /dev/null
        fi
        ./setfileicon "fxfirefox-folder.icns" "${install_directory}"
    fi
}
check_dmg(){
    if [[ ! -f "${tmp_directory}/${dmg_file}" ]]; then
        log "Downloading ${dmg_file}"
        download_dmg
    else
        get_sum_file
        case $sum_file_type in
            md5)
                sum_of_dmg=$(md5 -q "${tmp_directory}${dmg_file}")
                sum_expected=$(cat "${sum_file}-${short_name}" | grep "${locale}/${dmg_file}" | cut -c 1-32)
            ;;
            sha512)
                sum_of_dmg=$(openssl dgst -sha512 "${tmp_directory}${dmg_file}" | sed "s/^.*\(.\{128\}\)$/\1/")
                sum_expected=$(cat "${sum_file}-${short_name}" | grep "${sum_of_dmg}" | cut -c 1-128)
            ;;
            *)
                error "✖ Invalid sum type specified!"
            ;;
        esac
        if [[ "${sum_expected}" == *"${sum_of_dmg}"* ]]; then
            log "✔ ${sum_file_type} of ${dmg_file} matches"
        else
            error "✖ ${sum_file_type} of ${dmg_file} doesn't match!"
            log "Redownloading.\n"
            download_dmg
        fi
    fi
}
get_sum_file(){
    cd "${tmp_directory}"
    curl -C - -L --progress-bar "${ftp_root}${sum_file_folder}${sum_file}" -o "${sum_file}-${short_name}"
}
download_dmg(){
    cd "${tmp_directory}"
    dmg_file_safe=$(echo "${dmg_file}" | sed 's/ /\%20/g')
    dmg_url="${dmg_host}releases/${release_directory}/mac/$locale/${dmg_file_safe}"
    log "Downloading from ${dmg_url}"
    if ! curl -C - -L --progress-bar "${dmg_url}" -o "${dmg_file}"
    then
        error "✖ Failed to download ${dmg_file}!"
    fi
}
download_firebug(){
    cd "${tmp_directory}"
    if [[ ! -f "${firebug_file}" ]]; then
        log "Downloading Firebug ${firebug_version}"
        if ! curl -C - -L --progress-bar "${firebug_root}${firebug_file}" -o "${firebug_file}"
        then
            error "✖ Failed to download ${firebug_file}"
        else
            log "✔ Downloaded ${firebug_file}"
        fi
    fi
}
prompt_firebug(){
    if [ ${no_prompt} == false ]; then
        if ask "Install Firebug ${firebug_version} for ${nice_name}?" Y; then
            download_firebug
            install_firebug
        fi
    else
        download_firebug
        install_firebug
    fi
}
install_firebug(){
    if [[ -f "${install_directory}${nice_name}.app${binary_folder}${binary}" ]]; then
        is_legacy="false"
        if [ "${short_name}" == "fx2" -o "${short_name}" == "fx3" -o "${short_name}" == "fx3-5" -o "${short_name}" == "fx3-6" ]; then
            is_legacy="true"
        fi
        if [ "${is_legacy}" == "true" ]; then
            ext_dir=$(cd $HOME/Library/Application\ Support/Firefox/Profiles/;cd $(ls -1 | grep ${short_name}); pwd)
        else
            if [ "${uses_v2_signing}" == "true" ];then
                ext_dir="${install_directory}${nice_name}.app/Contents/Resources/"
            else
                ext_dir="${install_directory}${nice_name}.app${binary_folder}"
            fi
        fi
        cd "${ext_dir}"
        if [ "${is_legacy}" != "true" ]; then
            if [[ ! -d "distribution" ]]; then
                mkdir "distribution"
            fi
            cd "distribution"
        fi
        if [[ ! -d "extensions" ]]; then
            mkdir "extensions"
        fi
        cd "extensions"
        ext_dir=$(pwd)
        if [[ "${is_legacy}" == "true" ]]; then
            cp -r "${tmp_directory}${firebug_file}" "${ext_dir}"
        else
            unzip -qqo "${tmp_directory}${firebug_file}" -d "${tmp_directory}${firebug_version}"
            cd "${tmp_directory}${firebug_version}"
            FILE="$(cat install.rdf)"
            for i in $FILE;do
                if echo "$i"|grep "urn:mozilla:install-manifest" &> /dev/null ; then
                    GET="true"
                fi
                if [ "$GET" = "true" ] ; then
                    if echo "$i"|grep "<em:id>" &> /dev/null; then
                        ID=$(echo "$i" | sed 's#.*<em:id>\(.*\)</em:id>.*#\1#')
                        GET="false"
                    elif echo "$i"|grep "em:id=\"" &> /dev/null; then
                        ID=$(echo "$i" | sed 's/.*em:id="\(.*\)".*/\1/')
                        GET="false"
                    fi
                fi
            done
            cd ..
            mv "${firebug_version}" "${ext_dir}/${ID}/"
        fi
        log "✔ Installed Firebug ${firebug_version}"
    else
        error "${nice_name} not installed so we can't install Firebug ${firebug_version}!"
    fi
}
mount_dmg(){
    echo Y | PAGER=true hdiutil attach -plist -nobrowse -readonly -quiet "${dmg_file}" > /dev/null
}
unmount_dmg(){
    if [[ -d "/Volumes/${vol_name}" ]]; then
        hdiutil detach "/Volumes/${vol_name}" -force > /dev/null
    fi
}
install_app(){
    if [[ -d "${install_directory}${nice_name}.app" ]]; then

        if [ ${no_prompt} == false ]; then
            if ask "Delete your existing ${nice_name}.app and reinstall?" Y; then
                log "Reinstalling ${nice_name}.app"
                remove_app
                process_install
            else
                log "Skipping reinstallation of ${nice_name}.app"
            fi
        else
            remove_app
            process_install
        fi
    else
        process_install
    fi
}
remove_app(){
    if rm -rf "${install_directory}${nice_name}.app"
    then
        log "✔ Removed ${install_directory}${nice_name}.app"
    else
        error "✖ Could not remove ${install_directory}${nice_name}.app!"
    fi
}
process_install(){
    cd "/Volumes/${vol_name}"
    if cp -r "${release_name}.app/" "${install_directory}${nice_name}.app/"
    then
        log "✔ Installed ${nice_name}.app"
    else
        unmount_dmg
        error "✖ Could not install ${nice_name}.app!"
    fi
    unmount_dmg
    create_profile
    modify_launcher
    install_complete
}
create_profile(){
    if exec "${install_directory}${nice_name}.app${binary_folder}${binary}" -CreateProfile "${short_name}" &> /dev/null &
    then
        log "✔ Created profile '${short_name}' for ${nice_name}"
    else
        error "✖ Could not create profile '${short_name}' for ${nice_name}"
    fi
}
modify_launcher(){
    plist_old="${install_directory}${nice_name}.app/Contents/Info.plist"
    plist_new="${tmp_directory}Info.plist"
    sed -e "s/${binary}/${binary}-af/g" "${plist_old}" > "${plist_new}"
    mv "${plist_new}" "${plist_old}"

# No indentation while catting
cat > "${install_directory}${nice_name}.app${binary_folder}${binary}-af" <<EOL
#!/bin/sh
"${install_directory}${nice_name}.app${binary_folder}${binary}" -no-remote -P ${short_name} &
EOL

    chmod +x "${install_directory}${nice_name}.app${binary_folder}${binary}-af"

# tell all.js where to find config

if [[ "${uses_v2_signing}" == "true" ]]; then
    config_dir="${install_directory}${nice_name}.app/Contents/Resources/"
else
    config_dir="${install_directory}${nice_name}.app${binary_folder}"
fi
prefs_dir="${config_dir}defaults/pref/"
# fx34 doesn't move the mozilla.cfg yet...
if [[ "${short_name}" == "fx34" ]]; then
    config_dir="${install_directory}${nice_name}.app${binary_folder}"
fi

mkdir -p "${prefs_dir}"
prefs_file="${prefs_dir}all.js"

cat > "${prefs_file}" <<EOL
pref("general.config.obscure_value", 0);
pref("general.config.filename", "mozilla.cfg");
EOL

# make config
config_file="${config_dir}mozilla.cfg"
cat > "${config_file}" <<EOL
lockPref("browser.shell.checkDefaultBrowser", false);
lockPref("browser.startup.homepage_override.mstone", "ignore");
lockPref("app.update.enabled", false);
lockPref("browser.rights.3.shown", false);
lockPref("toolkit.telemetry.prompted", 2);
lockPref("toolkit.telemetry.rejected", true);
EOL

    cd "${bits_directory}"
    ./setfileicon "${short_name}.icns" "${install_directory}/${nice_name}.app/"
}
install_complete(){
    log "✔ Install complete!"
}
error(){
    printf "\033[31m%b\033[00m " $*
    printf "\n"
    return 0
}
log(){
    printf "\033[32m%b\033[00m " $*
    printf "\n"
    return $?
}

# Replace special keywords with actual versions (duplicates are okay; it'll work fine)
versions=${versions/all/${default_versions}}
versions=${versions/current/${default_versions_current}}
versions=${versions/latest/${default_versions_current}}
versions=${versions/newest/${default_versions_current}}
versions=${versions/min_point_one/${versions_usage_point_one} ${versions_usage_point_two} ${versions_usage_point_three} ${versions_usage_point_four_up}}
versions=${versions/min_point_two/${versions_usage_point_two} ${versions_usage_point_three} ${versions_usage_point_four_up}}
versions=${versions/min_point_three/${versions_usage_point_three} ${versions_usage_point_four_up}}
versions=${versions/min_point_four/${versions_usage_point_four_up}}

if [[ $versions == 'status' ]]; then
    printf "The versions in \033[32mgreen\033[00m are installed:\n"
    for VERSION in $default_versions; do
        get_associated_information $VERSION
        if [[ -d "${install_directory}${nice_name}.app" ]]; then
            printf "\n\033[32m - ${nice_name} ($VERSION)\033[00m"
        else
            printf "\n\033[31m - ${nice_name} ($VERSION)\033[00m"
        fi
    done
    printf "\n\nTo install, type \033[1m./firefoxes.sh [version]\033[22m, \nwith [version] being the number or name in parentheses\n\n"
    exit 1
fi

get_locale() {
    all_locales=" af ar be bg ca cs da de el en-GB en-US es-AR es-ES eu fi fr fy-NL ga-IE he hu it ja-JP-mac ko ku lt mk mn nb-NO nl nn-NO pa-IN pl pt-BR pt-PT ro ru sk sl sv-SE tr uk zh-CN zh-TW "

    # ex: "fr-FR.UTF-8" => "fr-FR"
    cleaned_specified_locale=$(echo ${specified_locale/_/-} | sed 's/\..*//')
    cleaned_system_locale=$(echo ${LANG/_/-} | sed 's/\..*//')

    # ex: "fr-FR" => "fr"
    cleaned_system_locale_short=$(echo $cleaned_system_locale | sed 's/-.*//')

    # Will make something more scalable if needed later
    # But for now, we make these locales use en-US
    if [[ $cleaned_system_locale == 'en-AU' || $cleaned_system_locale == 'en-CA' ]]; then
        echo "Your system locale is set to ${cleaned_system_locale}. As there is no ${cleaned_system_locale} localization available for Firefox, en-US has been used instead."
        cleaned_system_locale='en-US'
    fi

    if [[ $all_locales != *" $cleaned_system_locale "* && $all_locales == *" $cleaned_system_locale_short "* ]]; then
        echo "Your system locale \"$cleaned_system_locale\" is not available, but \"$cleaned_system_locale_short\" is!"
        echo "We'll use \"$cleaned_system_locale_short\" as the default locale if you've not specified a valid locale."
        cleaned_system_locale=$cleaned_system_locale_short
    fi

    if [[ -n $specified_locale ]]; then
        if [[ $all_locales != *" $cleaned_specified_locale "* ]]; then
            echo "\"${cleaned_specified_locale}\" was not found in our list of valid locales."
            locale=$cleaned_system_locale
        else
            locale=$cleaned_specified_locale
        fi
    else
        locale=$cleaned_system_locale
    fi

    echo "We're using ${locale} as your locale."

    echo "If this is wrong, use './firefoxes.sh [version] [locale]' to specify the locale."
    echo ""
    echo "The valid locales are:"
    echo " ${all_locales}"
}

clean_up() {
    if ask "Delete all files from temp directory (${tmp_directory})?" Y; then
        log "Deleting temp directory (${tmp_directory})!"
        rm -rf ${tmp_directory}
    else
        log "Keeping temp directory (${tmp_directory}), though it will be deleted upon reboot!\n"
    fi
    return 0
}

if [ "$(uname -s)" != "Darwin" ]; then
    error "This script is designed to be run on OS X\nExiting..."
    exit 0
fi

get_locale

for VERSION in $versions; do
    get_associated_information $VERSION
    log "====================\nInstalling ${nice_name}"
    setup_dirs
    get_bits
    check_dmg
    mount_dmg
    install_app
    unmount_dmg
    prompt_firebug
done

clean_up

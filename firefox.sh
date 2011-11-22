#!/usr/bin/env bash

# Caution is a virtue
set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

log()  { printf "$*\n" ; return $? ;  }

fail() { log "\nERROR: $*\n" ; exit 1 ; }

get_ffx(){
    case $1 in 
        2.0.0.20)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/2.0.0.20/mac/en-GB/Firefox%202.0.0.20.dmg"
            md5=""
            file="Firefox 2.0.0.20.dmg"
            app="Firefox 2.0"
            profile="fx2"
        ;;
        3.0.19)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.0.19-real-real/mac/en-GB/Firefox%203.0.19.dmg"
            md5=""
            file="Firefox 3.0.19.dmg"
            app="Firefox 3.0"
            profile="fx3"
        ;;
        3.6.24)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.6.24/mac/en-GB/Firefox%203.6.24.dmg"
            md5=""
            file="Firefox 3.6.24.dmg"
            app="Firefox 3.6"
            profile="fx36"
        ;;
        4.0.1)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/4.0.1/mac/en-GB/Firefox%204.0.1.dmg"
            md5=""
            file="Firefox 4.0.1.dmg"
            app="Firefox 4.0"
            profile="fx4"
        ;;
        5.0.1)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/5.0.1/mac/en-GB/Firefox%205.0.1.dmg"
            md5=""
            file="Firefox 5.0.1.dmg"
            app="Firefox 5.0"
            profile="fx5"
        ;;
        6.0.1)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/6.0.1/mac/en-GB/Firefox%206.0.1.dmg"
            md5=""
            file="Firefox 6.0.1.dmg"
            app="Firefox 6.0"
            profile="fx6"
        ;;
        7.0.1)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/7.0.1/mac/en-GB/Firefox%207.0.1.dmg"
            md5=""
            file="Firefox 7.0.1.dmg"
            app="Firefox 7.0"
            profile="fx7"
        ;;
        8.0.1)
            url="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/8.0.1/mac/en-GB/Firefox%208.0.1.dmg"
            md5=""
            file="Firefox 8.0.1.dmg"
            app="Firefox 8.0"
            profile="fx8"
        ;;
        *)
            fail "Invalid Firefox version: ${1}"
        ;;
    esac


    #go to tmp dir
    cd /tmp
    mkdir -p "firefoxes"
    cd "firefoxes"

    # check for existing file
    if [[ ! -f "${file}" ]]
        then
        log "Downloading ${file}"
        if ! curl -C -L "${url}" -o "${file}"
            then
            fail "Failed to download ${url} to ${file}!\n"
        fi
    fi

    # mount dmg
    hdiutil attach -plist -nobrowse -readonly -quiet "${file}" > /dev/null
    cd "/Volumes/Firefox"
    mkdir -p "/Applications/Firefoxes"
    # copy app then eject dmg
    if cp -r Firefox.app/ /Applications/Firefoxes/"${app}".app/
        then
        log "Installed ${app}"
        hdiutil detach "/Volumes/Firefox" -force > /dev/null

        # need to add a way to start firefox with profile specified
    fi

}


ffx_versions="2.0.0.20 3.0.19 3.6.24 4.0.1 5.0.1 6.0.1 7.0.1 8.0.1"
for ver in ${ffx_versions}
do
    get_ffx $ver
done

log "Done!"
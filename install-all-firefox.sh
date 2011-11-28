#!/usr/bin/env bash

# Caution is a virtue
set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

# if no locale specified, default to en-GB
LOCALE=${1-en-GB}

log()  { printf "$*\n" ; return $? ;  }

fail() { log "\nERROR: $*\n" ; exit 1 ; }
get_bits(){
    log "Downloading bits"
    mkdir -p "/tmp/firefoxes/bits"
    cd "/tmp/firefoxes/bits"

    log " - setfileicon"
    if [[ ! -f "setfileicon" ]]
        then
        curl -C -L "https://raw.github.com/omgmog/install-all-firefox/master/bits/setfileicon" -o "setfileicon"
        chmod +x setfileicon
    fi

    log " - icons for Firefox"

    for i in 2 3 36 4 5 6 7 8 firefox-folder
    do
        if [[ ! -f "fx$i.png" ]]
            then
            curl -C -L "https://raw.github.com/omgmog/install-all-firefox/master/bits/fx$i.png" -o "fx$i.png"
        fi
        if [[ ! -f "fx$i.icns" ]]
            then
            sips -s format icns "fx$i.png" --out "fx$i.icns"
        fi
    done
    if [[ ! -d "/Applications/Firefoxes" ]]
        then
            mkdir "/Applications/Firefoxes"
    fi
        log "Setting custom icon for /Applications/Firefoxes/"
        /tmp/firefoxes/bits/setfileicon "/tmp/firefoxes/bits/fxfirefox-folder.icns" "/Applications/Firefoxes/"
        
        log "Download finished!"
}
get_ffx(){
    case $1 in 
        2.0.0.20)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/2.0.0.20/"
            file="Firefox 2.0.0.20.dmg"
            app="Firefox 2.0"
            profile="fx2"
            bin="firefox-bin"
        ;;
        3.0.19)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.0.19-real-real/"
            file="Firefox 3.0.19.dmg"
            app="Firefox 3.0"
            profile="fx3"
            bin="firefox-bin"
        ;;
        3.6.24)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.6.24/"
            file="Firefox 3.6.24.dmg"
            app="Firefox 3.6"
            profile="fx36"
            bin="firefox-bin"
        ;;
        4.0.1)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/4.0.1/"
            file="Firefox 4.0.1.dmg"
            app="Firefox 4.0"
            profile="fx4"
            bin="firefox-bin"
        ;;
        5.0.1)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/5.0.1/"
            file="Firefox 5.0.1.dmg"
            app="Firefox 5.0"
            profile="fx5"
            bin="firefox-bin"
        ;;
        6.0.1)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/6.0.1/"
            file="Firefox 6.0.1.dmg"
            app="Firefox 6.0"
            profile="fx6"
            bin="firefox-bin"
        ;;
        7.0.1)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/7.0.1/"
            file="Firefox 7.0.1.dmg"
            app="Firefox 7.0"
            profile="fx7"
            bin="firefox"
        ;;
        8.0.1)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/8.0.1/"
            file="Firefox 8.0.1.dmg"
            app="Firefox 8.0"
            profile="fx8"
            bin="firefox"
        ;;
        *)
            fail "Invalid Firefox version: ${1}"
        ;;
    esac
    # download md5sums for this release
    cd /tmp
    mkdir -p "firefoxes"
    cd "firefoxes"
    # download the md5sums for this version
    log "lets see if we can download the md5sums..."
    curl -L -o "MD5SUMS-${profile}" "${rooturl}MD5SUMS" 

    md5hash=`cat "MD5SUMS-${profile}" | grep "$LOCALE/${file}" | cut -c 1-32`

    #go to tmp dir
    cd /tmp
    mkdir -p "firefoxes"
    cd "firefoxes"

    # check for existing file
    if [[ ! -f "${file}" ]]
        then
        log "Downloading ${file}"
        if ! curl -C -L "${rooturl}mac/$LOCALE/${file}" -o "${file}"
            then
            fail "Failed to download ${rooturl}mac/$LOCALE/${file} to ${file}!\n"
        fi
    else
        themd5=`md5 -q "/tmp/firefoxes/${file}"`
        if [[ $themd5 = "$md5hash" ]]
            then
            log "md5 from MD5SUMS   = $md5hash"
            log "md5 of file        = $themd5"
            log "md5 of ${file} matches!"
        else
            log "Error: md5 mismatch, redownloading"
            if ! curl -C -L "${rooturl}mac/$LOCALE/${file}" -o "${file}"
                then
                fail "Failed to download ${rooturl}mac/$LOCALE/${file} to ${file}!\n"
            fi
        fi
        
    fi

    if [[ ! -d "/Applications/Firefoxes/${app}.app/" ]]
        then
        # mount dmg
        hdiutil attach -plist -nobrowse -readonly -quiet "${file}" > /dev/null
        cd "/Volumes/Firefox"
        mkdir -p "/Applications/Firefoxes"
        if cp -r Firefox.app/ /Applications/Firefoxes/"${app}".app/
            then
            log "Installed ${app} to /Applications/Firefoxes/${app}.app"
            hdiutil detach "/Volumes/Firefox" -force > /dev/null

            exec "/Applications/Firefoxes/${app}.app/Contents/MacOS/firefox-bin" -CreateProfile "${profile}" &> /dev/null &
            log "Created profile '${profile}' for ${app}"

            # edit Info.plist for launching
            plist_o="/Applications/Firefoxes/${app}.app/Contents/Info.plist"
            plist_t="/tmp/firefoxes/plist.tmp"
            sed -e "s/${bin}/${bin}-af/g" "$plist_o" > "$plist_t"
            mv "$plist_t" "$plist_o"

            # disable default browser check
            echo -e "pref(\"browser.shell.checkDefaultBrowser\", false);" > "/Applications/Firefoxes/${app}.app/Contents/MacOS/defaults/pref/macprefs.js"

            echo -e "#!/bin/sh\n\"/Applications/Firefoxes/${app}.app/Contents/MacOS/${bin}\" -no-remote -P \"${profile}\" &" > "/Applications/Firefoxes/${app}.app/Contents/MacOS/${bin}-af" 
            chmod +x "/Applications/Firefoxes/${app}.app/Contents/MacOS/${bin}-af" 

            # edit icon
            cp "/tmp/firefoxes/bits/${profile}.icns" "/Applications/Firefoxes/${app}.app/${profile}.icns"
            /tmp/firefoxes/bits/setfileicon "/Applications/Firefoxes/${app}.app/${profile}.icns" "/Applications/Firefoxes/${app}.app/"
            log "Modified ${app} launcher"
        fi
    else
        log "${app} already installed! Skipping."
    fi
}

ffx_versions="2.0.0.20 3.0.19 3.6.24 4.0.1 5.0.1 6.0.1 7.0.1 8.0.1"

    log "==========================="
    get_bits
for ver in ${ffx_versions}
do
    log "==========================="
    get_ffx $ver
done

log "==========================="
log "Done!"
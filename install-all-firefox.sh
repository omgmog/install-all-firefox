#!/usr/bin/env bash
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
    for i in 2 3 36 4 5 6 7 8 9 10 firefox-folder
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
            log "Setting custom icon for /Applications/Firefoxes/"
            /tmp/firefoxes/bits/setfileicon "/tmp/firefoxes/bits/fxfirefox-folder.icns" "/Applications/Firefoxes/"
    fi
    log "Download finished!"
}
get_aurora(){
    rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-aurora/"
    file=`curl -silent -L ${rooturl} | grep ".mac.dmg" | sed "s/^.\{56\}//"`
    app="Firefox Aurora"
    profile="fxa"
    bin="firefox"
    mkdir -p "/tmp/firefoxes/bits"
    cd "/tmp/firefoxes/bits"
    if [[ ! -f "${profile}.png" ]]
        then
        curl -C -L "https://raw.github.com/omgmog/install-all-firefox/master/bits/${profile}.png" -o "${profile}.png"
    fi
    if [[ ! -f "${profile}.icns" ]]
        then
        sips -s format icns "${profile}.png" --out "${profile}.icns"
    fi
    cd /tmp
    mkdir -p "firefoxes"
    cd "firefoxes"
    if [[ ! -f "${file}" ]]
        then
        log "Downloading ${file}"
        if ! curl -C -L "${rooturl}/${file}" -o "${file}"
            then
            rm -f "${file}"
            fail "Failed to download ${rooturl}/${file} to ${file}!\n"
        else
            log "Downloaded ${file} successfully :D"
        fi
    else
        checksums=`echo ${file} | sed "s/\.dmg/\.checksums/"`
        if [[ ! -f "${checksums}" ]]
            then
            log "sha512 for ${app} not found, downloading..."
            curl -L -O "${rooturl}${checksums}"
        fi
        file_sha512=`openssl dgst -sha512 /tmp/firefoxes/${file} | sed "s/^.*\(.\{128\}\)$/\1/"`
        exp_sha512=`grep "${file}" "${checksums}" | cut -c 1-128`

        if [[ "$file_sha512" = "$exp_sha512" ]]
            then
            log "sha512 from ${checksums}       = $exp_sha512"
            log "sha512 of ${file}               = $file_sha512"
            log "sha512 for ${file} matches!"
        else
            log "sha512 doesn't match.. redownloading!"
            curl -C -L "${rooturl}/${file}" -o "${file}"
        fi
    fi
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
        3.6.26)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.6.26/"
            file="Firefox 3.6.26.dmg"
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
        6.0.2)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/6.0.2/"
            file="Firefox 6.0.2.dmg"
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
        9.0.1)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/9.0.1/"
            file="Firefox 9.0.1.dmg"
            app="Firefox 9.0"
            profile="fx9"
            bin="firefox"
        ;;
        10.0)
            rooturl="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/10.0/"
            file="Firefox 10.0.dmg"
            app="Firefox 10.0"
            profile="fx10"
            bin="firefox"
        ;;
        *)
            if [[ "$1" != "aurora" ]]
                then
                fail "Invalid Firefox version: ${1}"
            fi
        ;;
    esac
    if [[ "$1" = "aurora" ]]
        then
        get_aurora
    else
        cd /tmp
        mkdir -p "firefoxes"
        cd "firefoxes"
        if [[ ! -f "MD5SUMS-${profile}" ]]
            then
            log "md5sums for ${app} not found, downloading..."
            curl -L -o "MD5SUMS-${profile}" "${rooturl}MD5SUMS" 
        fi
        md5hash=`cat "MD5SUMS-${profile}" | grep "$LOCALE/${file}" | cut -c 1-32`
        cd /tmp
        mkdir -p "firefoxes"
        cd "firefoxes"
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
    fi
    if [[ ! -d "/Applications/Firefoxes/${app}.app/" ]]
        then
        hdiutil attach -plist -nobrowse -readonly -quiet "${file}" > /dev/null
        if [[ "$1" = "aurora" ]]
            then
            dmg="Aurora"
            release="FirefoxAurora"
        else
            dmg="Firefox"
            release="Firefox"
        fi
        cd "/Volumes/${dmg}"
        mkdir -p "/Applications/Firefoxes"
        if cp -r "${release}.app/" /Applications/Firefoxes/"${app}".app/
            then
            log "Installed ${app} to /Applications/Firefoxes/${app}.app"
            hdiutil detach "/Volumes/${dmg}" -force > /dev/null
            exec "/Applications/Firefoxes/${app}.app/Contents/MacOS/firefox-bin" -CreateProfile "${profile}" &> /dev/null &
            log "Created profile '${profile}' for ${app}"
            plist_o="/Applications/Firefoxes/${app}.app/Contents/Info.plist"
            plist_t="/tmp/firefoxes/plist.tmp"
            sed -e "s/${bin}/${bin}-af/g" "$plist_o" > "$plist_t"
            mv "$plist_t" "$plist_o"
            echo -e "pref(\"browser.shell.checkDefaultBrowser\", false);" > "/Applications/Firefoxes/${app}.app/Contents/MacOS/defaults/pref/macprefs.js"
            echo -e "#!/bin/sh\n\"/Applications/Firefoxes/${app}.app/Contents/MacOS/${bin}\" -no-remote -P \"${profile}\" &" > "/Applications/Firefoxes/${app}.app/Contents/MacOS/${bin}-af" 
            chmod +x "/Applications/Firefoxes/${app}.app/Contents/MacOS/${bin}-af"
            cp "/tmp/firefoxes/bits/${profile}.icns" "/Applications/Firefoxes/${app}.app/${profile}.icns"
            /tmp/firefoxes/bits/setfileicon "/Applications/Firefoxes/${app}.app/${profile}.icns" "/Applications/Firefoxes/${app}.app/"
            log "Modified ${app} launcher"
        fi
    else
        log "${app} already installed! Skipping."
    fi
}
ffx_versions="2.0.0.20 3.0.19 3.6.26 4.0.1 5.0.1 6.0.2 7.0.1 8.0.1 9.0.1 10.0 aurora"
    log "==========================="
    get_bits
for ver in ${ffx_versions}
do
    log "==========================="
    get_ffx $ver
done
log "==========================="
log "Done!"
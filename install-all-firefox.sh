#!/bin/bash
default_versions="2.0.0.20 3.0.19 3.6.26 4.0.1 5.0.1 6.0.2 7.0.1 8.0.1 9.0.1 10.0 aurora nightly ux"
tmp_directory="/tmp/firefoxes/"
bits_directory="${tmp_directory}bits/"
install_directory="/Applications/Firefoxes/"

# Don't edit below this line (unless you're adding new version cases in get_associated_information)

locale=${2:-"en-GB"}
versions="${1:-$default_versions}"
ftp_root=""
dmg_file=""
sum_file=""
sum_file_type=""
sum_of_dmg=""
sum_expected=""
binary=""
short_name=""
nice_name=""
vol_name="Firefox"
release_name="Firefox"
release_type=""
binary_folder="/Contents/MacOS/"
get_associated_information(){
    case $1 in
        2.0.0.20)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/2.0.0.20/"
            dmg_file="Firefox 2.0.0.20.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx2"
            nice_name="Firefox 2.0"
        ;;
        3.0.19)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.0.19-real-real/"
            dmg_file="Firefox 3.0.19.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx3"
            nice_name="Firefox 3.0"
        ;;
        3.6.26)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/3.6.26/"
            dmg_file="Firefox 3.6.26.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx36"
            nice_name="Firefox 3.6"
        ;;
        4.0.1)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/4.0.1/"
            dmg_file="Firefox 4.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx4"
            nice_name="Firefox 4.0"
        ;;
        5.0.1)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/5.0.1/"
            dmg_file="Firefox 5.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx5"
            nice_name="Firefox 5.0"
        ;;
        6.0.2)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/6.0.2/"
            dmg_file="Firefox 6.0.2.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox-bin"
            short_name="fx6"
            nice_name="Firefox 6.0"
        ;;
        7.0.1)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/7.0.1/"
            dmg_file="Firefox 7.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx7"
            nice_name="Firefox 7.0"
        ;;
        8.0.1)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/8.0.1/"
            dmg_file="Firefox 8.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx8"
            nice_name="Firefox 8.0"
        ;;
        9.0.1)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/9.0.1/"
            dmg_file="Firefox 9.0.1.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx9"
            nice_name="Firefox 9.0"
        ;;
        10.0)
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/10.0/"
            dmg_file="Firefox 10.0.dmg"
            sum_file="MD5SUMS"
            sum_file_type="md5"
            binary="firefox"
            short_name="fx10"
            nice_name="Firefox 10.0"
        ;;
        aurora)
            release_type="aurora"
            future="true"
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-aurora/"
            dmg_file=`curl -silent -L ${ftp_root} | grep ".mac.dmg" | sed "s/^.\{56\}//"`
            sum_file=`echo ${dmg_file} | sed "s/\.dmg/\.checksums/"`
            sum_file_type="sha512"
            binary="firefox"
            short_name="fxa"
            nice_name="Firefox Aurora"
            vol_name="Aurora"
            release_name="FirefoxAurora"
        ;;
        nightly)
            release_type="nightly"
            future="true"
            ftp_root="ftp://ftp.mozilla.org//pub/mozilla.org/firefox/nightly/latest-trunk/"
            dmg_file=`curl -silent -L ${ftp_root} | grep ".mac.dmg" | sed "s/^.\{56\}//"`
            sum_file=`echo ${dmg_file} | sed "s/\.dmg/\.checksums/"`
            sum_file_type="sha512"
            binary="firefox"
            short_name="fxn"
            nice_name="Firefox Nightly"
            vol_name="Nightly"
            release_name="FirefoxNightly"
        ;;
        ux)
            release_type="ux"
            future="true"
            ftp_root="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-ux/"
            dmg_file=`curl -silent -L ${ftp_root} | grep ".mac.dmg" | sed "s/^.\{56\}//"`
            sum_file=`echo ${dmg_file} | sed "s/\.dmg/\.checksums/"`
            sum_file_type="sha512"
            binary="firefox"
            short_name="fxux"
            nice_name="Firefox UX Nightly"
            vol_name="UX"
            release_name="FirefoxUX"
        ;;
        *)
            error "  Invalid version specified!\n\n  Please choose one of:\n  $default_versions\n\n"
            exit 1
        ;;
    esac
    log "====================\nInstalling ${nice_name}"
}
setup_dirs(){
    if [[ ! -d "$tmp_directory" ]]
        then
        mkdir -p "$tmp_directory"
    fi
    if [[ ! -d "$bits_directory" ]]
        then
        mkdir -p "$bits_directory"
    fi
    if [[ ! -d "$install_directory" ]]
        then
        mkdir -p "$install_directory"
    fi
}
get_bits(){
    log "Downloading bits"
    cd "$bits_directory"
    if [[ ! -f "setfileicon" ]]
        then
        curl -C -L "https://raw.github.com/omgmog/install-all-firefox/master/bits/setfileicon" -o "setfileicon"
        chmod +x setfileicon
    fi
    if [[ ! -f "${short_name}.png" ]]
        then
        curl -C -L "https://raw.github.com/omgmog/install-all-firefox/master/bits/${short_name}.png" -o "${short_name}.png"
    fi
    if [[ ! -f "${short_name}.icns" ]]
        then
        sips -s format icns "${short_name}.png" --out "${short_name}.icns"
    fi
    if [[ ! -f "${install_directory}{$nice_name}.app/Icon" ]]
        then
        if [[ ! -f "fxfirefox-folder.png" ]]
            then
            curl -C -L "https://raw.github.com/omgmog/install-all-firefox/master/bits/fxfirefox-folder.png" -o "fxfirefox-folder.png"
        fi
        if [[ ! -f "fxfirefox-folder.icns" ]]
            then
            sips -s format icns "fxfirefox-folder.png" --out "fxfirefox-folder.icns"
        fi
        ./setfileicon "fxfirefox-folder.icns" "${install_directory}"
    fi
}
check_dmg(){
    if [[ ! -f "${tmp_directory}/${dmg_file}" ]]
        then
        log "Downloading ${dmg_file}"
        download_dmg
    else
        get_sum_file
        case $sum_file_type in
            md5)
                sum_of_dmg=`md5 -q "${tmp_directory}${dmg_file}"`
                sum_expected=`cat "${sum_file}-${short_name}" | grep "${locale}/${dmg_file}" | cut -c 1-32`
            ;;
            sha512)
                sum_of_dmg=`openssl dgst -sha512 "${tmp_directory}${dmg_file}" | sed "s/^.*\(.\{128\}\)$/\1/"`
                sum_expected=`cat "${sum_file}-${short_name}" | grep "${sum_of_dmg}" | cut -c 1-128`
            ;;
            *)
                error "✖ Invalid sum type specified!"
            ;;
        esac
        if [[ "${sum_of_dmg}" == "${sum_expected}" ]]
            then
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
    curl -C -L "${ftp_root}${sum_file}" -o "${sum_file}-${short_name}"
}
download_dmg(){
    cd "${tmp_directory}"
    if [[ "${future}" == "true" ]]
        then
        dmg_url="${ftp_root}${dmg_file}"
    else
        dmg_url="${ftp_root}mac/$locale/${dmg_file}"
    fi
    if ! curl -C -L "${dmg_url}" -o "${dmg_file}"
        then
        error "✖ Failed to download ${dmg_file}!"
    fi
}
mount_dmg(){
    hdiutil attach -plist -nobrowse -readonly -quiet "${dmg_file}" > /dev/null
    if [[ "${future}" == "true" ]]
        then
        vol_name="${vol_name}"
        release_name="${release_name}"
    fi
}
install_app(){
    if [[ -d "${install_directory}${nice_name}.app" ]]
        then
        log "Delete your existing ${nice_name}.app and install again? [y/n]"
        read user_choice
        choice_made="false"
        while [[ "$choice_made" == "false" ]]
        do
            case "$user_choice" in
                "y")
                    choice_made="true"
                    log "Reinstalling ${nice_name}.app"
                    remove_app
                    process_install
                ;;
                "n")
                    choice_made="true"
                    log "Skipping installation of ${nice_name}.app"
                ;;
                *)
                    error "Please enter 'y' or 'n'"
                    read user_choice
                ;;
            esac
        done
        return 0
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
        return 0
    fi
}
process_install(){
    cd "/Volumes/${vol_name}"
    if cp -r "${release_name}.app/" "${install_directory}${nice_name}.app/"
        then
        log "✔ Installed ${nice_name}.app"
    else
        error "✖ Could not install ${nice_name}.app!"
        return 0
    fi
    hdiutil detach "/Volumes/${vol_name}" -force > /dev/null
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
        return 0
    fi
}
modify_launcher(){
    plist_old="${install_directory}${nice_name}.app/Contents/Info.plist"
    plist_new="${tmp_directory}Info.plist"
    sed -e "s/${binary}/${binary}-af/g" "${plist_old}" > "${plist_new}"
    mv "${plist_new}" "${plist_old}"

    echo -e "#!/bin/sh\n\"${install_directory}${nice_name}.app${binary_folder}${binary}\" -no-remote -P \"${short_name}\" &" > "${install_directory}${nice_name}.app${binary_folder}${binary}-af"
    chmod +x "${install_directory}${nice_name}.app${binary_folder}${binary}-af"

    echo -e "pref(\"browser.shell.checkDefaultBrowser\", false);\n pref(\"app.update.auto\",false);\n pref(\"app.update.enabled\",false);\n pref(\"browser.startup.homepage\",\"about:blank\");\n pref(\"browser.shell.checkDefaultBrowser\", false)" > "${install_directory}${nice_name}.app${binary_folder}defaults/pref/macprefs.js"

    cd "${bits_directory}"
    ./setfileicon "${short_name}.icns" "${install_directory}/${nice_name}.app/"
}
install_complete(){
    log "✔ Install complete!\n"
}
error(){
    printf "\n\033[31m$*\033[00m"
    return 0
}
log(){
    printf "\n\033[32m$*\033[00m\n"
    return $?
}
for VERSION in $versions
do
    get_associated_information $VERSION
    setup_dirs
    get_bits
    check_dmg
    mount_dmg
    install_app
done

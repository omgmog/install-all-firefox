![](https://github.com/omgmog/install-all-firefox/raw/master/bits/fxfirefox-folder.png)

## ABOUT

This is a bash script to install all major versions of Firefox on OS X

Currently it installs:

- Firefox 2.0.0.20
- Firefox 3.0.19
- Firefox 3.6.26
- Firefox 4.0.1
- Firefox 5.0.1
- Firefox 6.0.1
- Firefox 7.0.1
- Firefox 8.0.1
- Firefox 9.0.1
- Firefox 10.0
- Firefox Aurora (nightly)

The script downloads the .dmg files from mozilla's FTP into /tmp/firefoxes.

The script installs these to /Applications/Firefoxes/

## INSTALLATION

1. From a terminal prompt enter the following

    > curl -L -O https://github.com/omgmog/install-all-firefox/raw/master/install-all-firefox.sh
    
    > chmod +x install-all-firefox.sh
    
    > ./install-all-firefox.sh [version] [locale]

[version] and [locale] are optional.

By default the installer uses the en-GB locale, but you can specify any of the following:

    af, ar, be , bg, ca, cs, da, de, el, en-GB, en-US, es-AR, es-ES, eu, fi, fr, fy-NL, 
    ga-IE, he, hu, it, ja-JP-mac, ko, ku, lt, mk, mn, nb-NO, nl, nn-NO, pa-IN, pl, pt-BR, 
    pt-PT, ro, ru, sk, sl, sv-SE, tr, uk, zh-CN, zh-TW

The installation process for the Aurora nightly doesn't take any locale, but it installs en-US.

2. The script will download the 'bits' (icons, utils) for the rest of the installer.

3. When the Mozilla license pops up, press Q and then Y to continue.

4. It'll take a little while to grab the .dmg files, but it should only need to do this once. (until you reboot and the contents of /tmp are deleted)


## NEW FEATURES
- Detects previously installed (by install-all-firefox) Firefoxes and prompts to reinstall
- you can now correctly specify the version to install
for single:
> ./install-all-firefox.sh 2.0.0.20
for multiple:
> ./install-all-firefox.sh "2.0.0.20 3.0.19"
- installer now provides more visual feedback of progress
- installs each version after getting dmg, so you don't need to wait for all versions to install
- streamlined the install-all-firefox.sh file!
- You can now customise the installation path and temp folder (by editing install-all-firefox.sh)


## Update: 15/02/2012
- Complete rewrite from scratch! (see NEW FEATURES above)


## TODO
- Add ability to specify additional versions
- Add check for local 'bits' folder (if whole branch mirrored locally)
- Create launcher to preview a site in all install firefoxes (WIP!)

## CREDITS
- Portions of the bash script are based on ievms by xdissent - https://github.com/xdissent/ievms
- setfileicon is a utility created by Damien Bobillot (damien.bobillot.2002_setfileicon@m4x.org) http://maxao.free.fr/telechargements/setfileicon.gz

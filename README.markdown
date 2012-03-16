![](http://f.cl.ly/items/0y0e2R2X1r1F2e0d3o3W/by%20default%202012-03-14%20at%2012.35.55.png)
![](http://f.cl.ly/items/2a2e0z3A2s1d0H3u2x3N/by%20default%202012-03-14%20at%2012.36.10.png)

## ABOUT

This is a bash script to install all major versions of Firefox on OS X

Currently it installs:

- Firefox 2.0.0.20
- Firefox 3.0.19
- Firefox 3.5.9
- Firefox 3.6.28
- Firefox 4.0.1
- Firefox 5.0.1
- Firefox 6.0.1
- Firefox 7.0.1
- Firefox 8.0.1
- Firefox 9.0.1
- Firefox 10.0.2
- Firefox 11.0
- Firefox Beta
- Firefox Aurora
- Firefox Nightly
- Firefox UX Nightly

The script downloads the `.dmg` files from Mozilla's FTP server into `/tmp/firefoxes`.

The script installs these to `/Applications/Firefoxes/`.

To see which versions you have installed already, enter the following:

```bash
./bootstrap.sh status
```

## INSTALLATION

From a terminal prompt, enter the following:

```bash
curl -L -O https://github.com/omgmog/install-all-firefox/raw/master/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh [version] [locale] [prompt]
```

`[version]` and `[locale]` are optional. If you would like confirmation before over-writing previously installed versions of Firefox, specify `prompt` as the third command line argument.

Available `[version]` keywords:

```bash
./bootstrap.sh "all"
./bootstrap.sh "all_future"
./bootstrap.sh "all_past"
./bootstrap.sh "current"
./bootstrap.sh "a.b x.y"

./bootstrap.sh "all" "x-Y"
./bootstrap.sh "all_future" "x-Y"
./bootstrap.sh "all_past" "x-Y"
./bootstrap.sh "current" "x-Y"
./bootstrap.sh "a.b x.y" "x-Y"

./bootstrap.sh "a.b" "x-Y" prompt
```

(where `a.b` and `x.y` are versions, e.g. `2.0.20`, `3.5.9`, and `x-Y` is a locale, e.g. `en-GB` as defined below)

By default, the installer attempts to figure out your `[locale]`. If it can't, it uses the `en-GB` locale. You may also specify any of the following:

```
af, ar, be , bg, ca, cs, da, de, el, en-GB, en-US, es-AR, es-ES, eu, fi, fr, fy-NL,
ga-IE, he, hu, it, ja-JP-mac, ko, ku, lt, mk, mn, nb-NO, nl, nn-NO, pa-IN, pl, pt-BR,
pt-PT, ro, ru, sk, sl, sv-SE, tr, uk, zh-CN, zh-TW
```

The installation process for Aurora and the Nightlies don't take a locale; rather they install `en-US`.

The script will download the 'bits' (icons, utils) for the rest of the installer.

When the Mozilla license pops up, press `Q` and then `Y` to continue.

It'll take a little while to grab the `.dmg` files, but it should only need to do this once. (Until you reboot, and the contents of `/tmp` are deleted.)

To see what you have installed, enter the following:

```bash
./bootstrap.sh status
```

## NEW FEATURES
- Detects previously installed (by this script) Firefoxes and prompts to reinstall
- you can now correctly specify the version to install

    for single:

    ```bash
    ./bootstrap.sh "2.0.0.20"
    ```

    for multiple:

    ```bash
    ./bootstrap.sh "2.0.0.20 3.0.19"
    ```

- installer now provides more visual feedback of progress
- installs each version after getting dmg, so you don't need to wait for all versions to install
- streamlined the `install-all-firefox.sh` file
- You can now customise the installation path and temp folder (by editing `install-all-firefox.sh`)


## Update: 15/02/2012
- Complete rewrite from scratch! (see NEW FEATURES above)

## Update: 24/02/2012
- Added support for Beta / Aurora / Nightly / Nightly UX
- Added groups (`all`, `all_past`, `all_future`)
- Added `current` alias for the current version
- Add check for local 'bits' folder (if whole branch mirrored locally)
- You can run `./bootstrap.sh status` to see what you have installed

## Update: 12/03/2012
- Added support for Firefox 3.5.9
- Updated icons for Aurora / Nightly / Nightly UX to be more consistent
- Added system check to ensure being installed on OS X (Darwin)
- Added prompt to clean-up (delete) temp directory
- Improved message layout a bit
- Updated Firefox 3.6.28, 10.0.2

## Update: 13/03/2012
- Added Firefox 11

## Update: 14/03/2012
- Added `bootstrap.sh` to check for script updates before running script

## Update: 16/03/2012
- Added the installation of Firebug for each version of Firefox.
- Added more checks to ensure that the .dmg's unmount cleanly
- Added `prompt` argument, by default the installer won't prompt

## TODO
- Add ability to specify additional versions
- Create launcher to preview a site in all install firefoxes (WIP!)

## CREDITS
- Portions of the bash script are based on ievms by xdissent - https://github.com/xdissent/ievms
- [setfileicon](http://maxao.free.fr/telechargements/setfileicon.m) is a utility created by Damien Bobillot (damien.bobillot.2002_setfileicon@m4x.org) http://maxao.free.fr/telechargements/setfileicon.gz
- [Firebug](http://getfirebug.com/)
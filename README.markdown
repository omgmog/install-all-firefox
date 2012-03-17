![](http://f.cl.ly/items/0y0e2R2X1r1F2e0d3o3W/by%20default%202012-03-14%20at%2012.35.55.png)
![](http://f.cl.ly/items/2a2e0z3A2s1d0H3u2x3N/by%20default%202012-03-14%20at%2012.36.10.png)

---
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

Optionally, the script can install Firebug for each version of Firefox too.

### What does it do?

1. The `bootstrap.sh` script downloads the latest version of `install-all-firefox.sh` before running to ensure that the script is up to date.

2. The script downloads all of the associated resources (icons) and utilities (seticon) to the `/tmp/firefoxes` directory.

3. The script downloads the `.dmg` files from Mozilla's FTP server into `/tmp/firefoxes`.

4. The script installs the Firefoxes to `/Applications/Firefoxes/`.

5. The script creates a Firefox profile for each installed version of Firefox.

6. The script modifies each Firefox app to launch with its specific profile, and customises the application icon.

7. The script can optionally download the latest Firebug available for each version of Firefox, and install it upon first launch.

### What else does it do?

You can see which versions of Firefox you've already installed using this script, using the following command:

```bash
$ ./bootstrap.sh
```
or
```bash
$ ./bootstrap.sh status
```

You can specify the `version` to install, or use any of the pre-defined installation groups:

```bash
// Default, installs all versions available
$ ./bootstrap.sh

// You can also use the 'all' keyword to install all versions available
$ ./bootstrap.sh "all"

// 'all_future' installs Aurora, Beta, Nightly, Nightly UX
$ ./bootstrap.sh "all_future"

// 'all_past' installs all versions excluding Aurora, Beta, Nightly and Nightly UX
$ ./bootstrap.sh "all_past"

// 'current' installs the current version of Firefox only
$ ./bootstrap.sh "current"

// Specify the versions you would like to install, from the list at the top of this README, separated by spaces
$ ./bootstrap.sh "2.0.0.20 3.0.19"
```

You can specify the `locale` to use, from the list of available `locale` options. By default `en-GB` is used.
```
af, ar, be , bg, ca, cs, da, de, el, en-GB, en-US, es-AR, es-ES, eu, fi, fr, fy-NL,
ga-IE, he, hu, it, ja-JP-mac, ko, ku, lt, mk, mn, nb-NO, nl, nn-NO, pa-IN, pl, pt-BR,
pt-PT, ro, ru, sk, sl, sv-SE, tr, uk, zh-CN, zh-TW
```
```bash
$ ./bootstrap.sh "all" "en-US"
```
(The installation process for the Aurora and Nightly/UX versions will install as `en-US` regardless of what you specify)


If you want to just install all versions and leave the installation process unattended, there is a `no_prompt` option, this will default all of the `y/n` prompts to answering `y`.
```bash
$ ./bootstrap.sh "all" "en-GB" "no_prompt"
```
(You will still need to manually accept the EULA if installing Firefox 2.0.0.20)

---
## INSTALLATION

From a terminal prompt, enter the following:

```bash
curl -L -O https://github.com/omgmog/install-all-firefox/raw/master/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh [version] [locale] [no_prompt]
```

When the Mozilla license pops up, press `Q` and then `Y` to continue.

It'll take a little while to grab the `.dmg` files, but it should only need to do this once. (Until you reboot, and the contents of `/tmp` are deleted.)

---
## UPDATES 
Previous updates removed from the README. Look at the file history to see them.

### Update: 13/03/2012
- Added Firefox 11

### Update: 14/03/2012
- Added `bootstrap.sh` to check for script updates before running script

### Update: 16/03/2012
- Added the installation of Firebug for each version of Firefox.
- Added more checks to ensure that the .dmg's unmount cleanly
- Added `prompt` argument, by default the installer won't prompt

### Update: 17/03/2012
- Changed 'prompt' argument to 'no_prompt', so now by default it will prompt.
- Rewrote the README
- Updated `bootstrap.sh` so that it launches the installer with `status` argument if no arguments provided.


---
## TODO
- Add ability to specify additional versions
- Create launcher to preview a site in all install firefoxes (WIP!)

## CREDITS
- Portions of the bash script are based on ievms by xdissent - https://github.com/xdissent/ievms
- [setfileicon](http://maxao.free.fr/telechargements/setfileicon.m) is a utility created by Damien Bobillot (damien.bobillot.2002_setfileicon@m4x.org) http://maxao.free.fr/telechargements/setfileicon.gz
- [Firebug](http://getfirebug.com/)
- Thanks to the community for using/reporting issues/making suggestions for features!
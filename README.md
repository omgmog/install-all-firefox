# This script is no longer supported

---
## ABOUT

This is a bash script to install all major versions of Firefox on OS X.

Currently it installs:

- Firefox 2.0.0.20
- Firefox 3.0.19
- Firefox 3.5.19
- Firefox 3.6.28
- All version from 4.0.1 to latest version on rolling release

Optionally, the script can install Firebug for each version of Firefox too.

### What does it do?

1. The `firefoxes.sh` script downloads the latest version of `install-all-firefox.sh` beforerunning to ensure that the script is up to date.

2. The script downloads all of the associated resources (icons) and utilities (seticon) to the `/tmp/firefoxes` directory.

3. The script downloads the `.dmg` files from Mozilla's server into `/tmp/firefoxes`.

4. The script installs the Firefoxes to `/Applications/Firefoxes/`.

5. The script creates a Firefox profile for each installed version of Firefox.

6. The script modifies each Firefox app to launch with its specific profile, and customises the application icon.

7. The script can optionally download the latest Firebug available for each version of Firefox, and install it upon first launch.

### What else does it do?

You can see which versions of Firefox you've already installed using this script, using the following command:

```bash
$ ./firefoxes.sh
```

or

```bash
$ ./firefoxes.sh status
```

You can specify the `version` to install, or use any of the pre-defined installation groups:

```bash
# Default, installs all versions available
$ ./firefoxes.sh

# You can also use the 'all' keyword to install all versions available
$ ./firefoxes.sh "all"

# 'current' installs the current version of Firefox only (other allowed keywords: 'newest', 'latest')
$ ./firefoxes.sh "current"
$ ./firefoxes.sh "newest"
$ ./firefoxes.sh "latest"

# 'min_point_one', 'min_point_two', 'min_point_three', 'min_point_four'
# install versions with at least 0.1%, 0.2%, 0.3% or 0.4% global usage share, respectively
$ ./firefoxes.sh "min_point_one"
$ ./firefoxes.sh "min_point_two"

# Specify the versions you would like to install, from the list at the top of this README, separated by spaces
# New: You can now use shorthand for versions, such as: 2, 3, 3.5, 10, 24, etc.
$ ./firefoxes.sh "2 3"
```

Usage share options are based on data from [StatCounter's global statistics](http://gs.statcounter.com) for April 2014.

You can specify the `locale` to use, from the list of available `locale` options. By default `en-GB` is used.

```
af, ar, be , bg, ca, cs, da, de, el, en-GB, en-US, es-AR, es-ES, eu, fi, fr,
fy-NL, ga-IE, he, hu, it, ja-JP-mac, ko, ku, lt, mk, mn, nb-NO, nl, nn-NO,
pa-IN, pl, pt-BR, pt-PT, ro, ru, sk, sl, sv-SE, tr, uk, zh-CN, zh-TW
```

```bash
$ ./firefoxes.sh "all" "en-US"
```

If you want to just install all versions and leave the installation process unattended, there is a `no_prompt` option, this will default all of the `Y/n` prompts to answering `y`.

```bash
$ ./firefoxes.sh "all" "en-GB" "no_prompt"
```
(You will still need to manually accept the EULA if installing Firefox 2.0.0.20)

If you want to install to a different directory, pass that as the last option. Include a trailing slash.

```bash
$ ./firefoxes.sh "all" "en-GB" "no_prompt" "/Users/myhomedir/Applications/"
```

---
## INSTALLATION

From a terminal prompt, enter the following:

```bash
curl -L -O https://github.com/omgmog/install-all-firefox/raw/master/firefoxes.sh
chmod +x firefoxes.sh
./firefoxes.sh [version] [locale] [no_prompt] [install_directory]
```

It'll take a little while to grab the `.dmg` files, but it should only need to do this once.
(Until you reboot, and the contents of `/tmp` are deleted.)


---
## CONTRIBUTING
If a new version of Firefox has been released but it's not yet here, feel free to add it and submit a pull request. You can even generate a new application icon using the `create_firefox_image_with_version` tool found in the [`bits`](https://github.com/omgmog/install-all-firefox/tree/master/bits) directory.

### Checklist when adding a new version
You should only need to make changes in `install-all-firefox.sh` when adding a new version, and also generating a new `fx[version].png` in the `bits` directory.

1. Update `default_versions_current`
2. Update `default_versions_past`
3. Add a new version to the massive case statement in `get_associated_information()`
4. Ensure that we're using the correct/latest version of Firebug. The [Firebug blog](http://getfirebug.com/) is pretty good at mentioning which versions of Firefox are supported with each release.
5. Generate a new version icon:

```bash
cd bits
./create_firefox_image_with_version "36.0" fx36.png
```

`create_firefox_image_with_version` uses ImageMagick's `convert` utility to composite the two base images together with text, so make sure you've got that installed first:

```bash
$ brew install imagemagick gs
```

---
## CREDITS
- [setfileicon](http://maxao.free.fr/telechargements/setfileicon.m) is a utility created by Damien Bobillot (damien.bobillot.2002_setfileicon@m4x.org) http://maxao.free.fr/telechargements/setfileicon.gz
- [Firebug](http://getfirebug.com/)
- Thanks to the community for using/reporting issues/making suggestions for features!
- Thanks to Lurst for his [`create_firefox_image_with_version`](https://github.com/LuRsT/create_firefox_image_with_version) tool.

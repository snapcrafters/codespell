# codespell snap

A [snap](https://snapcraft.io/about) package for [codespell](https://github.com/codespell-project/codespell).

## Installing

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/lengau-codespell)

    sudo snap install lengau-codespell
    sudo snap alias lengau-codespell.codespell codespell


## Build

This snap requires the preview version of Snapcraft 8. You can install it with:

    sudo snap install --classic --edge snapcraft

or if you already have snapcraft, you can switch to the edge channel with:

    sudo snap refresh --edge snapcraft

Once you've cloned this repository and installed the correct version of snapcraft, you can build it with:

    snapcraft pack

The snap package is automatically on the [launchpad project](https://launchpad.net/codespell-snap).
View the [snap packages here](https://launchpad.net/codespell-snap/+snaps).

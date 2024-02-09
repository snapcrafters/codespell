#!/bin/bash
# Tests for the codespell snap.

repositories(){
    echo https://github.com/BaPSF/bapsflib
    echo https://github.com/J-Yaghoubi/menutools
    echo https://github.com/Kitware/CMake
    echo https://github.com/PlasmaPy/PlasmaPy
    echo https://github.com/WebwareForPython/DBUtils
    echo https://github.com/canonical/charmcraft
    echo https://github.com/canonical/craft-grammar
    echo https://github.com/canonical/rockcraft
    echo https://github.com/dandi/dandi-archive
    echo https://github.com/davidjrice/autopytest
    echo https://github.com/dxclabs/django-diagnostic
    echo https://github.com/igo95862/bubblejail
    echo https://github.com/jorenham/Lmo
    echo https://github.com/jorenham/exports
    echo https://github.com/jupyter-server/jupyter_server
    echo https://github.com/nextlayer-ansible/molecule-lxd
    echo https://github.com/nodejs/tap2junit
    echo https://github.com/pimoroni/bme280-python
    echo https://github.com/snapcore/snapcraft
    echo https://github.com/wolph/python-progressbar
}

test_repo(){
    local repo_dir=$(mktemp --directory codespell-test-XXXXXXXX)
    git clone --quiet --depth=1 $1 $repo_dir
    pushd $repo_dir
    lengau-codespell.codespell .
    local return_code=$?
    popd
    rm -rf $repo_dir
    return $return_code
}

codespell --version || exit 1
codespell --help || exit 1

any_failed=false
for repo in $(repositories); do
    echo "::group::${repo}"
    if test_repo "${repo}"; then
        echo "status=$repo: success" >> $1
        echo "::endgroup::"
        echo "Succeeded"
    else
        exit_code=$?
        any_failed=true
        echo "status=$repo: failed with exit code $exit_code" >> $1
        echo "::endgroup::"
        echo "Failed with exit code $exit_code"
    fi
done
if [[ $any_failed == "true" ]]; then
    exit 1
fi

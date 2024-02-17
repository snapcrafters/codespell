#!/bin/bash
# Tests for the codespell snap.

set -e

cleanup(){
    rm -rf codespell-snap-test-*
}
trap cleanup EXIT

summary_file="${GITHUB_STEP_SUMMARY:-/dev/stderr}"

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
    echo "::group::Repository: ${repo}"
    local repo_dir=$(mktemp --directory codespell-snap-test-XXXXXXXX)
    git clone --depth=1 $1 $repo_dir
    echo -n "| ${repo} | $(cd ruff; git rev-parse --short HEAD) | " >> $summary_file
    if ( cd $repo_dir; lengau-codespell.codespell --quiet-level 0 .); then
        echo "::endgroup::"
        echo "Success"
        echo "✔️ | 0 |" >> $summary_file
    else
        exit_code=$?
        any_failed=true
        echo "::endgroup::"
        echo "Failed with exit code $exit_code"
        echo "❌ | $exit_code |" >> $summary_file
    fi

}

echo -n "codespell version: " >> $summary_file
(lengau-codespell.codespell --version | tee -a $summary_file) || exit 1
echo "::endgroup::"
echo "::group::Help"
lengau-codespell.codespell --help || exit 1
echo "::endgroup::"

echo "| Repository | Commit | Success | Exit code |" >> $summary_file
echo "|------------|--------|---------|-----------|" >> $summary_file

for repo in $(repositories); do
    test_repo "${repo}"
done

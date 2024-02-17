#!/bin/bash
# Tests for the codespell snap.

set -e

cleanup(){
    rm -rf codespell-snap-test-*
}
trap cleanup EXIT

summary_file="${GITHUB_SUMMARY:-/dev/null}"
echo -e '## Summary:\n' > "$summary_file"

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
    if ( cd $repo_dir; lengau-codespell.codespell --quiet-level 0 .); then
        echo "::endgroup::"
        echo "Success"
        echo "- ${repo}: Success" >> $summary_file
    else
        exit_code=$?
        any_failed=true
        echo "::endgroup::"
        echo "Failed with exit code $exit_code"
        echo "- ${repo}: Failed with exit code $exit_code" >> $summary_file
    fi

}

echo -n "codespell version: " >> $summary_file
lengau-codespell.codespell --version | tee -a $summary_file
echo "::endgroup::"
echo "::group::Help"
lengau-codespell.codespell --help
echo "::endgroup::"

any_failed=false
for repo in $(repositories); do
    test_repo "${repo}"
done
if [[ $any_failed == "true" ]]; then
    echo "Overall: Failed"
    exit 1
fi
echo "Overall: Succeeded"

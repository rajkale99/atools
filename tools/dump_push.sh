#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#
# Helper functions

# Store project path
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null && pwd )"

# Common stuff
source $PROJECT_DIR/helpers/common_script.sh

# Exit if no arguements
[[ -z "$1" ]] && echo -e "Supply dir's as arguements!" && exit 1

# Exit if missing token's
[[ -z "$LAB_TOKEN" ]] && echo -e "Missing GitLab token. Exiting." && exit 1

# o/p
for var in "$@"; do
    ROM_PATH=$( realpath "$var" )
    [[ ! -d "$ROM_PATH" ]] && echo -e "$ROM_PATH is not a valid directory!" && exit 1
    cd "$ROM_PATH"
    [[ ! -d "system/" ]] && echo -e "No system partition found, pushing cancelled!" && exit 1
    # Set variables
    source $PROJECT_DIR/helpers/rom_vars.sh "$ROM_PATH" > /dev/null 2>&1
    if [ -z "$BRAND" ] || [ -z "$DEVICE" ]; then
        echo -e "Could not set variables! Exiting"
        exit 1
    fi
    repo=dum
    repo_desc=dump
    ORG="rajkale99"
    
    git init > /dev/null 2>&1
    git config --global http.postBuffer 524288000 /dev/null 2>&1
    git checkout -b $BRANCH > /dev/null 2>&1
    find -size +97M -printf '%P\n' -o -name *sensetime* -printf '%P\n' -o -name *.lic -printf '%P\n' > .gitignore
    git remote add origin https://gitlab-ci-token:$LAB_TOKEN@gitlab.com/$ORG/dum.git > /dev/null 2>&1
    echo -e "Dumping extras"
    git add --all > /dev/null 2>&1
    git reset system/ vendor/ > /dev/null 2>&1
    git -c "user.name=${ORG}" -c "user.email=${GITHUB_EMAIL}" commit -asm "Add extras for ${DESCRIPTION}" > /dev/null 2>&1
    git push hhttps://gitlab-ci-token:$LAB_TOKEN@gitlab.com/$ORG/dum.git $BRANCH > /dev/null 2>&1
    [[ -d vendor/ ]] && echo -e "Dumping vendor"
    [[ -d vendor/ ]] && git add vendor/ > /dev/null 2>&1
    [[ -d vendor/ ]] && git -c "user.name=${ORG}" -c "user.email=${GITHUB_EMAIL}" commit -asm "Add vendor for ${DESCRIPTION}" > /dev/null 2>&1
    [[ -d vendor/ ]] && git push https://gitlab-ci-token:$LAB_TOKEN@gitlab.com/$ORG/dum.git $BRANCH > /dev/null 2>&1
    echo -e "Dumping apps"
    git add system/system/app/ system/system/priv-app/ > /dev/null 2>&1 || git add system/app/ system/priv-app/ > /dev/null 2>&1
    git -c "user.name=${ORG}" -c "user.email=${GITHUB_EMAIL}" commit -asm "Add apps for ${DESCRIPTION}" > /dev/null 2>&1
    git push https://gitlab-ci-token:$LAB_TOKEN@gitlab.com/$ORG/dum.git $BRANCH > /dev/null 2>&1
    echo -e "Dumping system"
    git add system/ > /dev/null 2>&1
    git -c "user.name=${ORG}" -c "user.email=${GITHUB_EMAIL}" commit -asm "Add system for ${DESCRIPTION}" > /dev/null 2>&1
    git push https://gitlab-ci-token:$LAB_TOKEN@gitlab.com/$ORG/dum.git $BRANCH -f
done

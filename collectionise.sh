#!/bin/bash

# noqa

set -eu
set -o pipefail

function git_is_clean {
  # Check for local repo changes
  # ?? is an uncommitted file, which we can ignore
  # 
  [[ $(git status --porcelain=v1 2>/dev/null | grep -v '^\?\?' | wc -l) = 0 ]]
}

if [[ ! -f galaxy.yml ]]; then
  echo "ERROR: Run this script from the collection root"
  exit 1
fi

if ! git_is_clean; then
  echo "ERROR: Collection has uncommitted local changes"
  exit 1
fi

REPO=${1:?Role repo path}
NAME=${2:?New role name}

if [[ ! -d $REPO ]]; then
  echo "ERROR: Role repo $REPO does not exist"
  exit 1
fi

if [[ -e roles/$NAME ]]; then
  echo "ERROR: Role directory $NAME exists"
  exit 1
fi

cd $REPO
if ! git_is_clean; then
  echo "ERROR: Role has uncommitted local changes"
  exit 1
fi
git checkout origin/master
cd -

cp -ar $REPO roles/$NAME
cd roles/$NAME/
ls -la
rm -rf .git/ .github/ LICENSE COPYING .gitignore venv meta/.galaxy_install_info *.retry ansible.cfg .travis.yml
git add .
git status
git commit -F - << EOF
Add $NAME role

Imported from https://github.com/stackhpc/$(basename $REPO)
EOF

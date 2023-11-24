#!/usr/bin/env bash

# Run Ansible collection sanity tests.

set -eu
set -o pipefail
set -x

NAMESPACE=$(awk '$1 == "namespace:" { print $2 }' galaxy.yml)
NAME=$(awk '$1 == "name:" { print $2 }' galaxy.yml)
ANSIBLE_COLLECTIONS_PATH=$(mktemp -d)
mkdir -p "${ANSIBLE_COLLECTIONS_PATH}/ansible_collections/$NAMESPACE/$NAME"
trap 'rm -rf ${ANSIBLE_COLLECTIONS_PATH}' err exit
ansible-galaxy collection build --force
# shellcheck disable=SC2086
ansible-galaxy collection install $NAMESPACE-$NAME-*.tar.gz --collections-path "${ANSIBLE_COLLECTIONS_PATH}" --force
PY_VER=$(python3 -c "from platform import python_version;print(python_version())" | cut -f 1,2 -d".")
cd "${ANSIBLE_COLLECTIONS_PATH}/ansible_collections/$NAMESPACE/$NAME"
ansible-test sanity -v --color yes --venv --python "${PY_VER}"

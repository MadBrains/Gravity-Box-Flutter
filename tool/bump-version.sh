#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR/..

NEW_VERSION="${1}"

echo "Bumping version: ${NEW_VERSION}"

perl -pi -e "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml

echo -e "## ${NEW_VERSION}\n\nTODO: describe new changes.\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md
echo -e "\033[32mVersion bumped to ${NEW_VERSION}\033[m"
echo -e "\033[33mDon't forget to describe the new version in CHANGELOG.md\033[m"
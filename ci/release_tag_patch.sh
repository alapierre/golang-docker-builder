#!/usr/bin/env bash
set -euo pipefail

git fetch --tags --force

current_tag="$(git tag -l 'v*' | sort -V | tail -n 1)"
if [[ -z "${current_tag}" ]]; then
  current_tag="v0.0.0"
fi

next="$(semver bump patch "${current_tag#v}")"
next_tag="v${next}"

echo "Current tag: ${current_tag}"
echo "Next tag:    ${next_tag}"

git tag "${next_tag}"
git push origin "${next_tag}"
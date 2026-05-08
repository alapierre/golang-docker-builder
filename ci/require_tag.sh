#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${BITBUCKET_TAG:-}" ]]; then
  echo "Run this step only on tag pipelines (BITBUCKET_TAG is empty)."
  exit 1
fi
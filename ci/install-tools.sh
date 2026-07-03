#!/usr/bin/env bash
set -euo pipefail

semver_url="https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver"

curl -L -o /usr/local/bin/semver "${semver_url}"
chmod +x /usr/local/bin/semver

go install github.com/jstemmer/go-junit-report@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@${CYCLONEDX_GOMOD_VERSION}

wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s "${GOLANGCI_LINT_VERSION}"

install_nfpm() {
  local version="${NFPM_VERSION#v}"
  local tmpdir
  tmpdir="$(mktemp -d)"

  curl -fsSL -o "${tmpdir}/nfpm.tar.gz" \
    "https://github.com/goreleaser/nfpm/releases/download/v${version}/nfpm_${version}_Linux_x86_64.tar.gz"
  tar -xzf "${tmpdir}/nfpm.tar.gz" -C "${tmpdir}"
  install -m 0755 "${tmpdir}/nfpm" /usr/local/bin/nfpm
  rm -rf "${tmpdir}"
}

install_nfpm

curl -fsSL -o /tmp/goreleaser.apk \
  "https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_${GORELEASER_VERSION}_x86_64.apk"
apk add --allow-untrusted /tmp/goreleaser.apk
rm /tmp/goreleaser.apk

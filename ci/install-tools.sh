#!/usr/bin/env bash
set -euo pipefail

semver_url="https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver"

curl -L -o /usr/local/bin/semver "${semver_url}"
chmod +x /usr/local/bin/semver

go install github.com/jstemmer/go-junit-report@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@${CYCLONEDX_GOMOD_VERSION}
go install github.com/goreleaser/goreleaser/v2@v${GORELEASER_VERSION}

wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s "${GOLANGCI_LINT_VERSION}"

install_nfpm() {
  local version="${NFPM_VERSION#v}"
  local nfpm_arch
  local tmpdir
  tmpdir="$(mktemp -d)"

  case "${TARGETARCH}" in
    amd64) nfpm_arch="x86_64" ;;
    arm64) nfpm_arch="arm64" ;;
    *)
      echo "Unsupported TARGETARCH=${TARGETARCH}" >&2
      return 1
      ;;
  esac

  curl -fsSL -o "${tmpdir}/nfpm.tar.gz" \
    "https://github.com/goreleaser/nfpm/releases/download/v${version}/nfpm_${version}_Linux_${nfpm_arch}.tar.gz"
  tar -xzf "${tmpdir}/nfpm.tar.gz" -C "${tmpdir}"
  install -m 0755 "${tmpdir}/nfpm" /usr/local/bin/nfpm
  rm -rf "${tmpdir}"
}

install_nfpm

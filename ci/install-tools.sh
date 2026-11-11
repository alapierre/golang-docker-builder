#!/usr/bin/env bash
set -euo pipefail

semver_url="https://raw.githubusercontent.com/fsaintjacques/semver-tool/${SEMVER_VERSION}/src/semver"

curl -fsSL -o /usr/local/bin/semver "${semver_url}"
chmod +x /usr/local/bin/semver

go install github.com/jstemmer/go-junit-report/v2@${GO_JUNIT_REPORT_VERSION}
go install golang.org/x/vuln/cmd/govulncheck@${GOVULNCHECK_VERSION}
go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@${CYCLONEDX_GOMOD_VERSION}
go install github.com/goreleaser/goreleaser/v2@v${GORELEASER_VERSION}
go install gotest.tools/gotestsum@${GOTESTSUM_VERSION}
go install github.com/alapierre/bb-insights/cmd/bb-insights@${BB_INSIGHTS_VERSION}

wget -O- -nv "https://raw.githubusercontent.com/golangci/golangci-lint/${GOLANGCI_LINT_VERSION}/install.sh" | sh -s "${GOLANGCI_LINT_VERSION}"

install_nfpm() {
  local version="${NFPM_VERSION#v}"
  local target_arch="${TARGETARCH:-}"
  local nfpm_arch
  local tmpdir
  tmpdir="$(mktemp -d)"

  if [ -z "${target_arch}" ]; then
    case "$(uname -m)" in
      x86_64) target_arch="amd64" ;;
      aarch64|arm64) target_arch="arm64" ;;
    esac
  fi

  case "${target_arch}" in
    amd64) nfpm_arch="x86_64" ;;
    arm64) nfpm_arch="arm64" ;;
    *)
      echo "Unsupported TARGETARCH=${target_arch}" >&2
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

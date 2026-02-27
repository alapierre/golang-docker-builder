FROM golang:1.26.0-alpine

LABEL maintainer="Adrian Lapierre <al@alapierre.io>"
ARG GOLANGCI_LINT_VERSION=v2.7.0
ARG CYCLONEDX_GOMOD_VERSION=v1.9.0

RUN apk add --no-cache git jq curl bash make openssh-client && \
    curl -L -o /usr/local/bin/semver https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver && \
    chmod +x /usr/local/bin/semver && \
    go install github.com/jstemmer/go-junit-report@latest && \
    go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@${CYCLONEDX_GOMOD_VERSION} && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s ${GOLANGCI_LINT_VERSION}




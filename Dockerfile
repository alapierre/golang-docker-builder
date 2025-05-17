FROM golang:1.24.3-alpine3.21

LABEL maintainer="Adrian Lapierre <al@alapierre.io>"
ARG GOLANGCI_LINT_VERSION=v2.1.6

RUN apk add --no-cache git jq curl bash && \
    curl -L -o /usr/local/bin/semver https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver && \
    chmod +x /usr/local/bin/semver && \
    go install github.com/jstemmer/go-junit-report@latest && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s ${GOLANGCI_LINT_VERSION}




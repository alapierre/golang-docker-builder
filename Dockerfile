FROM golang:1.27.3-alpine

LABEL maintainer="Adrian Lapierre <al@alapierre.io>"
ARG TARGETARCH
ARG GOLANGCI_LINT_VERSION=v2.15.0
ARG CYCLONEDX_GOMOD_VERSION=v1.12.0
ARG NFPM_VERSION=v2.48.0
ARG GORELEASER_VERSION=2.18.3

RUN apk add --no-cache git jq curl bash make openssh-client docker-cli docker-cli-buildx

COPY ci /ci

RUN GOLANGCI_LINT_VERSION="${GOLANGCI_LINT_VERSION}" \
    CYCLONEDX_GOMOD_VERSION="${CYCLONEDX_GOMOD_VERSION}" \
    NFPM_VERSION="${NFPM_VERSION}" \
    GORELEASER_VERSION="${GORELEASER_VERSION}" \
    TARGETARCH="${TARGETARCH}" \
    /ci/install-tools.sh

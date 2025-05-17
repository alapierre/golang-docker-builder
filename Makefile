IMAGE_VERSION=1.24.3-alpine3.21
IMAGE_NAME=lapierre/golang-docker-builder
GOLANGCI_LINT_VERSION=v2.1.6

docker:
	docker build --build-arg GOLANGCI_LINT_VERSION=$(GOLANGCI_LINT_VERSION) -t $(IMAGE_NAME):$(IMAGE_VERSION) .
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(IMAGE_NAME):latest

push:
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)
	docker push $(IMAGE_NAME):latest

multiarch:
	docker buildx build --build-arg GOLANGCI_LINT_VERSION=$(GOLANGCI_LINT_VERSION) --push --pull --platform=linux/arm64/v8,linux/amd64 -t $(IMAGE_NAME):lastest .
	docker pull $(IMAGE_NAME):lastest
	docker tag $(IMAGE_NAME):lastest $(IMAGE_NAME):$(IMAGE_VERSION)
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)

github:
	docker buildx build --build-arg GOLANGCI_LINT_VERSION=$(GOLANGCI_LINT_VERSION) --platform linux/arm64/v8,linux/amd64 \
 		--tag "$(IMAGE_NAME):lastest" --tag "$(IMAGE_NAME):$(IMAGE_VERSION)" \
 		--output "type=image,push=true" .

.PHONY: docker push

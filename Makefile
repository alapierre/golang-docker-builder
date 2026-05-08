IMAGE_VERSION=1.26.3-alpine3
IMAGE_NAME=lapierre/golang-docker-builder

docker:
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .
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

# Go Builder for Bitbucket Pipelines

##

Based on Alpine Image and contains some useful Golang CI/CD tools:

- jq 
- curl 
- bash 
- make
- semver
- go-junit-report
- golangci-lint

## Sample Bitbucket pipeline

````yaml
image: lapierre/golang-docker-builder:1.24.3-alpine3.21

definitions:
  steps:
    build-test: &build-test
      name: Test and Build
      script:
        - mkdir -p test-reports
        - go test ./... -v 2>&1 | go-junit-report > test-reports/report.xml
        - (cd cmd/my-app/ && golangci-lint run -v)
        - go build -o my-app ./cmd/my-app/
      artifacts:
        - test-reports/**        

    release: &release
      name: Release Version
      script:
        - git fetch --tags
        - CURRENT_VERSION=$(git tag -l "v*" | sort -V | tail -n 1)
        - >-
          if [ -z "$CURRENT_VERSION" ]; then
            CURRENT_VERSION="v0.0.1"
          fi
        - echo "Aktualny tag $CURRENT_VERSION"
        - NEXT_VERSION=$(semver bump patch $CURRENT_VERSION)
        - echo "Nowy tag v$NEXT_VERSION"
        - git tag "v$NEXT_VERSION"
        - git push origin "v$NEXT_VERSION"

    docker-build-push: &docker-build-push
      name: Build and Push Docker Image
      services:
        - docker
      script:
        - CURRENT_VERSION=$(git tag -l "v*" | sort -V | tail -n 1)
        - echo "Building Docker image with tag $CURRENT_VERSION"
        - echo $DOCKER_PASS | docker login my-registry.registry.io -u $DOCKER_USER --password-stdin
        - cd cmd/my-app
        - ls -l
        - make docker push IMAGE_VERSION=$CURRENT_VERSION

pipelines:
  default:
    - step: *build-test

  branches:
    master:
      - step: *build-test
      - step: *release
      - step:
          <<: *docker-build-push
          trigger: manual
````

````makefile
IMAGE_VERSION=1.0.0
IMAGE_NAME=my-registry.registry.io/my-app
ROOT_DIR=../..

gen:
	cd $(ROOT_DIR) && go generate ./...

build:
	CGO_ENABLED=0 go build -ldflags="-w -s" -a -installsuffix cgo -o my-app .

docker: build
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(IMAGE_NAME):latest

push:
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)
	docker push $(IMAGE_NAME):latest

clean:
	rm -f my-app

.PHONY: gen build docker push clean

````
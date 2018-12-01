GOOS?=linux
GOARCH?=amd64

PROJECT?=github.com/mityi/go-k8s-simple
BUILD_PATH?=cmd/go-k8s-api
APP?=go-k8s-api

PORT?=8789

# Current version
RELEASE?=0.0.7

# Parameters to push images and release app to Kubernetes or try it with Docker
REGISTRY?=docker.io/webdeva
NAMESPACE?=mityi
CONTAINER_NAME?=${NAMESPACE}-${APP}
CONTAINER_IMAGE?=${REGISTRY}/${CONTAINER_NAME}
VALUES?=values-stable

build:
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) .

push: build
	docker push $(CONTAINER_IMAGE):$(RELEASE)
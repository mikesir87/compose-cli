#   Copyright 2020 Docker Compose CLI authors

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

export DOCKER_BUILDKIT=1

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	MOBY_DOCKER=/usr/bin/docker
endif
ifeq ($(UNAME_S),Darwin)
	MOBY_DOCKER=/Applications/Docker.app/Contents/Resources/bin/docker
endif

BINARY_FOLDER=$(shell pwd)/bin
GIT_TAG?=$(shell git describe --tags --match "v[0-9]*")
TEST_FLAGS?=
E2E_TEST?=
ifeq ($(E2E_TEST),)
else
	TEST_FLAGS=-run $(E2E_TEST)
endif

all: cli

protos: ## Generate go code from .proto files
	@docker build . --target protos \
	--output ./cli/server/protos

cli: ## Compile the cli
	@docker build . --target cli \
	--platform local \
	--build-arg BUILD_TAGS=e2e,kube \
	--build-arg GIT_TAG=$(GIT_TAG) \
	--output ./bin

e2e-local: ## Run End to end local tests. Set E2E_TEST=TestName to run a single test
	gotestsum $(TEST_FLAGS) ./local/e2e/container ./local/e2e/cli-only -- -count=1

e2e-win-ci: ## Run end to end local tests on Windows CI, no Docker for Linux containers available ATM. Set E2E_TEST=TestName to run a single test
	go test -count=1 -v $(TEST_FLAGS) ./local/e2e/cli-only

e2e-kube: ## Run End to end Kube tests. Set E2E_TEST=TestName to run a single test
	go test -timeout 10m -count=1 -v $(TEST_FLAGS) ./kube/e2e

e2e-aci: ## Run End to end ACI tests. Set E2E_TEST=TestName to run a single test
	go test -timeout 15m -count=1 -v $(TEST_FLAGS) ./aci/e2e

e2e-ecs: ## Run End to end ECS tests. Set E2E_TEST=TestName to run a single test
	go test -timeout 20m -count=1 -v $(TEST_FLAGS) ./ecs/e2e/ecs ./ecs/e2e/ecs-local

cross: ## Compile the CLI for linux, darwin and windows
	@docker build . --target cross \
	--build-arg BUILD_TAGS \
	--build-arg GIT_TAG=$(GIT_TAG) \
	--output ./bin \

test: ## Run unit tests
	@docker build --progress=plain . \
	--build-arg BUILD_TAGS=kube \
	--build-arg GIT_TAG=$(GIT_TAG) \
	--target test

cache-clear: ## Clear the builder cache
	@docker builder prune --force --filter type=exec.cachemount --filter=unused-for=24h

lint: ## run linter(s)
	@docker build . \
	--build-arg BUILD_TAGS=kube,e2e \
	--build-arg GIT_TAG=$(GIT_TAG) \
	--target lint

check-dependencies: ## check dependency updates
	go list -u -m -f '{{if not .Indirect}}{{if .Update}}{{.}}{{end}}{{end}}' all

import-restrictions: ## run import-restrictions script
	@docker build . \
	--target import-restrictions

serve: cli ## start server
	@./bin/docker serve --address unix:///tmp/backend.sock

moby-cli-link: ## Create com.docker.cli symlink if does not already exist
	ln -s $(MOBY_DOCKER) /usr/local/bin/com.docker.cli

install: ## Link /usr/local/bin/ to current binary
	ln -fs $(BINARY_FOLDER)/docker /usr/local/bin/docker

validate-headers: ## Check license header for all files
	@docker build . --target check-license-headers

go-mod-tidy: ## Run go mod tidy in a container and output resulting go.mod and go.sum
	@docker build . --target go-mod-tidy --output .

validate-go-mod: ## Validate go.mod and go.sum are up-to-date
	@docker build . --target check-go-mod

validate: validate-go-mod validate-headers ## Validate sources

pre-commit: validate import-restrictions check-dependencies lint cli test e2e-local

build-aci-sidecar:  ## build aci sidecar image locally and tag it with make build-aci-sidecar tag=0.1
	docker build -t docker/aci-hostnames-sidecar:$(tag) aci/etchosts

publish-aci-sidecar: build-aci-sidecar ## build & publish aci sidecar image with make publish-aci-sidecar tag=0.1
	docker pull docker/aci-hostnames-sidecar:$(tag) && echo "Failure: Tag already exists" || docker push docker/aci-hostnames-sidecar:$(tag)

build-ecs-search-sidecar:  ## build ecs search sidecar image locally and tag it with make build-ecs-search-sidecar tag=0.1
	docker build -t docker/ecs-searchdomain-sidecar:$(tag) ecs/resolv

publish-ecs-search-sidecar: build-ecs-search-sidecar ## build & publish ecs search sidecar image with make publish-ecs-search-sidecar tag=0.1
	docker pull docker/ecs-searchdomain-sidecar:$(tag) && echo "Failure: Tag already exists" || docker push docker/ecs-searchdomain-sidecar:$(tag)

build-ecs-secrets-sidecar:  ## build ecs secrets sidecar image locally and tag it with make build-ecs-secrets-sidecar tag=0.1
	docker build -t docker/ecs-secrets-sidecar:$(tag) ecs/secrets

publish-ecs-secrets-sidecar: build-ecs-secrets-sidecar ## build & publish ecs secrets sidecar image with make publish-ecs-secrets-sidecar tag=0.1
	docker pull docker/ecs-secrets-sidecar:$(tag) && echo "Failure: Tag already exists" || docker push docker/ecs-secrets-sidecar:$(tag)

clean-aci-e2e: ## Make sure no ACI tests are currently runnnig in the CI when invoking this. Delete ACI E2E tests resources that might have leaked when ctrl-C E2E tests.
	@ echo "Will delete resource groups: "
	@ az group list | jq '.[].name' | grep -i E2E-Test
	az group list | jq '.[].name' | grep -i E2E-Test | xargs -n1 az group delete -y --no-wait -g

help: ## Show help
	@echo Please specify a build target. The choices are:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

FORCE:

.PHONY: all validate protos cli e2e-local cross test cache-clear lint check-dependencies serve classic-link help clean-aci-e2e go-mod-tidy

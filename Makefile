NAME ?= sbc
OPENSIPS_VERSION ?= 3.2
OPENSIPS_BUILD ?= releases
OPENSIPS_DOCKER_TAG ?= minhbv3.2
OPENSIPS_CLI ?= true
OPENSIPS_EXTRA_MODULES ?= opensips-*
DOCKER_ARGS ?=

all: build start

.PHONY: build start
build:
	docker build \
		--no-cache \
		--build-arg=OPENSIPS_BUILD=$(OPENSIPS_BUILD) \
		--build-arg=OPENSIPS_VERSION=$(OPENSIPS_VERSION) \
		--build-arg=OPENSIPS_CLI=${OPENSIPS_CLI} \
		--build-arg=OPENSIPS_EXTRA_MODULES="${OPENSIPS_EXTRA_MODULES}" \
		$(DOCKER_ARGS) \
		--tag="opensips/opensips:$(OPENSIPS_DOCKER_TAG)" \
		.

start:
	docker run -it -d --restart always --name $(NAME) --hostname $(NAME) -p 5060:5060/udp opensips/opensips:$(OPENSIPS_DOCKER_TAG)

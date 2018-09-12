USER := $(shell stat -c "%u:%g" .)
IMAGE := pi-kernel-builder
DOCKER_CMD := docker run -v ${PWD}:/build -w /build -u $(USER) $(IMAGE)

all: zImage modules dtbs

%:
	$(DOCKER_CMD) make -C linux -f Makefile ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $@

.PHONY: config
config: linux/.config

linux/.config:
	make bcmrpi_defconfig

.PHONY: docker
docker: docker/Dockerfile
	docker build -t $(IMAGE) docker

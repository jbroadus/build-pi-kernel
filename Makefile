USER := $(shell stat -c "%u:%g" .)
IMAGE := pi-kernel-builder
DOCKER_CMD := docker run -v ${PWD}:/build -w /build -u $(USER) $(IMAGE)
DEFCONFIG := bcm2709_defconfig
CFLAGS := ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

all: zImage modules dtbs

%:
	$(DOCKER_CMD) make -C linux -f Makefile $(CFLAGS) $@

.PHONY: config
config: linux/.config

linux/.config:
	make $(DEFCONFIG)

.PHONY: docker
docker: docker/Dockerfile
	docker build -t $(IMAGE) docker

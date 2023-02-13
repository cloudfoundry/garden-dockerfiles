all: clean with-volume garden-release tutu
.PHONY: push garden-release with-volume empty zip-bomb dev-vm fifteen-point-five tutu

push:
	docker push cfgarden/with-volume
	docker push cloudfoundry/garden-release
	docker push cfgarden/empty
	docker push cfgarden/zip-bomb
	docker push cfgarden/tutu
	docker push cfgarden/hello

ASSETS_DIR=garden-release
ASSETS=${ASSETS_DIR}/rootfs.tar ${ASSETS_DIR}/docker_registry_v2.tar ${ASSETS_DIR}/fuse-rootfs.tar

${ASSETS_DIR}/rootfs.tar:
	docker build --build-arg BUSYBOX_VERSION=1.31 -t cfgarden/busybox --rm busybox
	docker run --name busybox cfgarden/busybox
	docker export -o ${ASSETS_DIR}/rootfs.tar busybox
	docker rm -f busybox

${ASSETS_DIR}/fuse-rootfs.tar: garden-fuse/Dockerfile
	docker build -t cloudfoundry/fuse --rm garden-fuse
	docker run --name fuse cloudfoundry/garden-fuse
	docker export -o ${ASSETS_DIR}/fuse-rootfs.tar fuse
	docker rm -f garden-fuse

${ASSETS_DIR}/docker_registry_v2.tar:
	# spin up a local docker registry
	docker run -d -p "5000:5000" -e "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/opt/docker-registry" --name docker_registry_v2 registry:2.6.2

	# push busybox to our local registry
	docker pull busybox
	docker tag busybox localhost:5000/busybox
	docker push localhost:5000/busybox

	# export registry iamge as a tar
	docker export -o ${ASSETS_DIR}/docker_registry_v2.tar docker_registry_v2
	docker rm -f docker_registry_v2

garden-release: clean build-garden-release

build-garden-release: ${ASSETS} garden-release/Dockerfile
	docker build --build-arg -t cloudfoundry/garden-release --rm garden-release

with-volume: with-volume/Dockerfile
	docker build -t cfgarden/with-volume --rm with-volume

with-process-env: with-process-env/Dockerfile
	docker build -t cfgarden/with-process-env --rm with-process-env

tutu:
	docker build -t cfgarden/tutu --rm tutu

iamthebomb:
	docker build -t cfgarden/iamthebomb --rm zip-bomb

hello: hello/Dockerfile
	docker build -t cfgarden/hello --rm hello

clean:
	rm -rf ${ASSETS_DIR}/*.tar

all: with-volume garden-ci garden-ci-ubuntu
.PHONY: push with-volume garden-ci garden-ci-ubuntu

push:
	docker push cloudfoundry/with-volume
	docker push cfgarden/garden-ci
	docker push cfgarden/garden-ci-ubuntu

with-volume: with-volume/Dockerfile
	docker build -t cloudfoundry/with-volume --rm with-volume

garden-ci: garden-ci/Dockerfile
	docker build -t cfgarden/garden-ci --rm garden-ci

ROOTFSES_DIR=garden-ci-ubuntu/rootfses
DEPS_DIR=garden-ci-ubuntu/dependencies
DEPENDENCIES=${DEPS_DIR}/busybox.tar \
						 ${DEPS_DIR}/ubuntu.tar \
						 ${DEPS_DIR}/docker_registry.tar \
						 ${DEPS_DIR}/docker_registry_v2.tar \
						 ${DEPS_DIR}/hello \
						 ${DEPS_DIR}/fuse.tar \
						 ${DEPS_DIR}/preexisting_users.tar

${DEPS_DIR}/busybox.tar: ${ROOTFSES_DIR}/busybox/Dockerfile
	docker build -t cfgarden/busybox --rm ${ROOTFSES_DIR}/busybox
	docker run --name busybox cfgarden/busybox
	docker export -o ${DEPS_DIR}/busybox.tar busybox
	docker rm -f busybox

${DEPS_DIR}/docker_registry.tar:
	docker run -d --name docker_registry registry
	docker export -o ${DEPS_DIR}/docker_registry.tar docker_registry
	docker rm -f docker_registry

${DEPS_DIR}/docker_registry_v2.tar:
	docker run -d -p "5000:5000" -e "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/opt/docker-registry" --name docker_registry_v2 registry:2.0.1
	./garden-ci-ubuntu/scripts/provision_registry_v2.sh
	docker export -o ${DEPS_DIR}/docker_registry_v2.tar docker_registry_v2
	docker rm -f docker_registry_v2

${DEPS_DIR}/hello: ${ROOTFSES_DIR}/empty/hello.go
	cd ${ROOTFSES_DIR}/empty && GOOS=linux go build hello.go
	mv ${ROOTFSES_DIR}/empty/hello ${DEPS_DIR}/hello

${DEPS_DIR}/fuse.tar: ${ROOTFSES_DIR}/fuse/Dockerfile
	docker build -t cfgarden/fuse --rm ${ROOTFSES_DIR}/fuse
	docker run --name fuse cfgarden/fuse
	docker export -o ${DEPS_DIR}/fuse.tar fuse
	docker rm -f fuse

${DEPS_DIR}/ubuntu.tar: ${ROOTFSES_DIR}/ubuntu/Dockerfile
	docker build -t cfgarden/ubuntu --rm ${ROOTFSES_DIR}/ubuntu
	docker run --name ubuntu cfgarden/ubuntu
	docker export -o ${DEPS_DIR}/ubuntu.tar ubuntu
	docker rm -f ubuntu

${DEPS_DIR}/preexisting_users.tar: ${ROOTFSES_DIR}/preexisting_users/Dockerfile
	docker build -t cfgarden/preexisting_users --rm ${ROOTFSES_DIR}/preexisting_users
	docker run -d --name preexisting_users cfgarden/preexisting_users
	docker export -o ${DEPS_DIR}/preexisting_users.tar preexisting_users
	docker rm -f preexisting_users

garden-ci-ubuntu: ${DEPENDENCIES} garden-ci-ubuntu/Dockerfile
	docker build -t cfgarden/garden-ci-ubuntu --rm garden-ci-ubuntu

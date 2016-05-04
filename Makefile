TAG?=latest

all: golang-ci with-volume garden-ci

.PHONY: push golang-ci with-volume garden-ci

push:
	docker push cloudfoundry/golang-ci
	docker push cloudfoundry/with-volume
	docker push cfgarden/garden-ci

golang-ci: golang-ci/Dockerfile
	docker build -t cloudfoundry/golang-ci:${TAG} --rm golang-ci

with-volume: with-volume/Dockerfile
	docker build -t cloudfoundry/with-volume:${TAG} --rm with-volume

garden-ci: garden-ci/Dockerfile
	docker build -t cfgarden/garden-ci:${TAG} --rm garden-ci

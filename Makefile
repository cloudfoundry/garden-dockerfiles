TAG?=latest

all: golang-ci with-volume

.PHONY: golang-ci with-volume

push:
	docker push cloudfoundry/golang-ci
	docker push cloudfoundry/with-volume

golang-ci: golang-ci/Dockerfile
	docker build -t cloudfoundry/golang-ci:${TAG} --rm golang-ci

with-volume: with-volume/Dockerfile
	docker build -t cloudfoundry/with-volume:${TAG} --rm with-volume

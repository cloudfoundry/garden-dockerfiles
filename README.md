# Garden Dockerfiles

Images CF Garden team consumes in testing environments.

* `garden-ci`: Used by almost all jobs in CI.
* `large_layers`: An image with large layers.
* `ubuntu-bc`: Ubuntu image with `bc` program.
* `with-user-with-group`: Image with a user that has supplementary groups.
* `with-volume`: Image that uses defines a Docker volume.

## Building garden-ci

```
make garden-ci
```

## Producing a new image

Tag the image with the correct version:

```
docker tag cloudfoundry/garden-ci:latest cloudfoundry/garden-ci:x.y.z
docker push cloudfoundry/garden-ci:x.y.z
docker push cloudfoundry/garden-ci:latest
```

We use semantic versioning for version numbers.


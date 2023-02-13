# Garden Dockerfiles

Images CF Garden team consumes in testing environments.

* `garden-runc-release`: Used by almost all jobs in CI.
* `large_layers`: An image with large layers.
* `ubuntu-bc`: Ubuntu image with `bc` program.
* `with-user-with-group`: Image with a user that has supplementary groups.
* `with-volume`: Image that uses defines a Docker volume.

## Building garden-runc-release

```
make garden-runc-release
```

## Producing a new image

Tag the image with the correct version:

```
docker tag cloudfoundry/garden-runc-release:latest cloudfoundry/garden-release:x.y.z
docker push cloudfoundry/garden-runc-release:x.y.z
docker push cloudfoundry/garden-runc-release:latest
```

We use semantic versioning for version numbers.


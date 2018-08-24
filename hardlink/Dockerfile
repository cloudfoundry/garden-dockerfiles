# This image is being used by grootfs integration tests (integration/assets/oci-test-image/hardlink) after the following modifications:
# Build a docker image and tag it as hardlink:latest
# Run skopeo --insecure-policy copy docker-daemon:hardlink:latest  oci:hardlink:latest
# Modify the manifest to include the basedir annotation on the last layer
FROM busybox
RUN touch file && mkdir -p /first/second && ln file /first/second/file-link && mkdir -p /first/second && touch /first/second/file2 && ln /first/second/file2 file-link2

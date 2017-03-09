FROM busybox

RUN echo "source!" > /etc/link-source
RUN echo "WHAT?" > /tmp/symlink
RUN rm /tmp/symlink && ln -s /etc/link-source /tmp/symlink

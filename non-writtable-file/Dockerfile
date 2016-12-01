FROM busybox
RUN mkdir test && touch test/hello && chmod 555 test/hello
RUN chmod 777 test/hello && echo "walla" > /test/hello && chmod 555 /test/hello

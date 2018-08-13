FROM alpine

RUN apk update && apk add gcc build-base abuild binutils binutils-doc gcc-doc
ADD ./pinkescapekey.c ./pinkescapekey.c
RUN gcc -o /usr/local/bin/pinkescapekey ./pinkescapekey.c
RUN rm ./pinkescapekey.c

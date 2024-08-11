FROM alpine:latest
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories && \
    apk add --no-cache bash inotify-tools curl

ADD pia-port.sh /scripts/pia-port.sh
RUN chmod +x /scripts/*.sh
CMD ["/scripts/pia-port.sh"]

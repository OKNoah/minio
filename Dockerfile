FROM golang:1.10.1-alpine3.7

LABEL maintainer="Minio Inc <dev@minio.io>"

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV CGO_ENABLED 0
ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

# Fly/wormhole

ENV FLY_LOCAL_ENDPOINT 127.0.0.1:9000
ENV FLY_TOKEN fly_token

ADD https://github.com/superfly/wormhole/releases/download/v0.5.36/wormhole_linux_amd64 /usr/bin/wormhole

RUN chmod +x /usr/bin/wormhole

WORKDIR /go/src/github.com/minio/

COPY dockerscripts/healthcheck.sh /usr/bin/

RUN  \
     apk add --no-cache ca-certificates curl && \
     apk add --no-cache --virtual .build-deps git && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     go get -v -d github.com/minio/minio && \
     cd /go/src/github.com/minio/minio && \
     go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
     rm -rf /go/pkg /go/src /usr/local/go && apk del .build-deps

EXPOSE 9000

VOLUME ["/data"]

HEALTHCHECK --interval=30s --timeout=5s \
    CMD /usr/bin/healthcheck.sh

CMD ["wormhole", "minio"]

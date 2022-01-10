#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM golang:1.15.8-alpine3.13 as builder
ENV KRAKEND_DOWNLOAD_SHA512 6d98051a3db8ee9c9b864b8acf5d9d821fe8fa9a439242a1b8d452a5e217eefef85ab0ce6ef8a0dc86ccc1cbedf4415a1e464081ccb76a69de0f88747395f994
WORKDIR /app

RUN apk add --no-cache make gcc musl-dev gnupg
RUN set -eux; \
    wget -O krakend.tar.gz "https://github.com/devopsfaith/krakend-ce/archive/refs/tags/v1.3.0.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/devopsfaith/krakend-ce/releases/download/v1.3.0/v1.3.0.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C /app --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c;


RUN make build

FROM alpine:3.13

LABEL maintainer="community@krakend.io"
ENV VERSION="1.3.0"

RUN apk add --no-cache ca-certificates && \
	adduser -u 1000 -S -D -H krakend && \
	mkdir /etc/krakend && \
	echo '{ "version": 2 }' > /etc/krakend/krakend.json

COPY --from=builder /app/krakend /usr/bin/krakend

USER 1000

WORKDIR /etc/krakend

ENTRYPOINT [ "/usr/bin/krakend" ]
CMD [ "run", "-c", "/etc/krakend/krakend.json" ]

EXPOSE 8080 8090

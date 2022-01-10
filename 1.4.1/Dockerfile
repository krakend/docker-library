#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM golang:1.16.4-alpine3.13 as builder
ENV KRAKEND_DOWNLOAD_SHA512 e1c67279609fd006b607a9b498865175324792f0174a188bf1ccc288633b715e77341c738c020de218bdf9e852271365c75361b2941edd05ebeebd4d86166643
WORKDIR /app

RUN apk add --no-cache make gcc musl-dev gnupg
RUN set -eux; \
    wget -O krakend.tar.gz "https://github.com/devopsfaith/krakend-ce/archive/refs/tags/v1.4.1.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/devopsfaith/krakend-ce/releases/download/v1.4.1/v1.4.1.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C /app --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c;


RUN make build

FROM alpine:3.13

LABEL maintainer="community@krakend.io"
ENV VERSION="1.4.1"

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

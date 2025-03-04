#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM --platform=$BUILDPLATFORM alpine:3.21 as builder

LABEL maintainer="community@krakend.io"

WORKDIR /

ARG TARGETARCH
RUN apk add --no-cache --virtual .build-deps gnupg
RUN set -eux; \
    case "$TARGETARCH" in \
        'amd64') \
			export GOARCH='amd64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=7145b8b395aab44a294b8e09bbe2564e45ddd1d9b80f8ba9780417ce025a1338f3954cf459aa9c173b8db0e9e267b3710c0f31bc0ecc5b367041b6ecb4701138; \
			;; \
		'arm64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=24ec3e2729132f9386b2d3648a78944fee255b496567f5610e04ff662f8b1a4d564aee5b83a7a3b70dd7e59eeaeb50b8ae7c1f0975fb0da8edb6e8028fe0e43e; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.9.2/krakend_2.9.2_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.9.2/krakend_2.9.2_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C / --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
	rm -f krakend.tar.gz krakend.tar.gz.asc; \
	apk del --no-network .build-deps

FROM alpine:3.21

LABEL maintainer="community@krakend.io"

WORKDIR /etc/krakend

RUN apk upgrade --no-cache --no-interactive && apk add --no-cache --virtual .run-deps ca-certificates su-exec tzdata && \
	adduser -u 1000 -S -D -H krakend && \
	echo '{ "version": 3 }' > /etc/krakend/krakend.json

COPY --from=builder /usr/bin/krakend /usr/bin/krakend

COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 8080 8090
CMD [ "krakend", "run", "-c", "/etc/krakend/krakend.json" ]

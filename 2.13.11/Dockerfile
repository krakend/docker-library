#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM alpine:3.23

LABEL org.opencontainers.image.authors="community@krakend.io"

RUN set -eux; \
	apk add --no-cache --virtual .run-deps ca-certificates su-exec tzdata; \
	adduser -u 1000 -S -D -H krakend;

RUN set -eux; \
    apk add --no-cache --virtual .build-deps gnupg; \
    arch="$(apk --print-arch)"; \
	case "$arch" in \
		'x86_64') \
			export GOARCH='amd64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=41cac4c553114771e742cd02f65f2ce2a54071b7d7231f7b5bf1adb3c01a997596502423f6727bac14815ee9bfd457f5cdf6d82bea1ca15e66716a4df6fa1647; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=34fb2fa7547a31afa7a14d3946372d51f76631d5d215d8f43e742ac113fdcb589bd91a32233b4700f1d2484169dd247de2a4516686308980231d9dc5e0dd9de4; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakend/krakend-ce/releases/download/v2.13.11/krakend_2.13.11_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakend/krakend-ce/releases/download/v2.13.11/krakend_2.13.11_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"; \
    echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
    tar -xzf krakend.tar.gz -C / --strip-components 1; \
    rm -f krakend.tar.gz krakend.tar.gz.asc; \
    apk del --no-network .build-deps; \
    echo '{ "version": 3 }' > /etc/krakend/krakend.json

WORKDIR /etc/krakend

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 8080 8090
CMD [ "krakend", "run", "-c", "krakend.json" ]

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
			export KRAKEND_DOWNLOAD_SHA512=b0a1bdef80c61487c6a198fc299a048c6ff1742281d31f4dbda1107ef2cbc9a6ea27992e8e684a25fdf22f5f3d6e85fdf0bfb84c0d8b9ae764528d0c423dad0c; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=4ba4e0333a10e61f72bff99654816d6724655ccb6d1ce67274f5c740ed4ac369b4cd6b1dd00f12bc2c601981163eb19fdb37fc83b67b4fe5eaac7283b157b472; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakend/krakend-ce/releases/download/v3.0.1/krakend_3.0.1_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakend/krakend-ce/releases/download/v3.0.1/krakend_3.0.1_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"; \
    echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
    tar -xzf krakend.tar.gz -C / --strip-components 1; \
    rm -f krakend.tar.gz krakend.tar.gz.asc; \
    apk del --no-network .build-deps; \
    echo '{ "version": 4 }' > /etc/krakend/krakend.json

WORKDIR /etc/krakend

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 8080 8090
CMD [ "krakend", "run", "-c", "krakend.json" ]

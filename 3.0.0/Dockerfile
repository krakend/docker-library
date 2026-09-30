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
			export KRAKEND_DOWNLOAD_SHA512=82f3eb45b7680394e00b94b45fa4696fcacf3592b4753098fa9826bde7d43366c47f586e8314dc2f88572e6fa447384596ac3678f4d76cbf3ce8f81a94059fe7; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=f2f9bb8ac9058c61cd438586c829de20a12773fb840f5a6e36a3414f06c5ce417fb72b693687886b1fff500a52a9cb316d4010a10c9d398149b64820193383c0; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakend/krakend-ce/releases/download/v3.0.0/krakend_3.0.0_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakend/krakend-ce/releases/download/v3.0.0/krakend_3.0.0_${GOARCH}_alpine.tar.gz.asc"; \
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

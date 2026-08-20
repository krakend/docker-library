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
			export KRAKEND_DOWNLOAD_SHA512=bd646a2efd232972e5bc399a0747379523f8dae8d9b16d2ec99c70e017110f8f0a7a8b3f830170484c1300df862b03e9af167327b24d979da767c9a7b6ae0d7f; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=b20bf3fb5e45f5ea1c4711474ed9537a6071af71cf90e302c2ec40bf51ec25922b931f32d5c090abdb8d52ef33062bb19d29852e324d7a23d6194bd7bbe1e0a0; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakend/krakend-ce/releases/download/v2.13.10/krakend_2.13.10_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakend/krakend-ce/releases/download/v2.13.10/krakend_2.13.10_${GOARCH}_alpine.tar.gz.asc"; \
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

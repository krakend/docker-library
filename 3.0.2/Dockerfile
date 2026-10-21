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
			export KRAKEND_DOWNLOAD_SHA512=739e288791fc1a52cb95e43e816020abe571f50d0696bd3e4d9a3e953841fc91c355e0ab0af4c358e6d63953d6ddfa3f1cf4d2b0ebf21be455fcd4b8bb3639db; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=3c7007758b10530a9b50cee1a8441025e506053164005b30f2ecae866aa9ca2b9e4041c384b209ce99af6934908d666112be4dab4adfca9f175f3ce204973f13; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakend/krakend-ce/releases/download/v3.0.2/krakend_3.0.2_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakend/krakend-ce/releases/download/v3.0.2/krakend_3.0.2_${GOARCH}_alpine.tar.gz.asc"; \
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

#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM alpine:3.17

LABEL maintainer="community@krakend.io"

WORKDIR /

RUN apk add --no-cache --virtual .build-deps gnupg
RUN set -eux; \
    arch="$(apk --print-arch)"; \
	case "$arch" in \
		'x86_64') \
			export GOARCH='amd64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=5271ce3c9c28712261b4f3f161578a5eff5c0876448b5594ce02d860bc0b55dbb7c6eb9530b552c13c269aaa64c48fedb95bf5f9646aa3be7515406d33d913bb; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=7e329d4db6c6c1aaa2812a2fc6c796880245a492692d7b26603de39c196165b2e000fb19313643b2431db2fb870c9ede1aa9d6d559619384e2888721524dfa22; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.2.1/krakend_2.2.1_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.2.1/krakend_2.2.1_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C / --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
	rm -f krakend.tar.gz krakend.tar.gz.asc; \
	apk del --no-network .build-deps

RUN apk add --no-cache --virtual .run-deps ca-certificates su-exec tzdata && \
	adduser -u 1000 -S -D -H krakend && \
	echo '{ "version": 3 }' > /etc/krakend/krakend.json

WORKDIR /etc/krakend

COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 8080 8090
CMD [ "krakend", "run", "-c", "/etc/krakend/krakend.json" ]

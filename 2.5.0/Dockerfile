#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM --platform=$BUILDPLATFORM alpine:3.18 as builder

LABEL maintainer="community@krakend.io"

WORKDIR /

ARG TARGETARCH
RUN apk add --no-cache --virtual .build-deps gnupg
RUN set -eux; \
    case "$TARGETARCH" in \
        'amd64') \
			export GOARCH='amd64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=afae9685b51d29c853e7bb03f886fd9592e8c89c16172b7c14eb1db6790b42294cff70873fee3fd0f8bdcdb3019761c2c3adf747a6c8c52edb460e5bad4d6218; \
			;; \
		'arm64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=c64d6abf232578b71258d4a7da995a60b3b0c4aa2cd35221ec6261f3db5aeb759860c8f8602ebabb6d1322c1ee820d5bcde30f1f93abd2e8c9ca1a5fb44429cd; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.5.0/krakend_2.5.0_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.5.0/krakend_2.5.0_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C / --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
	rm -f krakend.tar.gz krakend.tar.gz.asc; \
	apk del --no-network .build-deps

FROM alpine:3.18

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

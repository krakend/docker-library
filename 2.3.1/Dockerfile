#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM --platform=$BUILDPLATFORM alpine:3.17 as builder

LABEL maintainer="community@krakend.io"

WORKDIR /

ARG TARGETARCH
RUN apk add --no-cache --virtual .build-deps gnupg
RUN set -eux; \
    case "$TARGETARCH" in \
        'amd64') \
			export GOARCH='amd64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=deb2e1c312535a639a486c4c2dd8a8ea5256106c2ff87d54202431f977ef3dfb748c86125e78edf638577e94bf69dcecf31727ca522ec0e1997b525e10ddbca7; \
			;; \
		'arm64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=6313bf4512a7756870b70e6597e106b0ac36bf1ea4e2f419941f04d6bbf5a0987c24aaeb6bc6cdce6faa7676e68056a4cf4319101628a9feb6d03136b2b630ec; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.3.1/krakend_2.3.1_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.3.1/krakend_2.3.1_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C / --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
	rm -f krakend.tar.gz krakend.tar.gz.asc; \
	apk del --no-network .build-deps

FROM alpine:3.17

LABEL maintainer="community@krakend.io"

WORKDIR /etc/krakend

RUN apk add --no-cache --virtual .run-deps ca-certificates su-exec tzdata && \
	adduser -u 1000 -S -D -H krakend && \
	echo '{ "version": 3 }' > /etc/krakend/krakend.json

COPY --from=builder /usr/bin/krakend /usr/bin/krakend

COPY docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 8080 8090
CMD [ "krakend", "run", "-c", "/etc/krakend/krakend.json" ]

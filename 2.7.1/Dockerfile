#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM --platform=$BUILDPLATFORM alpine:3.19 as builder

LABEL maintainer="community@krakend.io"

WORKDIR /

ARG TARGETARCH
RUN apk add --no-cache --virtual .build-deps gnupg
RUN set -eux; \
    case "$TARGETARCH" in \
        'amd64') \
			export GOARCH='amd64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=a0db75a776d28172ff09ff4a84b5f4c506ce80588f71571507409aa27a3a81e2f07b7ddee71e7c317694a2deecc028ad761647c1c470d83f88540477239916da; \
			;; \
		'arm64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=49d9de600f79e0627bafd5713499a7c50a5fc74a5ea63dd9c3c6510cda593d8751b765664809862dc734fef3cf6247066302f71f3f1147b5b4e3f181d6a26636; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.7.1/krakend_2.7.1_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.7.1/krakend_2.7.1_${GOARCH}_alpine.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 5B270F2E01E375FD9D5635E25DE6FD698AD6FDD2; \
    gpg --batch --verify krakend.tar.gz.asc krakend.tar.gz; \
    tar xzf krakend.tar.gz -C / --strip-components 1; \
	echo "$KRAKEND_DOWNLOAD_SHA512 *krakend.tar.gz" | sha512sum -c; \
	rm -f krakend.tar.gz krakend.tar.gz.asc; \
	apk del --no-network .build-deps

FROM alpine:3.19

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

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
			export KRAKEND_DOWNLOAD_SHA512=e3bf92200d800ae08c6736d5e51a73b500264e86fe0acd0631aec4cbed308019671d77034fa32e3cfc16e2546a129b234b162116e522b2a3e022d4d5cb5e47d9; \
			;; \
		'arm64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=13514fa9675637adcfacc6472bc7dc278ff5ed1e5eef4859c7c570fe1bc9d8ce8ed58397a7957095214670a6e62be470aa1db7ea6e8275ade545ee6ada76e306; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.3.0/krakend_2.3.0_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.3.0/krakend_2.3.0_${GOARCH}_alpine.tar.gz.asc"; \
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

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
			export KRAKEND_DOWNLOAD_SHA512=b890db5172b6a9add480291f233bff01e678323bd49d638dbdaa8fe02bf512307c62e39841f3b0736ff44eab6ee070a7724f03fe385f67a47b11fbd81a3bd039; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			export KRAKEND_DOWNLOAD_SHA512=a6b1dc5127c4a13cf64d98e5e85ec7febf2b6fc1c3d131dd77398caa37de4eac2ca7c28771333e6b9eb635ace2e4dc7cc979f3890acbcd62b277f551e6bc7834; \
			;; \
		*) echo >&2 "error: unsupported architecture '$TARGETARCH' (likely packaging update needed)"; exit 1 ;; \
	esac; \
    wget -O krakend.tar.gz "https://github.com/krakendio/krakend-ce/releases/download/v2.1.4/krakend_2.1.4_${GOARCH}_alpine.tar.gz"; \
    wget -O krakend.tar.gz.asc "https://github.com/krakendio/krakend-ce/releases/download/v2.1.4/krakend_2.1.4_${GOARCH}_alpine.tar.gz.asc"; \
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

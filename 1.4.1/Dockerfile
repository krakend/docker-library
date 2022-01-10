#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM golang:1.16.4-alpine3.13 as builder

WORKDIR /app
RUN wget -O krakend.tar.gz "https://github.com/devopsfaith/krakend-ce/archive/refs/tags/v1.4.1.tar.gz"; \
	tar -xzf krakend.tar.gz -C /app --strip-components 1
RUN ls /app
RUN apk add make gcc musl-dev


RUN make build

FROM alpine:3.13

LABEL maintainer="community@krakend.io"
ENV VERSION="1.4.1"

RUN apk add --no-cache ca-certificates && \
	adduser -u 1000 -S -D -H krakend && \
	mkdir /etc/krakend && \
	echo '{ "version": 2 }' > /etc/krakend/krakend.json

COPY --from=builder /app/krakend /usr/bin/krakend

USER 1000

WORKDIR /etc/krakend

ENTRYPOINT [ "/usr/bin/krakend" ]
CMD [ "run", "-c", "/etc/krakend/krakend.json" ]

EXPOSE 8080 8090

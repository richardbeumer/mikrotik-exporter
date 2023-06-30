###############################################################################
# BUILD STAGE

FROM cgr.dev/chainguard/go:1.21-dev AS builder
RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' .
COPY scripts/start.sh /build/
RUN chmod 755 /build/*

###############################################################################
# PACKAGE STAGE

FROM cgr.dev/chainguard/go:1.21-dev
EXPOSE 9436
COPY --from=builder /build/* /app/
WORKDIR /app
ENTRYPOINT ["./start.sh"]
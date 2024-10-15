###############################################################################
# BUILD STAGE

FROM cgr.dev/chainguard/go:latest-dev AS builder
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN mv /build/scripts/start.sh /build/ \
    && apk update \
    && apk upgrade \
    && apk add --no-cache git \
    && go mod tidy \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' . \
    && chmod 755 /build/*
    
###############################################################################
# PACKAGE STAGE

FROM cgr.dev/chainguard/go:latest-dev
EXPOSE 9436
COPY --from=builder /build/* /app/
WORKDIR /app
ENTRYPOINT ["./start.sh"]

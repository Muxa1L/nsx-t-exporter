FROM golang:1.13-alpine as build
LABEL maintainer "Muxa1L"

RUN apk --no-cache add ca-certificates \
 && apk --no-cache add --virtual build-deps git build-base

COPY ./ /nsx-t-exporter
WORKDIR /nsx-t-exporter

RUN go get \
 && go test ./... \
 && go build -o /bin/main

FROM alpine:3.6
LABEL source_repository="https://github.com/Muxa1L/nsx-t-exporter"

RUN apk --no-cache add ca-certificates \
 && addgroup nsxv3exporter \
 && adduser -S -G nsxv3exporter nsxv3exporter
USER nsxv3exporter
COPY --from=build /bin/main /bin/main
ENV LISTEN_PORT=9191
EXPOSE 9191
ENTRYPOINT [ "/bin/main" ]

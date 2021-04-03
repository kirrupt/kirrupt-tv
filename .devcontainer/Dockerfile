FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-3.13

RUN apk add --no-cache elixir  nodejs nodejs-npm git make g++ ca-certificates mysql && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

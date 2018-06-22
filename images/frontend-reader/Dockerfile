## Docker multi-stage build image
FROM alpine/git:latest as repository-getter
ENTRYPOINT /bin/sh

ARG REMOTE_REPOSITORY
ARG SSH_DEPLOY_PRIVATE_KEY

## Uncomments if working with local repo
#COPY ./repository /repository

COPY ../choose-between-remote-and-local-repository.sh /choose-repository.sh
RUN /choose-repository.sh

## Docker multi-stage build image
FROM node:10-alpine as builder

COPY --from=repository-getter /repository/src /code

## TODO: run node build here

## Docker multi-stage run image
FROM node:10-alpine

COPY --from=builder /dist /code

## TODO: run node run here
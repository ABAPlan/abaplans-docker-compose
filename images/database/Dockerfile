## Docker multi-stage build image
FROM alpine/git:latest as repository-getter

ARG REMOTE_REPOSITORY
ARG SSH_DEPLOY_PRIVATE_KEY

## Uncomments if working with local repo
#COPY ./repository /repository

COPY ../choose-between-remote-and-local-repository.sh /choose-repository.sh
RUN /choose-repository.sh

## Docker multi-stage run image
FROM mysql:5.6

COPY --from=repository-getter /repository/database /var/lib/mysql
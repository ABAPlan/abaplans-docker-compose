#!/bin/sh

if [ ! -d "/repository" ]; then
  echo "==== Repository will be pulled from remote location ===="
  mkdir -p /root/.ssh
  echo $SSH_DEPLOY_PRIVATE_KEY > /root/.ssh/id_rsa
  touch /root/.ssh/known_hosts
  ssh-keyscan $REMOTE_REPOSITORY > /root/.ssh/known_hosts

  git clone $REMOTE_REPOSITORY /repository
else
  echo "==== Repository will be pulled from local location ===="
  echo "(and should be in /repository folder already)"
fi

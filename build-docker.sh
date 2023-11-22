#!/bin/bash

set -ex

########### ENV VARS ###########
NAME="recovery"
IMAGE=blockchain_${NAME}
HOSTNAME="wallet"
FLAG="HTB{n0t_y0ur_k3ys_n0t_y0ur_c01n5}"
HACKER_SSH_USER="satoshi"
HACKER_SSH_PWD="L4mb0Pr0j3ct"

# exposed ports
ELECTRS_IP="0.0.0.0"
ELECTRS_PORT=50001
HANDLER_PORT=8888
SSH_PORT=2222
################################

docker rm -f $IMAGE \
    && \
docker build \
    --tag=$IMAGE:latest ./challenge/ \
    --build-arg SSH_USER=$HACKER_SSH_USER \
    --build-arg SSH_PWD=$HACKER_SSH_PWD \
    --build-arg SSH_PORT=$SSH_PORT \
    && \
docker run -it --rm --privileged --cap-add=sys_admin --cap-add=NET_ADMIN --security-opt apparmor:unconfined \
    -e "NAME=$NAME" \
    -e "ELECTRS_IP=$ELECTRS_IP" \
    -e "ELECTRS_PORT=$ELECTRS_PORT" \
    -e "SSH_PORT=$SSH_PORT" \
    -e "HANDLER_PORT=$HANDLER_PORT" \
    -e "FLAG=$FLAG" \
    -p "$ELECTRS_PORT:$ELECTRS_PORT" \
    -p "$HANDLER_PORT:$HANDLER_PORT" \
    -p "$SSH_PORT:$SSH_PORT" \
    --name $IMAGE \
    --hostname $HOSTNAME \
    $IMAGE

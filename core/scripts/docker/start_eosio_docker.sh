#!/usr/bin/env bash
set -o errexit

# Name of the docker container 
CONTAINER_NAME=$1

# Name of the docker image which will be used
IMAGE_NAME=$2

# The port which will be used by nodeos
NODEOS_PORT=$3;

NODEOS_ENVIRONMENT=$4

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NO_COLOR='\033[0m'


# change to script's directory
# cd "$(dirname "$0")/eosio_docker"

if [ ${NODEOS_ENVIRONMENT} != "test" ]
then
    script="sh ./node/init_node.sh"

    echo "\n${CYAN}Starting a local EOS node${NO_COLOR}"
    echo "${GREEN}=== DOCKER: CONTAINER ID ===${NO_COLOR}"
    docker run --name ${CONTAINER_NAME} -d \
    -p ${NODEOS_PORT}:${NODEOS_PORT} -p 4949:4949 \
    --mount type=bind,src="$(pwd)"/node,dst=/opt/eosio/bin/node \
    --mount type=bind,src="$(pwd)"/config,dst=/opt/eosio/bin/config \
    -w "/opt/eosio/bin/" ${IMAGE_NAME} /bin/bash -c "$script"

    
    
else
    script="sh ./node/init_test_node.sh"

    docker run --name ${CONTAINER_NAME} -d \
    -p ${NODEOS_PORT}:${NODEOS_PORT} -p 4949:4949 \
    --mount type=bind,src="$(pwd)"/node,dst=/opt/eosio/bin/node \
    --mount type=bind,src="$(pwd)"/config,dst=/opt/eosio/bin/config \
    -w "/opt/eosio/bin/" ${IMAGE_NAME} /bin/bash -c "$script"
fi
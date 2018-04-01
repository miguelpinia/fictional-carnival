#!/bin/bash
# Imagen del cliente de ethereum utilizado
IMGNAME="ethereum/client-go:v1.8.2"
# Nombre del nodo. Se le pasa como primer parámetro al script
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"nodo1"}
# Si queremos que el nodo sea "detached"
DETACH_FLAG=${DETACH_FLAG:-"-d"}
# Nombre del contenedor
CONTAINER_NAME="ethereum-$NODE_NAME"
# Carpetas para montar los volumenes de la imagen
DATA_ROOT=${DATA_ROOT:-"$(pwd)/.ether-$NODE_NAME"}
DATA_HASH=${DATA_HASH:-"$(pwd)/.ethash"}
NETWORK=${NETWORK:-"--network ethereum"}
echo "Eliminando el viejo contenedor $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
RPC_PORTMAP=
RPC_ARG=
if [[ ! -z $RPC_PORT ]]; then
    RPC_ARG='--rpc --rpcaddr=0.0.0.0 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*"'
    RPC_PORTMAP="-p $RPC_PORT:8545"
fi
# URL del nodo bootstrap.
# echo "Ejecutando"
BOOTNODE_URL='enode://440a7f8ac2dc6c804e79cffa4613ea4187d7f6c1c18ddc4194c354ec6ed82bdd2eda4ba6d4d62600bcff505e7f8841042d354601e820ca81005b9189e75b1448@192.168.0.16:30301'
echo $BOOTNODE_URL
BOOTNODE_URL=${BOOTNODE_URL-$(./getbootnodeurl.sh)}
echo $BOOTNODE_URL
if [ ! -f "$(pwd)/genesis.json" ]; then
    echo "No se encontró el archivo genesis.json. Por favor ejecute 'genesis.sh'. Abortando..."
    exit
fi

if [ ! -d "$DATA_ROOT/keystore" ]; then
    echo "$DATA_ROOT/keystore no se encontró, ejecutando 'geth init'..."
    docker run --rm \
           -v "$DATA_ROOT:/root/.ethereum" \
           -v "$(pwd)/genesis.json:/opt/genesis.json" \
           $IMGNAME init /opt/genesis.json
    echo "...hecho!"
fi
echo "Ejecutando el nuevo contenedor $CONTAINER_NAME"
docker run $DETACH_FLAG --name $CONTAINER_NAME \
       -v "$DATA_ROOT:/root/.ethereum" \
       -v "$DATA_HASH:/root/.ethash" \
       -v "$(pwd)/genesis.json:/opt/genesis.json" \
       $RPC_PORTMAP \
       $IMGNAME --bootnodes=$BOOTNODE_URL $RPC_ARG --cache=512 --verbosity=5 --maxpeers=25 ${@:2}

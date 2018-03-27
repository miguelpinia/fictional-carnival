#!/bin/bash

###########################################################################
# Inicia una nodo de inicio con la imagen oficial de ethereum de alltools #
###########################################################################

# Paramos el contenedor si es que está ejecutándose
docker stop ethereum-bootnode || true && \
# Eliminamos el contenedor si existe
docker rm ethereum-bootnode || true
# Obtenemos la imagen del cliente de docker que queremos utilizar
IMGNAME="ethereum/client-go:alltools-v1.7.3"
DATA_ROOT=${DATA_ROOT:-$(pwd)}
mkdir -p $DATA_ROOT/.bootnode
# Genera el id del nodo.
if [ ! -f $DATA_ROOT/.bootnode/boot.key ]; then
    echo "No se encontró $DATA_ROOT/.bootnode/boot.key, generando..."
    docker run --rm \
           -v $DATA_ROOT/.bootnode:/opt/bootnode \
           $IMGNAME bootnode --genkey /opt/bootnode/boot.key
    echo "... Hecho!"
fi
# Inicializamos la red de ethereum
[ ! "$(docker network ls | grep ethereum)" ] && docker network create ethereum
# Levantamos una imagen con el nodo bootstrap indicando los puertos
# que se van a mapear para poder agregar nodos desde otras máquinas.
docker run -d --name ethereum-bootnode \
       -v $DATA_ROOT/.bootnode:/opt/bootnode \
       -p 8545:8545 -p 30303:30303 \
       --network ethereum \
       $IMGNAME bootnode --nodekey /opt/bootnode/boot.key --verbosity=5 "$@"

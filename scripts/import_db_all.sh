#!/bin/bash

ACTUAL_DIR=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ${SCRIPT_DIR}/../.env
cd $SCRIPT_DIR/../odoo
docker compose run mydb psql postgresql://$POSTGRES_USER:$PGPASSWORD@mydb:$DB_PORT_5432_TCP_PORT/$POSTGRES_DB < $ACTUAL_DIR/"$1"
cd $ACTUAL_DIR

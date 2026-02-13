#!/bin/bash

PWD=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR
. ${SCRIPT_DIR}/../.env
cd $SCRIPT_DIR/../odoo
docker compose run web /usr/bin/python3 /usr/bin/odoo --db_host mydb --db_port $DB_PORT_5432_TCP_PORT --db_user $POSTGRES_USER --db_password $PGPASSWORD -d $POSTGRES_DB --update all --stop-after-init

#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0") <DATABASE>

crear base de datos de Odoo.

Parámetros:
    NameDatabase   Nombre de la base de datos

Opciones:
    -h, --help     Muestra esta ayuda

Ejemplo:
    $(basename "$0") social

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
	show_help
	exit 0
fi

ACTUAL_DIR=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ACTUAL_DIR: $ACTUAL_DIR"

. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose run mydb psql postgresql://$POSTGRES_USER:$PGPASSWORD@mydb:$DB_PORT_5432_TCP_PORT/postgres -c "CREATE DATABASE $1;"
cd $ACTUAL_DIR

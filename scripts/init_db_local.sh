#!/bin/bash

show_help() {
    cat << EOF
Uso: $(basename "$0")

Inicializa la base de datos local de Odoo con el módulo base.

Opciones:
    -h, --help     Muestra esta ayuda

Descripción:
    Ejecuta Odoo en modo inicialización (-i base) en el entorno Docker local.

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

PWD=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR
. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose run web /usr/bin/python3 /usr/bin/odoo --db_host mydb --db_port $DB_PORT_5432_TCP_PORT --db_user $POSTGRES_USER --db_password $PGPASSWORD -i base -d $POSTGRES_DB --stop-after-init
cd $PWD

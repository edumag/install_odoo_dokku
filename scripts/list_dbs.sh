#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0")

Lista las bases de datos PostgreSQL disponibles.

Opciones:
    -h, --help    Muestra esta ayuda

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	show_help
	exit 0
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose exec -T mydb psql -U $POSTGRES_USER -l -t | cut -d '|' -f1 | tr -d ' ' | grep -v '^$'

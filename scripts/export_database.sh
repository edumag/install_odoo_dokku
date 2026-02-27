#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0") <nombre_base_datos> <archivo_salida.sql>

Exporta una base de datos PostgreSQL de Odoo a un archivo SQL.

Parámetros:
    nombre_base_datos   Nombre de la base de datos a exportar
    archivo_salida.sql  Ruta del archivo SQL de salida

Opciones:
    -h, --help     Muestra esta ayuda

Ejemplo:
    $(basename "$0") social backup_social.sql

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ] || [ -z "$2" ]; then
	show_help
	exit 0
fi

NAME_DATABASE=$1
OUTPUT_FILE=$2

ACTUAL_DIR=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ACTUAL_DIR: $ACTUAL_DIR"

. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose run mydb pg_dump -v postgresql://$POSTGRES_USER:$PGPASSWORD@mydb:$DB_PORT_5432_TCP_PORT/$NAME_DATABASE >$ACTUAL_DIR/"$OUTPUT_FILE"
cd $ACTUAL_DIR
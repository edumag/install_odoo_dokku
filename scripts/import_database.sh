#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0") <archivo.sql>

Importa un archivo SQL a la base de datos PostgreSQL de Odoo.

En caso de error por no existir la base de datos, puedes crearla con el script "create_database.sh".

Parámetros:
    NameDatabase   Nombre de la base de datos
    archivo.sql    Ruta al archivo SQL a importar

Opciones:
    -h, --help     Muestra esta ayuda

Ejemplo:
    $(basename "$0") social /ruta/a/backup.sql

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
	show_help
	exit 0
fi

NAME_DATABASE=$1
FILE_SQL=$2

ACTUAL_DIR=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ACTUAL_DIR: $ACTUAL_DIR"

. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose run mydb psql -v ON_ERROR_STOP=1 postgresql://$POSTGRES_USER:$PGPASSWORD@mydb:$DB_PORT_5432_TCP_PORT/$NAME_DATABASE <$ACTUAL_DIR/"$FILE_SQL"
cd $ACTUAL_DIR

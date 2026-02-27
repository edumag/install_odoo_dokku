#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0") <NameDatabase> [module_name]

Actualiza módulos en la base de datos local.

Parametros:
    NameDatabase   Nombre de la base de datos
    module_name    Nombre del módulo a actualizar (opcional, por defecto: all)

Opciones:
    -h, --help     Muestra esta ayuda

Descripción:
    Ejecuta Odoo en modo actualización (--update all|module_name) en el entorno Docker local.

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	show_help
	exit 0
fi

NameDatabase=$1
ModuleName=${2:-all}

PWD=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
echo $SCRIPT_DIR
. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose run web /usr/bin/python3 /usr/bin/odoo --db_host mydb --db_port $DB_PORT_5432_TCP_PORT --db_user $POSTGRES_USER --db_password $PGPASSWORD -d $NameDatabase --update $ModuleName --stop-after-init

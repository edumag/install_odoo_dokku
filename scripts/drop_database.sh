#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0") <DATABASE>

Elimina una base de datos de PostgreSQL.

ATENCIÓN: Esta acción es destructiva y no se puede deshacer.

Parámetros:
    DATABASE   Nombre de la base de datos a eliminar

Opciones:
    -h, --help     Muestra esta ayuda
    -f, --force    No pedir confirmación

Ejemplo:
    $(basename "$0") social
    $(basename "$0") -f social

EOF
}

FORCE=0

# Procesar argumentos
while [[ $# -gt 0 ]]; do
	case $1 in
		-h|--help)
			show_help
			exit 0
			;;
		-f|--force)
			FORCE=1
			shift
			;;
		-*)
			echo "Error: Opción desconocida $1"
			show_help
			exit 1
			;;
		*)
			DATABASE="$1"
			shift
			;;
	esac
done

# Verificar que se proporcionó nombre de base de datos
if [ -z "$DATABASE" ]; then
	echo "Error: Debe especificar el nombre de la base de datos"
	show_help
	exit 1
fi

# Confirmación (a menos que se use -f)
if [ $FORCE -eq 0 ]; then
	read -p "¿Está seguro de que desea eliminar la base de datos '$DATABASE'? (s/N): " CONFIRM
	if [[ ! "$CONFIRM" =~ ^[Ss]$ ]]; then
		echo "Operación cancelada."
		exit 0
	fi
fi

ACTUAL_DIR=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ACTUAL_DIR: $ACTUAL_DIR"
echo "Eliminando base de datos: $DATABASE"

. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose run mydb psql -v ON_ERROR_STOP=1 postgresql://$POSTGRES_USER:$PGPASSWORD@mydb:$DB_PORT_5432_TCP_PORT/postgres -c "DROP DATABASE \"$DATABASE\";"
cd $ACTUAL_DIR

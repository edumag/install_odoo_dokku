#!/bin/bash

show_help() {
	cat <<EOF
Uso: $(basename "$0") <servicio>

Entra a un container Docker del entorno Odoo para ejecutar bash.

Servicios disponibles:
    mydb    Container de PostgreSQL
    web     Container de Odoo

Opciones:
    -h, --help     Muestra esta ayuda

Ejemplo:
    $(basename "$0") mydb    # Entra al container de PostgreSQL
    $(basename "$0") web     # Entra al container de Odoo

EOF
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
	show_help
	exit 0
fi

SERVICIO="$1"

# Validar que el servicio sea mydb o web
if [ "$SERVICIO" != "mydb" ] && [ "$SERVICIO" != "web" ]; then
	echo "Error: Servicio '$SERVICIO' no válido."
	echo "Servicios disponibles: mydb, web"
	exit 1
fi

ACTUAL_DIR=$(pwd)
# Recoger directorio del script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ACTUAL_DIR: $ACTUAL_DIR"
echo "Entrando al container: $SERVICIO"
echo ""

. ${SCRIPT_DIR}/../odoo/.env
cd $SCRIPT_DIR/../odoo
docker compose exec $SERVICIO bash
cd $ACTUAL_DIR

#!/bin/bash

source .env

# Solo si no está instalado ya.
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres

if [[ $1 == "remove" ]]; then # If no variable.
  ACTION=$1
fi

if [[ "$ACTION" == "remove" ]]; then
  dokku apps:destroy $APPNAME
  dokku postgres:destroy $PGNAME
  exit
fi

if [[ -z "$APPNAME" ]]; then
  echo "Error: missing APPNAME variable!" 1>&2
  exit_abnormal                            # Exit abnormally.
fi

if [[ -z "$PGNAME" ]]; then
  echo "Error: missing PGNAME variable" 1>&2
  exit_abnormal                            # Exit abnormally.
fi

if [[ -z "$MASTERPASSWORD" ]]; then
  echo "Error: missing MASTERPASSWORD variable!" 1>&2
  exit_abnormal                            # Exit abnormally.
fi

if [[ -z "$PGPASSWORD" ]]; then
  echo "Error: missing PGPASSWORD variable!" 1>&2
  exit_abnormal                            # Exit abnormally.
fi

if [[ -z "$EMAIL" ]]; then
  echo "Error: missing EMAIL variable!" 1>&2
  exit_abnormal                            # Exit abnormally.
fi

if [[ -z "$DOMAIN" ]]; then
  echo "Error: missing DOMAIN variable!" 1>&2
  exit_abnormal                            # Exit abnormally.
fi

echo "Odoo appname: ${APPNAME}"
echo "Odoo version: ${VERSION}"
echo "Odoo master password: ${MASTERPASSWORD}"
echo "PostgreSQL service name: ${PGNAME}"
echo "PostgreSQL user name: odoo"
echo "PostgreSQL odoo user password: ${PGPASSWORD}"
echo "Email: ${EMAIL}"
echo "Domain: ${DOMAIN}"
echo
read -p "Press enter to continue"

dokku apps:create $APPNAME
dokku domains:add $APPNAME $DOMAIN

dokku postgres:create $PGNAME
dokku postgres:link $PGNAME $APPNAME
dokku letsencrypt:set $APPNAME email $EMAIL

echo "
  CREATE user odoo WITH password '$PGPASSWORD';
  ALTER user odoo WITH createdb;
" | dokku postgres:connect $PGNAME

cd /var/lib/dokku/data/storage/
sudo mkdir -p {$APPNAME/odoo-web-data,$APPNAME/config,$APPNAME/addons}
sudo chown -R 100:100 {$APPNAME/odoo-web-data,$APPNAME/config,$APPNAME/addons}
cd -

# chown -R 101:101 $APPNAME
dokku storage:mount $APPNAME /var/lib/dokku/data/storage/$APPNAME/addons:/mnt/extra-addons
# dokku storage:mount $APPNAME /var/lib/dokku/data/storage/$APPNAME/config:/etc/odoo
dokku storage:mount $APPNAME /var/lib/dokku/data/storage/$APPNAME/odoo-web-data:/var/lib/odoo
dokku storage:report $APPNAME

### Maperar puertos

dokku ports:add $APPNAME http:80:8069
dokku ports:add $APPNAME https:443:8069


#  TARGET_UID=32767 \
dokku config:set $APPNAME \
  ODOO_ADMIN_PASSWD=$MASTERPASSWORD\
  DB_PORT_5432_TCP_ADDR=$DB_PORT_5432_TCP_ADDR \
  DB_PORT_5432_TCP_PORT=$DB_PORT_5432_TCP_PORT \
  DB_ENV_POSTGRES_USER=$POSTGRES_USER \
  DB_ENV_POSTGRES_PASSWORD=$PGPASSWORD \
  ODOO_addons_path=/mnt/extra-addons,/opt/odoo/sources/odoo/addons \
  DOKKU_DOCKERFILE_START_CMD="odoo"

dokku nginx:set $APPNAME client-max-body-size 50m
dokku nginx:set $APPNAME client-body-timeout 200s
dokku nginx:show-config $APPNAME

echo
echo Instalación realizada.
echo
echo Una vez realizado el primer deploy, puede actviar letsencrypt con:
echo dokku letsencrypt:enable $APPNAME
echo
echo Para ver los logs de la aplicación:
echo dokku logs $APPNAME


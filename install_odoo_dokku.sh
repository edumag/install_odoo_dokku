#!/bin/bash

source .env

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

# Solo si no está instalado ya.
# sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres

dokku postgres:create $PGNAME
dokku postgres:link $PGNAME $APPNAME

echo "
  CREATE user odoo WITH password '$PGPASSWORD';
  ALTER user odoo WITH createdb;
" | dokku postgres:connect $PGNAME

cd /var/lib/dokku/data/storage/
mkdir -p {$APPNAME/odoo-web-data,$APPNAME/config,$APPNAME/addons}
cd -


# echo '#!/bin/bash
# echo $0
# pip3 install codicefiscale
# pip3 install phonenumbers2
# echo "Install wkhtmltox..."
# apt -y install wget
# wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
# apt -y install ./wkhtmltox_0.12.6-1.focal_amd64.deb
# ' > $APPNAME/scripts/startup.sh

# chmod +x $APPNAME/scripts/startup.sh

# echo '# list the OCA project dependencies, one per line
# # add a github url if you need a forked version
# # url is not required for OCA projects
# # project https://github.com/OCA/project.git $VERSION
# # project $VERSION
# # account-payment $VERSION
# # hr $VERSION
# # l10n-spain $VERSION
# ' >> $APPNAME/addons/oca_dependencies.txt

# chown -R 101:101 $APPNAME
dokku storage:mount $APPNAME /var/lib/dokku/data/storage/$APPNAME/addons:/mnt/extra-addons
# dokku storage:mount $APPNAME /var/lib/dokku/data/storage/$APPNAME/config:/etc/odoo
dokku storage:mount $APPNAME /var/lib/dokku/data/storage/$APPNAME/odoo-web-data:/var/lib/odoo
dokku storage:report $APPNAME

### Maperar puertos

dokku proxy:ports-set $APPNAME https:443:8069
dokku proxy:ports-set $APPNAME http:80:8069

#  TARGET_UID=32767 \
dokku config:set $APPNAME \
  ODOO_ADMIN_PASSWD=$MASTERPASSWORD\
  DB_PORT_5432_TCP_ADDR=$DB_PORT_5432_TCP_ADDR \
  DB_PORT_5432_TCP_PORT=$DB_PORT_5432_TCP_PORT \
  DB_ENV_POSTGRES_USER=$POSTGRES_USER \
  DB_ENV_POSTGRES_PASSWORD=$PGPASSWORD \
  ODOO_addons_path=/mnt/extra-addons,/opt/odoo/sources/odoo/addons \
  DOKKU_DOCKERFILE_START_CMD="odoo"


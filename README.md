# Instalar Odoo 18.0 en Dokku

## Configurar

Copiar el archivo `.env-example` a `.env`

    cp .env-example .env

Adaptar las variables de entorno.

Subir a servidor el fichero .env y el script install_odoo_dokku.sh

    scp .env install_odoo_dokku.sh {DOKKU_USER}@{DOKKU_HOST}:./


## En servidor

Ejecutar script.

    ./install_odoo_dokku.sh

## En local

    git clone https://github.com/odoo/docker.git
    cp -r docker/18.0/* ./
    rm -fr docker

    git remote add dokku dokku@{DOKKU_HOST}:{DOKKU_APP_NAME}
    git push dokku master

## Instalar Let's Encrypt

    source .env
    dokku config:set --no-restart $APPNAME DOKKU_LETSENCRYPT_EMAIL=$EMAIL
    dokku letsencrypt $APPNAME $DOMAIN

## Varios

### Eliminar aplicación en dokku

    ./install_odoo_dokku.sh remove

### Instalar addons

#### l10n_es_aeat y l10n_es_aeat_mod303

    git clone https://github.com/OCA/l10n-spain.git
    cp -r l10n-spain/l10n_es_aeat_mod303 ./addons/
    cp -r l10n-spain/l10n_es_aeat ./addons/
    rm -fr l10n-spain

#### account_tax_balance

#### date_range y account_tax_balance

Se pueden bajar desde https://odoo-community.org/shop

### Repositorio OCA

    https://github.com/OCA

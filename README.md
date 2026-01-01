# Instalar Odoo 18.0 en Dokku

![odoo18-01.png](./img/odoo18-01.png){width="100%" height="auto"}

Proceso de instalación de odoo en servidor vps con dokku.

## Bajar instalador

wget https://github.com/edumag/install_odoo_dokku/archive/refs/heads/master.zip
unzip master.zip
cd install_odoo_dokku-master

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

```
source .env
dokku letsencrypt:set $APPNAME email $EMAIL
dokku letsencrypt:enable $APPNAME
dokku letsencrypt:auto-renew
dokku letsencrypt:cron-job --add
```

## Instalar addons

### l10n_es_aeat y l10n_es_aeat_mod303

    git clone https://github.com/OCA/l10n-spain.git
    cp -r l10n-spain/l10n_es_aeat_mod303 ./addons/
    cp -r l10n-spain/l10n_es_aeat ./addons/
    rm -fr l10n-spain

### date_range y account_tax_balance

Se pueden bajar desde https://odoo-community.org/shop

### Subir módulos al servidor

    scp -r addons/* {DOKKU_USER}@{DOKKU_HOST}:/var/lib/dokku/data/storage/$APPNAME/addons/

### Reiniciar aplicación

    dokku ps:restart $APPNAME

## Post instalación

Al entrar por primera vez nos pedirá que configuremos la base de datos.

### Activar modo desarrollador

Ir a configuraciones -> Herramientas de desarrollo -> Modo desarrollador.

### Activar módulos

Ir a Aplicaciones.

En modo desarrollador tendremos la opción de actualizar la lista de módulos y podremos activarlos.


## Varios

### Eliminar aplicación en dokku

    ./install_odoo_dokku.sh remove

### Gestionar base de datos.

Desde https://{DOMINIO}/web/database/manager podremos Crear, restaurar, hacer
un backup o cambiar contraseña maestra.


### Repositorio OCA

    https://github.com/OCA

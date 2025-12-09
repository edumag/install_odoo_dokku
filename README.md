# Readme

## En local

    git clone https://github.com/odoo/docker.git
    cp -r docker/19.0/* ./
    rm -fr docker

## En servidor


### Crear aplicación

    dokku apps:create gestion

### Base de datos

    dokku postgres:create gestion-db

### Vinculamos app con db

    dokku postgres:link gestion-db gestion

### configuración

    dokku config:set --no-restart gestion DB_ENV_POSTGRES_USER=postgres
    dokku config:set --no-restart gestion DB_ENV_POSTGRES_PASSWORD=++++++++++++++++++++++++++++++++
    dokku config:set --no-restart gestion DB_PORT_5432_TCP_ADDR=++++++++++++
    dokku config:set --no-restart gestion DB_PORT_5432_TCP_PORT=5432

### Maperar puertos

    dokku proxy:ports-set gestion https:443:8069
    dokku proxy:ports-set gestion http:80:8069


### Dominio

    dokku domains:add gestion gestion.lesolivex.com

### Ver variables globales

    dokku config:show gestion


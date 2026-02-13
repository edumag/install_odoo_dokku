# Update addons

@todo Hay que copiar modulo a modulo en la carpeta rais de addons sin subcarpetas.

Obtener todos los repositorios de los addons requeridos en modulos_repositorios

Ir a la versión 16.0

```bash
cd modulos_repositorios/modulo
git checkout 16.0
git pull
```

Copiar a carpeta addons

```bash
cp -r modulos_repositorios/modulo/* addons/
```

Borrar carpeta .git de addons

```bash
rm -rf addons/*/.git
```

Subir a servidor

```bash
scp -r addons/* $SERVIDOR:/var/lib/dokku/data/storage/$APLICACION/addons/
```

o

```bash
rsync -azP addons/ $SERVIDOR:/var/lib/dokku/data/storage/$APPNAME/addons/
```

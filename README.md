# docker-paca-sinp
Scripts docker-compose du SINP PACA.

## Docker installation

### Préparation
Nous utiliserons un dossier nommé *docker* dans le *home* de l'utilisateur *admin*.

### Synchronisation avec le serveur

Pour synchroniser ces fichiers avec le serveur utiliser `rsync` :
 - Se placer dans le dossier contenant les fichiers Docker pour l'instance désirée. Ex. : *web-srv*
 - Lancer la commande `rsync` suivante, ici pour *web-srv* :

```shell
rsync -av --delete-excluded \
  --exclude='/.git' \
  --exclude='/.gitignore'  \
  --exclude='/.editorconfig' \
  ./ \
  admin@web-paca-sinp:/home/admin/docker/
 ```

## Docker images

### InfluxDb
#### Récupérer le fichier de configuration par défaut

```shell
docker run --rm influxdb:1.7.9 influxd config > web-srv/monitor.silene.eu/influxdb/influxdb.sample.conf
```

### Telegraf
#### Récupérer le fichier de configuration par défaut

```shell
docker run --rm telegraf:1.13.0 telegraf config | \
  tee web-srv/monitor.silene.eu/telegraf/telegraf.sample.conf > /dev/null
```

### Portainer
#### Brcypter le mot de passe admin

```shell
 htpasswd -bnBC 10 "" <mot-de-passe-admin> | tr -d ':\n'
```

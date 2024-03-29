# sinp-paca-srv

Contient les scripts utilisés pour la mise en place des serveurs du SINP PACA.
Scripts : nginx, docker, bash...

## Documentation de l'installation des serveurs
Voir la documentation sur le Wiki SINP du CBNA : https://sinp-wiki.cbn-alpin.fr

## Synchronisation locale vers serveur

### Dossier Docker
Pour synchroniser ces fichiers avec le serveur utiliser `rsync` :
 - Se placer à la racine du dépôt
 - Lancer la commande `rsync` suivante, ici pour *web-srv* et le dossier *docker* :

```shell
rsync -av ./web-srv/docker/ admin@web-paca-sinp:/home/admin/docker/
```

### Fichiers de l'Atlas
Utiliser `rsync`. Exemple pour synchroniser les images personnalisables depuis le dossier `/home/geonat/www/atlas` :

```shell
rsync -av --size-only ./static/custom/images/ geonat@web-paca-sinp:/home/geonat/www/atlas/static/custom/images/
```
Cette commande utilise l'option --size-only pour baser le transfert seulement sur les différences de tailles des fichiers sans prendre en compte les métadonnées.

## Commandes utiles avec les images Docker

### InfluxDb
#### Récupérer le fichier de configuration par défaut

```shell
docker run --rm influxdb:1.7.9 influxd config > web-srv/monitor.silene.eu/influxdb/influxdb.sample.conf
```

### Telegraf
#### Récupérer le fichier de configuration par défaut

```shell
docker run --rm telegraf:1.13.0 telegraf config | \
  tee web-srv/monitor.silene.eu/telegraf/telegraf.sample.conf > /dev/null
```

### Portainer
#### Brcypter le mot de passe admin

```shell
 htpasswd -bnBC 10 "" <mot-de-passe-admin> | tr -d ':\n'
```

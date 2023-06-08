# Docker

## Synchronisation serveur

### Synchroniser un dossier Docker

Pour transférer uniquement un dossier contenant les fichiers Docker d'un domaine
sur le serveur, utiliser `rsync` en testant avec l'option `--dry-run` (à supprimer quand tout est ok) :

```shell
# Exemple pour awstats
rsync -av --exclude .gitignore ./web-srv/home/admin/docker/awstats/ admin@web-paca-sinp:/home/admin/docker/awstats/ --dry-run
```

### Synchroniser l'ensemble des dossiers Docker

Pour synchroniser ces fichiers avec le serveur utiliser `rsync` :
 - Se placer à la racine du dépôt
 - Lancer la commande `rsync` suivante, ici pour *web-srv* et le dossier *docker* avec l'option `--dry-run` (à supprimer quand tout est ok) :

```shell
rsync -av --exclude .gitignore ./web-srv/home/admin/docker/ admin@web-paca-sinp:/home/admin/docker/ --dry-run
```
